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

  let useCounter = (~props=?, ()) => {
    let (count, setCount) = switch props {
      | None => React.useState(_ => 0)
      | Some(value) => React.useState(_ => value)
    }
    let increment = React.useCallback(() => setCount((x) => x+1))
    {"count": count, "increment": increment}
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
      let { result } = HookTestingLibrary.render(() => Counter.useCounter(), ())
      result.current["count"]
      -> expect
      -> toBe(0)
    })
})
