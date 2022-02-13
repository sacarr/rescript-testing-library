open Jest
open Expect
open ReactHookTestingLibrary

module Calculator = {
  type props = {initialValue: int}
  type result = {
    calculation: int,
    calculate: unit => unit,
    increment: React.callback<unit, unit>,
    reset: React.callback<unit, unit>,
  }
  let calculate = (~initialValue=0, ()) => {
    let (count, setCount) = React.useState(_ => initialValue)
    let (calculation, setCalculation) = React.useState(_ => initialValue)
    let increment = React.useCallback1(() => setCount(x => x + 1), [])
    let reset = React.useCallback1(() => setCount(_ => initialValue), [initialValue])
    let calculate = () => React.useEffect1(() => {
        setCalculation(_ => count * 2)
        Some(() => setCalculation(_ => initialValue))
      }, [count])
    {calculation: calculation, calculate: calculate, increment: increment, reset: reset}
  }
}

module Counter = {
  type props = {initialValue: int}
  type result = {
    count: int,
    increment: React.callback<unit, unit>,
    reset: React.callback<unit, unit>,
  }
  let useCounter = (~initialValue=0, ()) => {
    let (count, setCount) = React.useState(_ => initialValue)
    let increment = React.useCallback1(() => setCount(x => x + 1), [])
    let reset = React.useCallback1(() => setCount(_ => initialValue), [initialValue])
    {count: count, increment: increment, reset: reset}
  }
  let count: result => int = res => res.count
  let inc: result => React.callback<unit, unit> = res => res.increment
  let res: result => React.callback<unit, unit> = res => res.reset
}

describe("Rescript-testing-library/react-hooks test suite", () => {
  test("should use counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let {result, _} = RenderHook.renderHook(callback, ())
    result.current.count->expect->toBe(0)
  })

  test("should increment counter", () => {
    let hookCb = BasicHook(() => Counter.useCounter())
    let {result, _} = RenderHook.renderHook(hookCb, ())

    RenderHook.act(() => {
      result.current.increment()
      result.current.increment()
    })

    result.current.count->expect->toBe(2)
  })

  test("should set counter to a custom initial value", () => {
    let initialValue = 13
    let hookCb = BasicHook(() => Counter.useCounter(~initialValue, ()))
    let {result, _} = RenderHook.renderHook(hookCb, ())
    result.current.count->expect->toBe(initialValue)
  })

  test("should not update counter", () => {
    let initialValue = ref(0)
    let hookCb = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let {result, rerender, _} = RenderHook.renderHook(hookCb, ())
    initialValue.contents = 13
    let newProps = Js.Nullable.return({Counter.initialValue: initialValue.contents})
    rerender(newProps)

    result.current.count->expect->toBe(0)
  })

  test("should update counter when prop changes are not reRendered", () => {
    let initialValue = ref(0)
    let hookCb = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let {result, rerender, _} = RenderHook.renderHook(hookCb, ())
    initialValue.contents = 13

    rerender(Js.Nullable.null)

    RenderHook.act(() => result.current.reset())

    result.current.count->expect->toBe(initialValue.contents)
  })

  test("should reset counter to updated initial value", () => {
    let initialProps = {{initialProps: {Counter.initialValue: 0}, wrapper: None}}
    let hookCb = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let {result, rerender, _} = RenderHook.renderHook(hookCb, ~initialProps, ())

    let newProps = Js.Nullable.return({Counter.initialValue: 13})
    rerender(newProps)
    RenderHook.act(() => result.current.reset())

    result.current.count->expect->toBe(13)
  })

  test("should reset counter to updated value using an object", () => {
    let initialProps = {{initialProps: {Counter.initialValue: 0}, wrapper: None}}
    let hookCb = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let {result, rerender, _} = RenderHook.renderHook(hookCb, ~initialProps, ())

    let newProps = Js.Nullable.return({Counter.initialValue: 13})
    rerender(newProps)
    RenderHook.act(() => result.current.reset())

    result.current.count->expect->toBe(13)
  })

  test("should clean up side effect", () => {
    let initialProps = {{initialProps: {Calculator.initialValue: 0}, wrapper: None}}
    let hookCb = HookWithProps(
      ({Calculator.initialValue: initialValue}) => Calculator.calculate(~initialValue, ()),
    )
    let {result, rerender, _} = RenderHook.renderHook(hookCb, ~initialProps, ())

    let newProps = Js.Nullable.return({Calculator.initialValue: 13})
    rerender(newProps)

    result.current.calculation->expect->toBe(0)
  })
})
