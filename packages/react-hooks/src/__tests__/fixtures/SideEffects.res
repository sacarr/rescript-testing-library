
  type sideEffect = array<bool>
  type props = {id: int}
  type result = sideEffect
  let theEffects: sideEffect = [false, false]
  let expectedResults: array<bool> = []
  let setResults = val => {
    switch Js.Array2.length(expectedResults) {
      | 0 => Js.Array2.pushMany(expectedResults, val) -> ignore
      | _ => Js.Array2.spliceInPlace(expectedResults, ~pos=0, ~remove=Js.Array2.length(expectedResults), ~add=val) -> ignore
      }
    }
  let getResultsAsString = () => Js.Array2.toString(expectedResults)
  let getResults = () => expectedResults
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

module Calculator = {
  type props = {initialValue: int}
  type result = {
    calculation: int,
    calculate: unit => unit,
    increment: React.callback<unit, unit>,
    reset: React.callback<unit, unit>,
  }
  let calculate = (~initialValue=0, ()) => {
    let (count, setCount) = React.useState(_ => initialValue)
    let (calculation, setCalculation) = React.useState(_ => initialValue)
    let increment = React.useCallback1(() => setCount(x => x + 1), [])
    let reset = React.useCallback1(() => setCount(_ => initialValue), [initialValue])
    let calculate = () => React.useEffect1(() => {
        setCalculation(_ => count * 2)
        Some(() => setCalculation(_ => initialValue))
      }, [count])
    {calculation: calculation, calculate: calculate, increment: increment, reset: reset}
  }
}
