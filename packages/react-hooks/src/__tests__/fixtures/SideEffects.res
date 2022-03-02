
  type sideEffect = array<bool>
  type props = {id: int}
  type result = sideEffect
  let theEffects: sideEffect = [false, false]
  let initialize = val => {
    let len = Js.Array2.length(theEffects)
    for i in 0 to len-1 {
      theEffects[i] = val
    }
  }

  let get = id => {
    let len = Js.Array2.length(theEffects)
    let arrayId = id - 1
    if arrayId < len {
        theEffects[arrayId]
    } else {
      Js.Exn.raiseRangeError(`${Belt.Int.toString(id)} is greater than ${Belt.Int.toString(len)}`)
    }
  }

  let start = id => {
    let len = Js.Array2.length(theEffects)
    let arrayId = id - 1
    if arrayId < len {
      theEffects[arrayId] = true
    } else {
      Js.Exn.raiseRangeError(`${Belt.Int.toString(id)} is greater than ${Belt.Int.toString(len)}`)
    }
  }

  let stop = id => {
    let len = Js.Array2.length(theEffects)
    let arrayId = id - 1
    if arrayId < len {
      theEffects[arrayId] = false
    } else {
      Js.Exn.raiseRangeError(`${Belt.Int.toString(id)} is greater than ${Belt.Int.toString(len)}`)
    }
  }
