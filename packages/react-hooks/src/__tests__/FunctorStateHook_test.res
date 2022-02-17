open Jest
open Expect
open ReactHookTestingLibrary

module CounterHook = MakeRenderable(Counter)

describe("Rescript-testing-library/react-hooks Functor test suite", () => {
  test("should use counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    result.current.count->expect->toBe(0)
  })

  test("should use functor-rendered counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let current = CounterHook.renderHook(callback, ())->CounterHook.current
    current.count->expect->toBe(0)
  })

  test("should use functor-rendered counter's array of results", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let current = (CounterHook.renderHook(callback, ())->CounterHook.all)[0]
    current.count->expect->toBe(0)
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
})
