
module RenderHook = {

  type renderResult<'props> = {
    all: array<'props>,
    current: 'props,
    error: Js.Exn.t
  }

  type renderHookOptions<'a, 'b> = {
    initialProps: 'a,
    wrapper: option<React.component<'b>>
  }

  type renderHook<'props, 'newProps> = {
    result: renderResult<'props>,
    rerender: Js.Nullable.t<'newProps> => (),
    unmount: () => (),
    waitFor: (() => Promise.t<'props>) => (),
    waitForNextUpdate: (() => Promise.t<'props>) => Promise.t<'props>,
    waitForValueToChange: (() => Promise.t<'props>) => Promise.t<'props>
  }

  @module("@testing-library/react-hooks") external _act: (() => ()) => () = "act"
  let act = (updateFn) => _act(updateFn)

  @module("@testing-library/react-hooks") external hydrate: () => () = "hydrate"
  @module("@testing-library/react-hooks") external cleanup: () => () = "cleanup"

  @module("@testing-library/react-hooks") external _renderHook: (() => 'props ) => renderHook<'props,'newProps> = "renderHook"
  @module("@testing-library/react-hooks") external __renderHook: (() => 'props,  renderHookOptions<'a,'b>) => renderHook<'props,'newProps> = "renderHook"
  let render = (hookFn, initialProps: Js.Nullable.t<<renderHookOptions<'a,'b>>, ()) => {
    switch Js.Nullable.toOption(initialProps) {
      | None => _renderHook(hookFn)
      | Some(initialProps) => __renderHook(hookFn, initialProps)
    }
  }

}

