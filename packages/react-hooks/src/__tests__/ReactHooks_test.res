open Jest
open Expect

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
  open ReactHookTestingLibrary.RenderHook
    test("should use counter", () => {
      let initialProps = {Js.Nullable.return({initialProps: { initialValue: 0 }, wrapper: None })}
      let callback = (/*{ initialValue }*/) => Counter.useCounter()
      let { result, _, _, _ } = render(callback, initialProps, ())
      result.current["count"]
      -> expect
      -> toBe(0)
    })

    test("should increment counter", () => {
      let initialProps = {Js.Nullable.return({initialProps: { initialValue: 0 }, wrapper: None })}
      let callback = (/*{ initialValue }*/) => Counter.useCounter()
      let { result, _, _, _ } = render(callback, initialProps, ())

      act(() => result.current["increment"]() )

      result.current["count"]
      -> expect
      -> toBe(1)
    })

    test("should set counter to a custom initial value", () => {
      let initialValue = 13
      let initialProps = {Js.Nullable.return({initialProps: { initialValue: initialValue }, wrapper: None })}
      let callback = (/*{ initialValue }*/) => Counter.useCounter(~initialValue=initialValue, ())
      let { result, _, _, _ } = render(callback, initialProps, ())
      result.current["count"]
      -> expect
      -> toBe(initialValue)
    })

    test("should not update counter when counter was not reset", () => {
      let initialValue = ref(0)
      let initialProps = {Js.Nullable.return({initialProps: { initialValue: initialValue.contents }, wrapper: None })}
      let callback = (/*{ initialValue }*/) => Counter.useCounter(~initialValue=initialValue.contents, ())
      let { result, rerender, _, _ } = render(callback, initialProps, ())
      
      initialValue.contents = 13
      rerender(Js.Nullable.return({initialValue: initialValue.contents}))

      result.current["count"]
      -> expect
      -> toBe(0)
    })

    test("should reset counter to an updated initial value after rerendering", () => {
      let initialValue = ref(0)
      let initialProps = {Js.Nullable.return({initialProps: { initialValue: initialValue.contents }, wrapper: None })}
      let callback = (/*{ initialValue }*/) => Counter.useCounter(~initialValue=initialValue.contents, ())
      let { result, rerender, _, _ } = render(callback, initialProps, ())
      
      initialValue.contents = 13
      rerender(Js.Nullable.return({initialValue: initialValue.contents}))

      act(() => result.current["reset"]())

      result.current["count"]
      -> expect
      -> toBe(initialValue.contents)
    })

    test("should reset counter to an updated initial value when passed initial props", () => {
      let initialValue = ref(0)
      let initialProps = {Js.Nullable.return({initialProps: { initialValue: initialValue.contents }, wrapper: None })}
      let callback = (/*{ initialValue }*/) => Counter.useCounter(~initialValue=initialValue.contents, ())
      let { result, rerender, _, _ } = render(callback, initialProps, ())
      
      initialValue.contents = 13
      rerender(Js.Nullable.return({initialValue: initialValue.contents}))

      act(() => result.current["reset"]())

      result.current["count"]
      -> expect
      -> toBe(initialValue.contents)
    })
})
