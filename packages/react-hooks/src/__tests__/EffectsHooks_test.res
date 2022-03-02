open Jest
open Expect
open ReactHookTestingLibrary

module SideEffectsHook = MakeRenderable(SideEffects)

describe("Rescript-testing-library/react-hooks Effect hook tests", () => {
  test("should clean up side effect", () => {
    let actual = []
    let expected = [false, true]
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    SideEffects.initialize(false)
    let callback = HookWithProps(({ SideEffects.id }) => {
        React.useEffect1(() => {
          SideEffects.start(id)
          Some(() => SideEffects.stop(id))
        }, [id])
      })
    let rendered = RenderHook.renderHook(callback, ~initialProps, ())

    let newProps = { SideEffects.id: 2 }
    rendered -> RenderHook.rerender(~newProps, ())

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    actual -> expect -> toBeSupersetOf(expected)
  })

  test("should handle useEffect hook", () => {
    let actual = []
    let expected = [true, false, false, true, false, false]
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    SideEffects.initialize(false)
    let callback = HookWithProps(({ SideEffects.id }) => {
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

  test("Functor should clean up side effect", () => {
    let actual = []
    let expected = [false, true]
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    SideEffects.initialize(false)
    let callback = HookWithProps(({ SideEffects.id }) => {
        React.useEffect1(() => {
          SideEffects.start(id)
          Some(() => SideEffects.stop(id))
        }, [id])
      })
    let rendered = SideEffectsHook.renderHook(callback, ~initialProps, ())

    let newProps = { SideEffects.id: 2 }
    rendered -> SideEffectsHook.rerender(~newProps, ())

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    actual -> expect -> toBeSupersetOf(expected)
  })

  test("should handle useEffect hook", () => {
    let actual = []
    let expected = [true, false, false, true, false, false]
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    SideEffects.initialize(false)
    let callback = HookWithProps(({ SideEffects.id }) => {
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

  test("Functor should handle useEffect hook", () => {
    let actual = []
    let expected = [true, false, false, true, false, false]
    let initialProps = { initialProps: { SideEffects.id: 1 }, wrapper: None }
    SideEffects.initialize(false)
    let callback = HookWithProps(({ SideEffects.id }) => {
        React.useEffect1(() => {
          SideEffects.start(id)
          Some(() => SideEffects.stop(id))
        }, [id])
      })
    let rendered =  SideEffectsHook.renderHook(callback, ~initialProps, ())

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    let newProps = { SideEffects.id: 2 }
    rendered -> SideEffectsHook.rerender(~newProps, ())

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    rendered -> SideEffectsHook.unmount()

    Js.Array2.push(actual, SideEffects.get(1)) -> ignore
    Js.Array2.push(actual, SideEffects.get(2)) -> ignore

    actual -> expect -> toBeSupersetOf(expected)

  })
})
