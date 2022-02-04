
module RenderHook = {

  type initialValue<'props> = {initialValue: 'props}

  type hookCB0<'return> = () => 'return
  type hookCB1<'props,'return> = initialValue<'props> => 'return

  type rec hookCB<'props,'return> = 
    | SimpleHook(hookCB0<'return>): hookCB<'props,'return>
    | HookWithProps(hookCB1<'props,'return>): hookCB<'props,'return>

  type renderResult<'props> = {
    all: array<'props>,
    current: 'props,
    error: Js.Exn.t
  }

  type renderHookOptions<'a, 'b> = {
    initialProps: 'a,
    wrapper: option<React.component<'b>>
  }

  type renderHook<'props, 'return> = {
    result: renderResult<'return>,
    rerender: option<Js.Nullable.t<initialValue<'props>>> => (),
    unmount: () => (),
    waitFor: (() => Promise.t<'return>) => (),
    waitForNextUpdate: (() => Promise.t<'props>) => Promise.t<'return>,
    waitForValueToChange: (() => Promise.t<'props>) => Promise.t<'return>
  }

  @module("@testing-library/react-hooks") external _act: (() => ()) => () = "act"
  let act = (updateFn) => _act(updateFn)

  @module("@testing-library/react-hooks") external hydrate: () => () = "hydrate"
  @module("@testing-library/react-hooks") external cleanup: () => () = "cleanup"

  @module("@testing-library/react-hooks") external _renderHook0: (hookCB0<'return>) => renderHook<'props,'return> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook1: (hookCB1<'props,'return>) => renderHook<'props,'return> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook2: (hookCB1<'props,'return>,  Js.Nullable.t<renderHookOptions<'a,'b>>) => renderHook<'props,'return> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook3: (hookCB0<'return>,  Js.Nullable.t<renderHookOptions<'a,'b>>) => renderHook<'props,'return> = "renderHook"

  let renderHook = (callback, ~initialProps: option<Js.Nullable.t<renderHookOptions<'a,'b>>>=?, ()) => {
    switch initialProps {
      | None => {
        switch callback {
          | HookWithProps(cb) => _renderHook1(cb)
          | SimpleHook(cb) => _renderHook0(cb)
        }
      }
      | Some(initialProps) => {
        switch callback {
        | SimpleHook(cb) => _renderHook3(cb, initialProps)
        | HookWithProps(cb) => _renderHook2(cb, initialProps)
        }
      }
    }
  }
}
