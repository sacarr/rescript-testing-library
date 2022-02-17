
type props = {initialValue: int}
type result = {
  count: int,
  increment: React.callback<unit, unit>,
  reset: React.callback<unit, unit>,
}
let useCounter = (~initialValue=0, ()) => {
  let (count, setCount) = React.useState(_ => initialValue)
  let _increment = React.useCallback1(() => setCount(x => x + 1), [])
  let _reset = React.useCallback1(() => setCount(_ => initialValue), [initialValue])
  {count: count, increment: _increment, reset: _reset}
}
