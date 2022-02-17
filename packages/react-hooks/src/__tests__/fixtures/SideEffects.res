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
