open Jest
open Expect
open ReactHookTestingLibrary

module Effects = {
  type sideEffect = array<bool>
  type props = {id: int}
  type result = sideEffect
  let theEffects: sideEffect = [false, false]
  let initialize = val => {
    let len = Js.Array2.length(theEffects)
    for i in 0 to len-1 {
      theEffects[i] = val
    }
  }
  let get = id => {
    let len = Js.Array2.length(theEffects)
    if id < len {
      theEffects[id]
    } else {
      Js.Exn.raiseRangeError(`${Belt.Int.toString(id)} is greater than ${Belt.Int.toString(len)}`)
    }
  }
  let start = id => {
    let len = Js.Array2.length(theEffects)
    if id < len {
      theEffects[id] = true
    } else {
      Js.Exn.raiseRangeError(`${Belt.Int.toString(id)} is greater than ${Belt.Int.toString(len)}`)
    }
  }
  let stop = id => {
    let len = Js.Array2.length(theEffects)
    if id < len {
      theEffects[id] = false
    } else {
      Js.Exn.raiseRangeError(`${Belt.Int.toString(id)} is greater than ${Belt.Int.toString(len)}`)
    }
  }
}

describe("Rescript-testing-library/react-hooks Effect hook tests", () => {
  test("should handle useEffect hook", () => {
    let initialProps = { initialProps: { Effects.id: 1 }, wrapper: None }
    let callback = HookWithProps(
      ({ Effects.id }) => {
        React.useEffect1(() => {
          Effects.start(id)
          Some(() => Effects.stop(id))
        }, [id])
      })
    let { rerender, unmount, _ } = RenderHook.renderHook(callback, ~initialProps, ())

    Effects.theEffects[0] -> expect -> toBe(true) -> ignore
    Effects.theEffects[1] -> expect -> toBe(false) -> ignore
    let newProps = Js.Nullable.return({ Effects.id: 2 })
    rerender(newProps)
    Effects.theEffects[0] -> expect -> toBe(false) -> ignore
    Effects.theEffects[1] -> expect -> toBe(true) -> ignore
    unmount()
    Effects.theEffects[0] -> expect -> toBe(false) -> ignore
    Effects.theEffects[1] -> expect -> toBe(false)
  })

  test("should clean up side effect", () => {
    open SideEffects
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
