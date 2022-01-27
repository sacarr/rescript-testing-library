open Jest
open Expect
module HookTestingLibrary = ReactHookTestingLibrary.RenderHook

module Counter = {
  type action = Increment | Decrement
  type state = { count: int }
  type result = (int, () => ())
  let reducer = (state, action) => {
      switch action {
      | Increment => { count: state.count + 1 }
      | Decrement => { count: state.count - 1 }
      }
  }

  let useCounter = (~initialValue=0, ()) => {
    let (count, setCount) = React.useState(_ => initialValue)
    let increment = React.useCallback1(() => setCount((x) => x+1), [])
    let reset = React.useCallback1(() => setCount((_) => initialValue), [initialValue])
    {"count": count, "increment": increment, "reset": reset}
  }

  @react.component
  let make = () => {
      let ( state, dispatch ) = React.useReducer(reducer, {count: 0})
    <>
      { React.string("Count: " ++ Belt.Int.toString(state.count)) }
      <button onClick={(_) => dispatch(Increment)}> {React.string("+")} </button>
      <button onClick={(_) => dispatch(Decrement)}> {React.string("-")} </button>
    </>
  }
}

describe("Rescript-testing-library/react-hooks test suite", () => {
    test("should use counter", () => {
      let { result, _, _, _ } = HookTestingLibrary.render(() => Counter.useCounter(), ())
      result.current["count"]
      -> expect
      -> toBe(0)
    })

    test("should set counter to the initial value", () => {
      let initialValue = 13
      let { result, _, _, _ } = HookTestingLibrary.render(() => Counter.useCounter(~initialValue=initialValue, ()), ())
      result.current["count"]
      -> expect
      -> toBe(initialValue)
    })

    test("should set counter to the updated initial value", () => {
      let initialValue = ref(0)
      let { result, rerender, _, _ } = HookTestingLibrary.render(() => Counter.useCounter(~initialValue=initialValue.contents, ()), ())
      
      initialValue.contents = 13
      rerender()

      HookTestingLibrary.act(() => {
        result.current["reset"]()
      })

      result.current["count"]
      -> expect
      -> toBe(initialValue.contents)
    })
})
