
module RenderHook = {

  type renderResult<'props> = {
    all: array<'props>,
    current: 'props,
    error: Js.Exn.t
  }

  type renderHookOptions<'a> = {
    initialProps: 'a,
    wrapper: option<React.component<'a>>
  }

  type renderHook<'props> = {
    result: renderResult<'props>
  }

  @module("@testing-library/react-hooks") external _renderHook: (() => 'props ) => renderHook<'props> = "renderHook"
  @module("@testing-library/react-hooks") external __renderHook: (() => 'props,  option<'props>) => renderHook<'props> = "renderHook"
  let render = (hookFn, ~initialProps=?, ()) => {
    switch initialProps {
      | None => _renderHook(hookFn)
      | Some(initialProps) => __renderHook(hookFn, initialProps)
    }
  }
  
  @get external all: renderResult<'props> => array<Js.Nullable.t<'props>> = "all"
  @get external current: renderResult<'props> => Js.Nullable.t<'props> = "current"
  @get external error: renderResult<'props> => Js.Exn.t = "error"
  @send external rerender: renderHook<'props> => 'props => () = "rerender"
  @send external unmount: renderHook<'props> => () => () = "rerender"
  @send external hydrate: renderHook<'props> => 'props => () = "rerender"
  @send external act: renderHook<'props> => 'props => () = "rerender"
  @send external cleanup: renderHook<'props> => 'props => () = "rerender"
}


