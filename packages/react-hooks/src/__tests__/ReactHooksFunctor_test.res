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
module CalculatorHook = MakeRenderable(Calculator)

module Counter = {
  type props = {initialValue: int}
  type result = {
    count: int,
    increment: React.callback<unit, unit>,
    reset: React.callback<unit, unit>,
  }
  let useCounter = (~initialValue=0, ()) => {
    let (count, setCount) = React.useState(_ => initialValue)
    let _increment = React.useCallback1(() => setCount(x => x + 1), [])
    let _reset = React.useCallback1(() => setCount(_ => initialValue), [initialValue])
    {count: count, increment: _increment, reset: _reset}
  }
}
module CounterHook = MakeRenderable(Counter)

describe("Rescript-testing-library/react-hooks Functor test suite", () => {
  test("should use counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    result.current.count->expect->toBe(0)
  })

  test("should use functor-rendered counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    result.current.count->expect->toBe(0)
  })

  test("should increment counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    CounterHook.act(() => {
      result.current.increment()
      result.current.increment()
    })

    result.current.count->expect->toBe(2)
  })

  test("should set counter to a custom initial value", () => {
    let initialValue = 13
    let callback = BasicHook(() => Counter.useCounter(~initialValue, ()))
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    result.current.count->expect->toBe(initialValue)
  })

  test("should not update counter", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let hook = CounterHook.renderHook(callback, ())
    initialValue.contents = 13
    let newProps: Counter.props = {initialValue: initialValue.contents}
    hook->CounterHook.rerender(~newProps, ())

    hook.result.current.count->expect->toBe(0)
  })

  test("should update counter when prop changes are not reRendered", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let hook = CounterHook.renderHook(callback, ())
    initialValue.contents = 13
    hook->CounterHook.rerender()
    CounterHook.act(hook.result.current.reset)
    hook.result.current.count->expect->toBe(initialValue.contents)
  })

  test("should reset counter to updated initial value", () => {
    let props: Counter.props = {initialValue: 0}
    let initialProps = {{initialProps: props, wrapper: None}}
    let callback = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let hook = CounterHook.renderHook(callback, ~initialProps, ())

    let newProps = {Counter.initialValue: 13}
    hook->CounterHook.rerender(~newProps, ())
    CounterHook.act(hook.result.current.reset)

    hook.result.current.count->expect->toBe(13)
  })

  test("should reset counter to updated value using an object", () => {
    let props: Counter.props = {initialValue: 0}
    let initialProps = {{initialProps: props, wrapper: None}}
    let callback = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let hook = CounterHook.renderHook(callback, ~initialProps, ())
    let newProps = {Counter.initialValue: 13}
    hook->CounterHook.rerender(~newProps, ())
    CounterHook.act(hook.result.current.reset)

    hook.result.current.count->expect->toBe(13)
  })

  test("should clean up side effect", () => {
    let props: Calculator.props = {initialValue: 0}
    let initialProps = {{initialProps: props, wrapper: None}}
    let callback = HookWithProps(
      ({Calculator.initialValue: initialValue}) => Calculator.calculate(~initialValue, ()),
    )
    let hook = CalculatorHook.renderHook(callback, ~initialProps, ())
    let newProps = {Calculator.initialValue: 13}
    hook->CalculatorHook.rerender(~newProps, ())

    hook.result.current.calculation->expect->toBe(0)
  })
})
