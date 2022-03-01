open Jest
open Expect
open ReactHookTestingLibrary

open SideEffects

describe("Rescript-testing-library/react-hooks Effect hook tests", () => {
  test("should handle useEffect hook", () => {
    let actual = []
    let expected = [true, false, false, true, false, false]
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    SideEffects.initialize(false)
    let callback = HookWithProps(
      ({ SideEffects.id }) => {
        React.useEffect1(() => {
          SideEffects.start(id)
          Some(() => SideEffects.stop(id))
        }, [id])
      })
    let rendered = RenderHook.renderHook(callback, ~initialProps, ())

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    let newProps = { SideEffects.id: 2 }
    rendered -> RenderHook.rerender(~newProps, ())

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    rendered -> RenderHook.unmount()

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    actual -> expect -> toBeSupersetOf(expected)

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
