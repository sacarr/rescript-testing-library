type basicHook<'result> = unit => 'result
type hookWithProps<'props, 'result> = 'props => 'result

type rec hook<'props, 'result> =
  | BasicHook(basicHook<'result>): hook<'props, 'result>
  | HookWithProps(hookWithProps<'props, 'result>): hook<'props, 'result>

type renderResult<'result> = {
  all: array<'result>,
  current: 'result,
  error: Js.Nullable.t<Js.Exn.t>,
}

type renderHookOptions<'a, 'b> = {
  initialProps: 'a,
  wrapper: option<React.component<'b>>,
}

type renderHook<'props, 'result> = {
  result: renderResult<'result>,
  rerender: Js.Nullable.t<'props> => unit,
  unmount: unit => unit,
  waitFor: (unit => Promise.t<'result>) => unit,
  waitForNextUpdate: (unit => Promise.t<'props>) => Promise.t<'result>,
  waitForValueToChange: (unit => Promise.t<'props>) => Promise.t<'result>,
}

module type RenderHookInterface = {
  let act: (unit => unit) => unit
  let all: renderHook<'props, 'result> => array<'result>
  let cleanup: (unit => unit) => unit
  let current: renderHook<'props, 'result> => 'result
  let error: renderHook<'props, 'result> => option<Js.Exn.t>
  let hydrate: (unit => unit) => unit
  let renderHook: (
    hook<'props, 'result>,
    ~initialProps: renderHookOptions<'a, 'b>=?,
    unit,
  ) => renderHook<'props, 'result>
  let rerender: (renderHook<'props, 'result>, ~newProps: 'props=?, unit) => unit
  let result: renderHook<'props, 'result> => renderResult<'result>
  let unmount: (renderHook<'props, 'result>, unit) => unit
  let waitFor: (renderHook<'props, 'result>, unit => Promise.t<'result>) => unit
  let waitForNextUpdate: (renderHook<'props, 'result>, unit => Promise.t<'props>) => Promise.t<'result>
  let waitForValueToChange: (renderHook<'props, 'result>, unit => Promise.t<'props>) => Promise.t<'result>
}

module RenderHook: RenderHookInterface = {
  @module("@testing-library/react-hooks") external act: (unit => unit) => unit = "act"
  @module("@testing-library/react-hooks") external cleanup: (unit => unit) => unit = "cleanup"
  @module("@testing-library/react-hooks") external hydrate: (unit => unit) => unit = "hydrate"
  @module("@testing-library/react-hooks") external renderBasicHook: basicHook<'result> => renderHook<'props, 'result> = "renderHook"
  @module("@testing-library/react-hooks") external renderHookWithPropsSansProps: hookWithProps<'props, 'result> => renderHook<'props, 'result> = "renderHook"
  @module("@testing-library/react-hooks") external renderBasicHookWithProps: (basicHook<'result>, renderHookOptions<'a, 'b>) => renderHook<'props, 'result> = "renderHook"
  @module("@testing-library/react-hooks") external renderHookWithProps: (hookWithProps<'props, 'result>, renderHookOptions<'a, 'b>) => renderHook<'props, 'result> = "renderHook"
  let act = f => act(f)
  let all = rendered => rendered.result.all
  let cleanup = callback => cleanup(callback)
  let current = rendered => rendered.result.current
  let error = rendered => Js.Nullable.toOption(rendered.result.error)
  let hydrate = callback => hydrate(callback)
  let renderHook = (callback, ~initialProps: option<renderHookOptions<'a, 'b>>=?, ()) => {
    switch initialProps {
    | None => switch callback {
      | BasicHook(cb) => renderBasicHook(cb)
      | HookWithProps(cb) => renderHookWithPropsSansProps(cb)
      }
    | Some(initialProps) => switch callback {
      | BasicHook(cb) => renderBasicHookWithProps(cb, initialProps)
      | HookWithProps(cb) => renderHookWithProps(cb, initialProps)
      }
    }
  }
  let rerender = (
    rendered,
    ~newProps: option<'props>=?,
    (),
  ) => {
    switch newProps {
    | None => rendered.rerender(Js.Nullable.null)
    | Some(props) => rendered.rerender(Js.Nullable.return(props))
    }
  }
  let result = rendered =>
    rendered.result
  let unmount = rendered => rendered.unmount
  let waitFor = rendered => rendered.waitFor
  let waitForNextUpdate = rendered => rendered.waitForNextUpdate
  let waitForValueToChange = rendered => rendered.waitForValueToChange
}

module type Renderable = {
  type props
  type result
}

module MakeRenderable = (Item: Renderable) => {
  let act = f => RenderHook.act(f)
  let all: renderHook<Item.props, Item.result> => array<Item.result> = rendered => rendered -> RenderHook.all
  let cleanup = callback => RenderHook.cleanup(callback)
  let current = rendered => rendered -> RenderHook.current
  let error = rendered => rendered -> RenderHook.error
  let hydrate = callback => RenderHook.hydrate(callback)
  let rerender = (rendered, ~newProps: option<Item.props>=?, ()) =>
  {
    switch newProps {
    | None => rendered -> RenderHook.rerender()
    | Some(newProps) => rendered -> RenderHook.rerender(~newProps, ())
    }
  }
  let renderHook = (callback, ~initialProps: option<renderHookOptions<'a, 'b>>=?, ()) => {
    switch initialProps {
    | None => callback -> RenderHook.renderHook()
    | Some(initialProps) => callback -> RenderHook.renderHook(~initialProps, ())
    }
  }
  let result = rendered =>  rendered -> RenderHook.result
  let unmount = rendered => rendered -> RenderHook.unmount
  let waitFor = rendered => rendered -> RenderHook.waitFor
  let waitForNextUpdate = rendered => rendered -> RenderHook.waitForNextUpdate
  let waitForValueToChange = rendered => rendered -> RenderHook.waitForValueToChange
}
