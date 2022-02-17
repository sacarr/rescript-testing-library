open Jest
open Expect
open ReactHookTestingLibrary

open SideEffects
describe("Rescript-testing-library/react-hooks Effect hook tests", () => {
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
