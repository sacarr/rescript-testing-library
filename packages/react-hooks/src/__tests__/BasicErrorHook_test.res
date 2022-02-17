open Jest
open Expect
open ReactHookTestingLibrary

describe("Rescript-testing-library/react-hooks Error handling tests", () => {

  test("should not throw an error", () => {
    let message="Exception not expected"
    let callback = BasicHook(() => ThrowsError.useError(~throwError=false, ~message, ()))
    let {result, _} = RenderHook.renderHook(callback, ())
    switch Js.Nullable.toOption(result.error) {
      | None => result.current.message -> expect -> toMatch(message)
      | Some(err) => {
        switch Js.Exn.message(err) {
          | Some(msg) =>  msg -> expect -> toMatch(message)
          | _ => fail("Unknown Exception")
        }
      }
    }
  })

  test("should throw an error", () => {
    let message="Exception expected"
    let failMessage = `Expected exception message to Match ${message}`
    let callback = BasicHook(() => ThrowsError.useError(~throwError=true, ~message, ()))
      let {result, _ } = RenderHook.renderHook(callback, ())
      switch Js.Nullable.toOption(result.error) {
        | Some(err) => {
          switch Js.Exn.message(err) {
            | None => fail(failMessage)
            | Some(msg) =>  msg -> expect -> toMatch(message)
          }
        }
        | _ => fail(failMessage)        
      }
  })
})
