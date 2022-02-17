open Jest
open Expect
open ReactHookTestingLibrary

open SideEffects
module CalculatorHook = MakeRenderable(SideEffects.Calculator)

describe("Rescript-testing-library/react-hooks Functor test suite", () => {
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
