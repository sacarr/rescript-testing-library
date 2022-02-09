
type initialValue<'props> = {initialValue: 'props}

type hook0<'result> = () => 'result
type hook1<'props,'result> = 'props => 'result

type rec hook<'props,'result> = 
  | Hook(hook0<'result>): hook<'props,'result>
  | HookWithProps(hook1<'props,'result>): hook<'props,'result>

type renderResult<'result> = {
  all: array<'result>,
  current: 'result,
  error: Js.Exn.t
}

type renderHookOptions<'a, 'b> = {
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

@module("@testing-library/react-hooks") external _act: (() => ()) => () = "act"
let act = (updateFn) => _act(updateFn)

@module("@testing-library/react-hooks") external hydrate: () => () = "hydrate"
@module("@testing-library/react-hooks") external cleanup: () => () = "cleanup"

@module("@testing-library/react-hooks") external _renderHook0: (hook0<'result>) => renderHook<'props,'result> = "renderHook"
@module("@testing-library/react-hooks") external _renderHook1: (hook1<'props,'result>) => renderHook<'props,'result> = "renderHook"
@module("@testing-library/react-hooks") external _renderHook2: (hook0<'result>, renderHookOptions<'a,'b>) => renderHook<'props,'result> = "renderHook"
@module("@testing-library/react-hooks") external _renderHook3: (hook1<'props,'result>,  renderHookOptions<'a,'b>) => renderHook<'props,'result> = "renderHook"

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
