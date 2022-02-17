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
  let cleanup: (unit => unit) => unit
  let hydrate: (unit => unit) => unit
  let renderHook: (
    hook<'props, 'result>,
    ~initialProps: renderHookOptions<'a, 'b>=?,
    unit,
  ) => renderHook<'props, 'result>
}

module RenderHook: RenderHookInterface = {
  @module("@testing-library/react-hooks") external act: (unit => unit) => unit = "act"
  @module("@testing-library/react-hooks") external cleanup: (unit => unit) => unit = "cleanup"
  @module("@testing-library/react-hooks") external hydrate: (unit => unit) => unit = "hydrate"

  @module("@testing-library/react-hooks")
  external renderBasicHook: basicHook<'result> => renderHook<'props, 'result> = "renderHook"
  @module("@testing-library/react-hooks")
  external renderHookWithPropsSansProps: hookWithProps<'props, 'result> => renderHook<
    'props,
    'result,
  > = "renderHook"
  @module("@testing-library/react-hooks")
  external renderBasicHookWithProps: (
    basicHook<'result>,
    renderHookOptions<'a, 'b>,
  ) => renderHook<'props, 'result> = "renderHook"
  @module("@testing-library/react-hooks")
  external renderHookWithProps: (
    hookWithProps<'props, 'result>,
    renderHookOptions<'a, 'b>,
  ) => renderHook<'props, 'result> = "renderHook"

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
}

module type Renderable = {
  type props
  type result
}

module MakeRenderable = (Item: Renderable) => {
  let act: (unit => unit) => unit = f => RenderHook.act(f)
  let all: renderHook<Item.props, Item.result> => array<Item.result> = rendered =>
    rendered.result.all
  let cleanup: (unit => unit) => unit = callback => RenderHook.cleanup(callback)
  let current: renderHook<Item.props, Item.result> => Item.result = rendered =>
    rendered.result.current
  let error: renderHook<Item.props, Item.result> => option<Js.Exn.t> = rendered => Js.Nullable.toOption(rendered.result.error)
  let hydrate: (unit => unit) => unit = callback => RenderHook.hydrate(callback)
  let rerender: (renderHook<Item.props, Item.result>, ~newProps: Item.props=?, unit) => unit = (
    rendered,
    ~newProps: option<Item.props>=?,
    (),
  ) => {
    switch newProps {
    | None => rendered.rerender(Js.Nullable.null)
    | Some(props) => rendered.rerender(Js.Nullable.return(props))
    }
  }
  let renderHook: (
    hook<Item.props, Item.result>,
    ~initialProps: renderHookOptions<'a, 'b>=?,
    unit,
  ) => renderHook<Item.props, Item.result> = (
    callback,
    ~initialProps: option<renderHookOptions<'a, 'b>>=?,
    (),
  ) => {
    switch initialProps {
    | None => RenderHook.renderHook(callback, ())
    | Some(initialProps) => RenderHook.renderHook(callback, ~initialProps, ())
    }
  }
  let result: renderHook<Item.props, Item.result> => renderResult<Item.result> = rendered =>
    rendered.result
  let unmount: (renderHook<Item.props, Item.result>, unit) => unit = rendered => rendered.unmount
  let waitFor: (
    renderHook<Item.props, Item.result>,
    unit => Promise.t<Item.result>,
  ) => unit = rendered => rendered.waitFor
  let waitForNextUpdate: (
    renderHook<Item.props, Item.result>,
    unit => Promise.t<Item.props>,
  ) => Promise.t<Item.result> = rendered => rendered.waitForNextUpdate
  let waitForValueToChange: (
    renderHook<Item.props, Item.result>,
    unit => Promise.t<Item.props>,
  ) => Promise.t<Item.result> = rendered => rendered.waitForValueToChange
}
