open Jest
open Expect
open ReactHookTestingLibrary

describe("Rescript-testing-library/react-hooks state hook tests", () => {
  test("should use counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let {result, _} = RenderHook.renderHook(callback, ())
    result.current.count->expect->toBe(0)
  })

  test("should increment counter", () => {
    let callback = BasicHook(() => Counter.useCounter())
    let {result, _} = RenderHook.renderHook(callback, ())

    RenderHook.act(() => {
      result.current.increment()
      result.current.increment()
    })

    result.current.count->expect->toBe(2)
  })

  test("should set counter to a custom initial value", () => {
    let initialValue = 13
    let callback = BasicHook(() => Counter.useCounter(~initialValue, ()))
    let {result, _} = RenderHook.renderHook(callback, ())
    result.current.count->expect->toBe(initialValue)
  })

  test("should not update counter", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let {result, rerender, _} = RenderHook.renderHook(callback, ())
    initialValue.contents = 13
    let newProps = Js.Nullable.return({Counter.initialValue: initialValue.contents})
    rerender(newProps)

    result.current.count->expect->toBe(0)
  })

  test("should update counter when prop changes are not reRendered", () => {
    let initialValue = ref(0)
    let callback = BasicHook(() => Counter.useCounter(~initialValue=initialValue.contents, ()))
    let {result, rerender, _} = RenderHook.renderHook(callback, ())
    initialValue.contents = 13

    rerender(Js.Nullable.null)

    RenderHook.act(() => result.current.reset())

    result.current.count->expect->toBe(initialValue.contents)
  })

  test("should reset counter to updated initial value", () => {
    let initialProps = {{initialProps: {Counter.initialValue: 0}, wrapper: None}}
    let callback = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let {result, rerender, _} = RenderHook.renderHook(callback, ~initialProps, ())

    let newProps = Js.Nullable.return({Counter.initialValue: 13})
    rerender(newProps)
    RenderHook.act(() => result.current.reset())

    result.current.count->expect->toBe(13)
  })

  test("should reset counter to updated value using an object", () => {
    let initialProps = {{initialProps: {Counter.initialValue: 0}, wrapper: None}}
    let callback = HookWithProps(
      ({Counter.initialValue: initialValue}) => Counter.useCounter(~initialValue, ()),
    )
    let {result, rerender, _} = RenderHook.renderHook(callback, ~initialProps, ())

    let newProps = Js.Nullable.return({Counter.initialValue: 13})
    rerender(newProps)
    RenderHook.act(() => result.current.reset())

    result.current.count->expect->toBe(13)
  })
})
