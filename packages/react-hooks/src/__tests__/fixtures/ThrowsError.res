type props = {throwError: bool}
type result = {message: string}
let useError = (~throwError=false, ~message="should not cause error", ()) => {
    switch throwError {
    | true => Js.Exn.raiseError(message)
    | false => {message: message}
    }
}
