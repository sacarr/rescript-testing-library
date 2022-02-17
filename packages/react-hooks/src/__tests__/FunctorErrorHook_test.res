open Jest
open Expect
open ReactHookTestingLibrary

module HookThrowsError = MakeRenderable(ThrowsError)

describe("Rescript-testing-library/react-hooks Functor-based Error handling", () => {

  test("should not throw an error", () => {
    let message="Exception not expected"
    let callback = BasicHook(() => ThrowsError.useError(~throwError=false, ~message, ()))
    let hook = HookThrowsError.renderHook(callback, ())
    let error = hook -> HookThrowsError.error
    switch error {
      | None => {
        let current = hook -> HookThrowsError.current
        current.message -> expect -> toMatch(message)
      }
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
      let error = HookThrowsError.renderHook(callback, ()) -> HookThrowsError.error
      switch error {
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
