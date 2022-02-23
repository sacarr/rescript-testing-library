open Jest
open Expect
open ReactHookTestingLibrary

open SideEffects

describe("Rescript-testing-library/react-hooks Effect hook tests", () => {
  test("should handle useEffect hook", () => {
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    let callback = HookWithProps(
      ({ SideEffects.id }) => {
        React.useEffect1(() => {
          SideEffects.start(id)
          Some(() => SideEffects.stop(id))
        }, [id])
      })
    let { rerender, unmount, _ } = RenderHook.renderHook(callback, ~initialProps, ())

    let theResults = ref("")
    theResults.contents = `${string_of_bool(SideEffects.theEffects[0])}`
    theResults.contents = `${theResults.contents}, ${string_of_bool(SideEffects.theEffects[1])}`

    let newProps = Js.Nullable.return({ SideEffects.id: 2 })
    rerender(newProps)

    theResults.contents = `${theResults.contents}, ${string_of_bool(SideEffects.theEffects[0])}`
    theResults.contents = `${theResults.contents}, ${string_of_bool(SideEffects.theEffects[1])}`

    unmount()

    theResults.contents = `${theResults.contents}, ${string_of_bool(SideEffects.theEffects[0])}`
    theResults.contents = `${theResults.contents}, ${string_of_bool(SideEffects.theEffects[1])}`

    theResults.contents -> expect -> toMatch(SideEffects.theResults)

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
