open NativeHyperswitchSdk

let getError: (~error: string=?) => presentPaymentSheetResult = (
  ~error="Unknown error occurred while presenting payment sheet",
) => {
  status: Failed,
  message: "failed",
  error,
}

let _initPaymentSession = async (params: initPaymentSessionParams): initPaymentSessionResult => {
  try {
    await nativeHyperswitchSdk.initPaymentSession(
      ~paymentIntentClientSecret=params.paymentIntentClientSecret->Option.getOr(""),
    )
    {}
  } catch {
  | Exn.Error(obj) =>
    switch Exn.message(obj) {
    | Some(msg) => {error: msg}
    | None => {error: "Unknown error occurred while initializing payment sheet"}
    }
  | _ => {error: "Unexpected error occurred while initializing payment sheet"}
  }
}

let _presentPaymentSheet = async (): presentPaymentSheetResult => {
  try {
    let result = await nativeHyperswitchSdk.presentPaymentSheet()
    result
  } catch {
  | Exn.Error(obj) =>
    switch Exn.message(obj) {
    | Some(error) => getError(~error)
    | None => getError()
    }
  | _ => getError()
  }
}

type useHyper = {
  initPaymentSession: initPaymentSessionParams => promise<initPaymentSessionResult>,
  presentPaymentSheet: unit => promise<presentPaymentSheetResult>,
}

@genType
let useHyper = () => {
  let (contextData, _) = React.useContext(HyperProvider.hyperProviderContext)
  let isReady = contextData.isInitialized && contextData.error->Belt.Option.isNone

  let initPaymentSession = React.useCallback0((params: initPaymentSessionParams) => {
    _initPaymentSession(params)
  })

  let presentPaymentSheet = React.useCallback1(() => {
    if !isReady {
      let a: promise<presentPaymentSheetResult> = Promise.resolve(
        getError(~error="Hyperswitch is not initialized"),
      )
      a
    } else {
      _presentPaymentSheet()
    }
  }, [isReady])

  {
    initPaymentSession,
    presentPaymentSheet,
  }
}
