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
  let calculate = (~initialValue=0, ()) => {
    let (count, setCount) = React.useState(_ => initialValue)
    let (calculation, setCalculation) = React.useState(_ => initialValue)
    let increment = React.useCallback1(() => setCount((x) => x+1), [])
    let reset = React.useCallback1(() => setCount((_) => initialValue), [initialValue])
    let calculate = React.useEffect1(() => {
      setCalculation((_) => count * 2)
      None
  }, [count])
    {"calculation": calculation, "calculate": calculate, "increment": increment, "reset": reset}

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
      let hookCb = Hook(_ => Counter.useCounter())
      let { result, _ } = renderHook(hookCb, ())
      result.current["count"]
      -> expect
      -> toBe(0)
    })

    test("should increment counter", () => {
      let hookCb = Hook(() => Counter.useCounter())
      let { result, _ } = renderHook(hookCb, ())

      act(() => {
        result.current["increment"]() 
        result.current["increment"]()
      })

      result.current["count"]
      -> expect
      -> toBe(2)
    })

    test("should set counter to a custom initial value", () => {
      let initialValue = 13
      let hookCb = Hook(() => Counter.useCounter(~initialValue=initialValue, ()))
      let { result, _ } = renderHook(hookCb, ())
      result.current["count"]
      -> expect
      -> toBe(initialValue)
    })

    test("should not update counter", () => {
      let initialValue = ref(0)
      let hookCb = Hook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
      let { result, rerender, _ } = renderHook(hookCb, ())
      initialValue.contents = 13
      let newProps = Js.Nullable.return({initialValue: initialValue.contents})
      rerender(newProps)

      result.current["count"]
      -> expect
      -> toBe(0)
    })

    test("should update counter even if prop changes are not reRendered", () => {
      let initialValue = ref(0)
      let hookCb = Hook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
      let { result, rerender, _ } = renderHook(hookCb, ())
      initialValue.contents = 13

      rerender(Js.Nullable.null)

      act(() => result.current["reset"]())

      result.current["count"]
      -> expect
      -> toBe(initialValue.contents)
    })

    test("should reset counter to updated initial value", () => {
      let initialProps = {{initialProps: { initialValue: 0 }, wrapper: None }}
      let hookCb = HookWithProps(({ initialValue }) => Counter.useCounter(~initialValue, ()))
      let { result, rerender, _ } = renderHook(hookCb, ~initialProps, ())
      
      let newProps = Js.Nullable.return({ initialValue: 13 })
      rerender(newProps)
      act(() => result.current["reset"]())

      result.current["count"]
      -> expect
      -> toBe(13)
    })

    test("should reset counter to updated value using an object", () => {
      let initialProps = {{initialProps: { initialValue: 0 }, wrapper: None }}
      let hookCb = HookWithProps(({ initialValue }) => Counter.useCounter(~initialValue, ()))
      let { result, rerender, _ } = renderHook(hookCb, ~initialProps, ())
      
      let newProps = Js.Nullable.return({ initialValue: 13 })
      rerender(newProps)
      act(() => result.current["reset"]())

      result.current["count"]
      -> expect
      -> toBe(13)
    })

/*
    test("should clean up side effect", () => {
      let initialProps = {{initialProps: { initialValue: 0 }, wrapper: None }}
      let hookCb = HookWithProps(({ initialValue }) => {
        React.useEffect1(() => {
          let _ = Counter.useCounter(~initialValue, ())
            Counter.useCounter.calculate()
        }, [initialValue])
      })
      let { result, rerender, _ } = renderHook(hookCb, ~initialProps, ())
      
      let newProps = Some({ initialValue: 13 })   
      rerender(newProps)

      result.current["calculation"]
      -> expect
      -> toBe(26)
    })
*/
})
