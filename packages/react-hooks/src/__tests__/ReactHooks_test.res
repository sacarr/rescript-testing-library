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
      let callback = _ => Counter.useCounter()
      let { result, _, _, _ } = renderHook(SimpleHook(callback), ())
      result.current["count"]
      -> expect
      -> toBe(0)
    })

    test("should increment counter", () => {
      let callback = () => Counter.useCounter()
      let { result, _, _, _ } = renderHook(SimpleHook(callback), ())

      act(() => result.current["increment"]() )

      result.current["count"]
      -> expect
      -> toBe(1)
    })

    test("should set counter to a custom initial value", () => {
      let initialValue = 13
      let callback = () => Counter.useCounter(~initialValue=initialValue, ())
      let { result, _, _, _ } = renderHook(SimpleHook(callback), ())
      result.current["count"]
      -> expect
      -> toBe(initialValue)
    })

    test("should not update counter", () => {
      let initialValue = ref(0)
      let callback = () => Counter.useCounter(~initialValue=initialValue.contents, ())
      let { result, rerender, _, _ } = renderHook(SimpleHook(callback), ())
      initialValue.contents = 13
      let newProps = Some(Js.Nullable.return({initialValue: initialValue.contents}))
      rerender(newProps)

      result.current["count"]
      -> expect
      -> toBe(0)
    })

    test("should update counter even if prop changes are not reRendered", () => {
      let initialValue = ref(0)
      let callback = () => Counter.useCounter(~initialValue=initialValue.contents, ())
      let { result, rerender, _, _ } = renderHook(SimpleHook(callback), ())
      initialValue.contents = 13
      let newProps = Some(Js.Nullable.null)

      rerender(newProps)

      act(() => result.current["reset"]())

      result.current["count"]
      -> expect
      -> toBe(initialValue.contents)
    })

    test("should reset counter to updated initial value", () => {
      let initialProps = {Js.Nullable.return({initialProps: { initialValue: 0 }, wrapper: None })}
      let callback = ({ initialValue }) => Counter.useCounter(~initialValue, ())
      let { result, rerender, _, _ } = renderHook(HookWithProps(callback), ~initialProps, ())
      
      let newProps = Some(Js.Nullable.return({ initialValue: 13 }))     
      rerender(newProps)
      act(() => result.current["reset"]())

      result.current["count"]
      -> expect
      -> toBe(13)
    })

    /*
    test("should clean up side effect", () => {
      let id = ref("first")
      let callback = () => {
        React.useEffect1(() => {
          sideEffect.start(id.contents)
          () => sideEffect.stop(id.contents)
        }, [id.contents])
      }
      let { _, rerender, _, _ } = renderHook(SimpleHook(callback), ())
      
      id = "second"
      rerender()

      sideEffect.get("first") -> expect -> toBe(false)
      sideEffect.get("second") -> expect -> toBe(true)
    })
    */
})
