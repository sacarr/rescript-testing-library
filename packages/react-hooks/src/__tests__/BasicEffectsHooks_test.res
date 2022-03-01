open Jest
open Expect
open ReactHookTestingLibrary

open SideEffects

describe("Rescript-testing-library/react-hooks Effect hook tests", () => {
  test("should handle useEffect hook", () => {
    let theResults = []
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    SideEffects.initialize(false)
    SideEffects.setResults([true, false, false, true, false, false])
    let callback = HookWithProps(
      ({ SideEffects.id }) => {
        React.useEffect1(() => {
          SideEffects.start(id)
          Some(() => SideEffects.stop(id))
        }, [id])
      })
    let { rerender, unmount, _ } = RenderHook.renderHook(callback, ~initialProps, ())

    Js.Array2.push(theResults, SideEffects.get(1)) -> ignore
    Js.Array2.push(theResults, SideEffects.get(2)) -> ignore

    let newProps = Js.Nullable.return({ SideEffects.id: 2 })
    rerender(newProps)

    Js.Array2.push(theResults, SideEffects.get(1)) -> ignore
    Js.Array2.push(theResults, SideEffects.get(2)) -> ignore

    unmount()

    Js.Array2.push(theResults, SideEffects.get(1)) -> ignore
    Js.Array2.push(theResults, SideEffects.get(2)) -> ignore

    theResults -> expect -> toBeSupersetOf(SideEffects.getResults())

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
