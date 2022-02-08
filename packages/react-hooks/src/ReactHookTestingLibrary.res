
module RenderHook = {
  
  type initialValue<'props> = {initialValue: 'props}

  type hook0<'return> = () => 'return
  type hook1<'props,'return> = initialValue<'props> => 'return
  
  type rec hook<'props,'return> = 
    | Hook(hook0<'return>): hook<'props,'return>
    | HookWithProps(hook1<'props,'return>): hook<'props,'return>

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
    rerender: Js.Nullable.t<initialValue<'props>> => (),
    unmount: () => (),
    waitFor: (() => Promise.t<'return>) => (),
    waitForNextUpdate: (() => Promise.t<'props>) => Promise.t<'return>,
    waitForValueToChange: (() => Promise.t<'props>) => Promise.t<'return>
  }

  @module("@testing-library/react-hooks") external _act: (() => ()) => () = "act"
  let act = (updateFn) => _act(updateFn)

  @module("@testing-library/react-hooks") external hydrate: () => () = "hydrate"
  @module("@testing-library/react-hooks") external cleanup: () => () = "cleanup"

  @module("@testing-library/react-hooks") external _renderHook0: (hook0<'return>) => renderHook<'props,'return> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook1: (hook1<'props,'return>) => renderHook<'props,'return> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook2: (hook0<'return>, renderHookOptions<'a,'b>) => renderHook<'props,'return> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook3: (hook1<'props,'return>,  renderHookOptions<'a,'b>) => renderHook<'props,'return> = "renderHook"

  let renderHook = (hookCb, ~initialProps: option<renderHookOptions<'a,'b>>=?, ()) => {
    switch initialProps {
      | None => {
        switch hookCb {
          | Hook(cb) => _renderHook0(cb)
          | HookWithProps(cb) => _renderHook1(cb)
        }
      }
      | Some(initialProps) => {
        switch hookCb {
        | Hook(cb) => _renderHook2(cb, initialProps)
        | HookWithProps(cb) => _renderHook3(cb, initialProps)
        }
      }
    }
  }
}
