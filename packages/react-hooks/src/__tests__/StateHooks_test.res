open Jest
open Expect
open ReactHookTestingLibrary

module CounterHook = MakeRenderable(Counter)

describe("Rescript-testing-library/react-hooks state hook tests", () => {
  test("should use counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let current = RenderHook.renderHook(callback, ()) -> RenderHook.current
    current.count->expect->toBe(0)
  })

  test("should use counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let result = RenderHook.renderHook(callback, ())->RenderHook.result
    result.current.count->expect->toBe(0)
  })

  test("should increment counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let rendered = RenderHook.renderHook(callback, ())

    RenderHook.act(() => {
      (rendered -> RenderHook.current).increment()
      (rendered -> RenderHook.current).increment()
    })
    (rendered -> RenderHook.current).count->expect->toBe(2)
  })

  test("should use current result", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let current = RenderHook.renderHook(callback, ())->RenderHook.current
    current.count->expect->toBe(0)
  })

  test("functor should use counter's array of results", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let all = RenderHook.renderHook(callback, ()) -> RenderHook.all
    all[0].count->expect->toBe(0)
  })

  test("should set counter to a custom initial value", () => {
    let initialValue = 13
    let callback = BasicHook(() => Counter.useCounter(~initialValue, ()))
    let current = RenderHook.renderHook(callback, ()) -> RenderHook.current
    current.count->expect->toBe(initialValue)
  })

  test("should not update counter", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let rendered = RenderHook.renderHook(callback, ())
    initialValue.contents = 13
    let newProps = {Counter.initialValue: initialValue.contents}
    rendered -> RenderHook.rerender(~newProps, ())

    (rendered -> RenderHook.current).count->expect->toBe(0)
  })

  test("should update counter when prop changes are not reRendered", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let rendered = RenderHook.renderHook(callback, ())
    initialValue.contents = 13

    rendered -> RenderHook.rerender()
    RenderHook.act(() => (rendered -> RenderHook.current).reset())
    (rendered -> RenderHook.current).count
    -> expect
    -> toBe(initialValue.contents)
  })

  test("should reset counter to updated initial value", () => {
    let initialProps = {{initialProps: {Counter.initialValue: 0}, wrapper: None}}
    let callback = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let rendered = RenderHook.renderHook(callback, ~initialProps, ())

    let newProps = {Counter.initialValue: 13}
    rendered -> RenderHook.rerender(~newProps, ())
    RenderHook.act(() => (rendered -> RenderHook.current).reset())

    (rendered -> RenderHook.current).count->expect->toBe(13)
  })

  test("should reset counter to updated value using an object", () => {
    let initialProps = {{initialProps: {Counter.initialValue: 0}, wrapper: None}}
    let callback = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let rendered = RenderHook.renderHook(callback, ~initialProps, ())
    let newProps = {Counter.initialValue: 13}
    rendered -> RenderHook.rerender(~newProps, ())
    RenderHook.act(() => (rendered -> RenderHook.current).reset())

    (rendered -> RenderHook.current).count->expect->toBe(13)
  })

    test("functor should use counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    result.current.count->expect->toBe(0)
  })

  test("should use functor's current result", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let current = CounterHook.renderHook(callback, ())->CounterHook.current
    current.count->expect->toBe(0)
  })

  test("functor should use counter's array of results", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let all = CounterHook.renderHook(callback, ()) -> CounterHook.all
    all[0].count->expect->toBe(0)
  })

  test("functor should increment counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    CounterHook.act(() => {
      result.current.increment()
      result.current.increment()
    })

    result.current.count->expect->toBe(2)
  })

  test("functor should set counter to a custom initial value", () => {
    let initialValue = 13
    let callback = BasicHook(() => Counter.useCounter(~initialValue, ()))
    let result = CounterHook.renderHook(callback, ())->CounterHook.result
    result.current.count->expect->toBe(initialValue)
  })

  test("functor should not update counter", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let hook = CounterHook.renderHook(callback, ())
    initialValue.contents = 13
    let newProps: Counter.props = {initialValue: initialValue.contents}
    hook->CounterHook.rerender(~newProps, ())

    hook.result.current.count->expect->toBe(0)
  })

  test("functor should update counter when prop changes are not reRendered", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let hook = CounterHook.renderHook(callback, ())
    initialValue.contents = 13
    hook->CounterHook.rerender()
    CounterHook.act(hook.result.current.reset)
    hook.result.current.count->expect->toBe(initialValue.contents)
  })

  test("functor should reset counter to updated initial value", () => {
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

  test("functor should reset counter to updated value using an object", () => {
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
