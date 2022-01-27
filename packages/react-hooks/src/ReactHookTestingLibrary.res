
module RenderHook = {

  type renderResult<'props> = {
    all: array<'props>,
    current: 'props,
    error: Js.Exn.t
  }

  type renderHookOptions<'props> = {
    initialProps: 'props,
    wrapper: option<React.component<'props>>
  }

  type renderHook<'props> = {
    result: renderResult<'props>,
    rerender: () => (),
    unmount: () => (),
    waitFor: (() => Promise.t<'props>) => (),
    waitForNextUpdate: (() => Promise.t<'props>) => Promise.t<'props>,
    waitForValueToChange: (() => Promise.t<'props>) => Promise.t<'props>
  }

  @module("@testing-library/react-hooks") external _act: (() => ()) => () = "act"
  let act = (updateFn) => _act(updateFn)

  @module("@testing-library/react-hooks") external hydrate: () => () = "hydrate"
  @module("@testing-library/react-hooks") external cleanup: () => () = "cleanup"

  @module("@testing-library/react-hooks") external _renderHook: (() => 'props ) => renderHook<'props> = "renderHook"
  @module("@testing-library/react-hooks") external __renderHook: (() => 'props,  option<'props>) => renderHook<'props> = "renderHook"
  let render = (hookFn, ~initialProps=?, ()) => {
    switch initialProps {
      | None => _renderHook(hookFn)
      | Some(initialProps) => __renderHook(hookFn, initialProps)
    }
  }
  
//  @get external all: renderResult<'props> => array<Js.Nullable.t<'props>> = "all"
//  @get external current: renderResult<'props> => Js.Nullable.t<'props> = "current"
//  @get external error: renderResult<'props> => Js.Exn.t = "error"
//  @send external rerender: renderHook<'props> => 'props => () = "rerender"
}


