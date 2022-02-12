
type simpleHook<'result> = () => 'result
type hookWithProps<'props,'result> = 'props => 'result

type rec hook<'props,'result> = 
  | SimpleHook(simpleHook<'result>): hook<'props,'result>
  | HookWithProps(hookWithProps<'props,'result>): hook<'props,'result>

type initialValue<'props> = {initialValue: 'props}

type renderResult<'result> = {
  all: array<'result>,
  current: 'result,
  error: Js.Exn.t
}

type renderHookOptions<'a,'b> = {
  initialProps: 'a,
  wrapper: option<React.component<'b>>
}

type renderHook<'props, 'result> = {
  result: renderResult<'result>,
  rerender: Js.Nullable.t<'props> => (),
  unmount: () => (),
  waitFor: (() => Promise.t<'result>) => (),
  waitForNextUpdate: (() => Promise.t<'props>) => Promise.t<'result>,
  waitForValueToChange: (() => Promise.t<'props>) => Promise.t<'result>
}

module type RenderHookInterface = {
  let renderHook: (
    hook<'props,'result>,
    ~initialProps: option<renderHookOptions<'a,'b>>,
    ()) => renderHook<'props,'result>
}

module RenderHook: RenderHookInterface = {
  @module("@testing-library/react-hooks") external _renderHook0: (simpleHook<'result>) => renderHook<'props,'result> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook1: (hookWithProps<'props,'result>) => renderHook<'props,'result> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook2: (simpleHook<'result>, renderHookOptions<'a,'b>) => renderHook<'props,'result> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHook3: (hookWithProps<'props,'result>,  renderHookOptions<'a,'b>) => renderHook<'props,'result> = "renderHook"

  let renderHook = (
    hookCb,
    ~initialProps: option<renderHookOptions<'a,'b>>,
    ()) => {
    switch initialProps {
      | None => {
        switch hookCb {
          | SimpleHook(cb) => _renderHook0(cb)
          | HookWithProps(cb) => _renderHook1(cb)
        }
      }
      | Some(initialProps) => {
        switch hookCb {
          | SimpleHook(cb) => _renderHook2(cb, initialProps)
          | HookWithProps(cb) => _renderHook3(cb, initialProps)
        }
      }
    }
}

}

module type Renderable = {
  type props
  type result
  let callback: hook<props,result>
  let options: option<renderHookOptions<'a,'b>>
}

module MakeRenderable = (Item: Renderable) => {
  @module("@testing-library/react-hooks") external _act: (() => ()) => () = "act"
  @module("@testing-library/react-hooks") external cleanup: () => () = "cleanup"
  @module("@testing-library/react-hooks") external hydrate: () => () = "hydrate"
  @module("@testing-library/react-hooks") external _renderHook: simpleHook<Item.result> => renderHook<'props,Item.result> = "renderHook"
  @module("@testing-library/react-hooks") external __renderHook: (simpleHook<Item.result>, renderHookOptions<'a,'b>) => renderHook<'props,Item.result> = "renderHook"
  @module("@testing-library/react-hooks") external _renderHookWithProps: (hookWithProps<Item.props,Item.result>, renderHookOptions<'a,'b>) => renderHook<Item.props,Item.result> = "renderHook"
  @module("@testing-library/react-hooks") external __renderHookWithProps: (hookWithProps<Item.props,Item.result>) => renderHook<Item.props,Item.result> = "renderHook"

  let act = (updateFn) => _act(updateFn)
  let renderHook: () => renderHook<Item.props,Item.result> = () => RenderHook.renderHook(Item.callback, ~initialProps=Item.options, ())
  let result: renderHook<Item.props,Item.result> => renderResult<Item.result> = rendered  => rendered.result
  let current: renderResult<Item.result> => Item.result = result => result.current
  let all: renderResult<Item.result> => array<Item.result> = result => result.all
  let error: renderResult<Item.result> => Js.Exn.t = result => result.error
}

@module("@testing-library/react-hooks") external _act: (() => ()) => () = "act"
let act = (updateFn) => _act(updateFn)

@module("@testing-library/react-hooks") external cleanup: () => () = "cleanup"
@module("@testing-library/react-hooks") external hydrate: () => () = "hydrate"
@module("@testing-library/react-hooks") external _renderHook0: (simpleHook<'result>) => renderHook<'props,'result> = "renderHook"
@module("@testing-library/react-hooks") external _renderHook1: (hookWithProps<'props,'result>) => renderHook<'props,'result> = "renderHook"
@module("@testing-library/react-hooks") external _renderHook2: (simpleHook<'result>, renderHookOptions<'a,'b>) => renderHook<'props,'result> = "renderHook"
@module("@testing-library/react-hooks") external _renderHook3: (hookWithProps<'props,'result>,  renderHookOptions<'a,'b>) => renderHook<'props,'result> = "renderHook"

let renderHook = (hookCb, ~initialProps: option<renderHookOptions<'a,'b>>=?, ()) => {
  switch initialProps {
    | None => {
      switch hookCb {
        | SimpleHook(cb) => _renderHook0(cb)
        | HookWithProps(cb) => _renderHook1(cb)
      }
    }
    | Some(initialProps) => {
      switch hookCb {
        | SimpleHook(cb) => _renderHook2(cb, initialProps)
        | HookWithProps(cb) => _renderHook3(cb, initialProps)
      }
    }
  }
}
