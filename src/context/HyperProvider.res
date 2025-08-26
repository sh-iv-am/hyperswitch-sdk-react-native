type retryObject = {
  processor: string,
  redirectUrl: string,
}

@genType
type hyperProviderData = {publishableKey: string, customBackendUrl?: string}
let defaultVal: hyperProviderData = {publishableKey: ""}

let hyperProviderContext = React.createContext((defaultVal, (_: hyperProviderData) => ()))

module Provider = {
  let make = React.Context.provider(hyperProviderContext)
}
@genType @react.component
let make = (~children, ~publishableKey="", ~customBackendUrl=None) => {
  let defaultVal: hyperProviderData = {publishableKey: publishableKey, ?customBackendUrl}
  let (state, setState) = React.useState(_ => defaultVal)

  React.useEffect1(() => {
    let newVal: hyperProviderData = {publishableKey: publishableKey, ?customBackendUrl}
    setState(_ => newVal)
    None
  }, [publishableKey])

  let setState = React.useCallback1(val => {
    setState(_ => val)
  }, [setState])

  <Provider value=(state, setState)> children </Provider>
}
