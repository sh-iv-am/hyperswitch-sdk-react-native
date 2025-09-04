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

let parsePaymentSheetResult = (jsonString: string): presentPaymentSheetResult => {
  try {
    let parsed = Js.Json.parseExn(jsonString)
    {
      status: switch parsed->Js.Json.decodeObject->Option.flatMap(. obj => 
        obj->Js.Dict.get("status")->Option.flatMap(json => json->Js.Json.decodeString)
      ) {
      | Some("succeeded") => Completed
      | Some("cancelled") => Canceled
      | Some("failed") | _ => Failed
      },
      message: parsed->Js.Json.decodeObject->Option.flatMap(. obj => 
        obj->Js.Dict.get("message")->Option.flatMap(json => json->Js.Json.decodeString)
      )->Option.getOr(""),
      error: ?parsed->Js.Json.decodeObject->Option.flatMap(. obj => 
        obj->Js.Dict.get("error")->Option.flatMap(json => json->Js.Json.decodeString)
      ),
      \"type": ?parsed->Js.Json.decodeObject->Option.flatMap(. obj => 
        obj->Js.Dict.get("type")->Option.flatMap(json => json->Js.Json.decodeString)
      ),
    }
  } catch {
  | _ => getError(~error="Failed to parse payment sheet result")
  }
}

let _presentPaymentSheet = async (params: presentPaymentSheetParams): presentPaymentSheetResult => {
  try {
    let result = await nativeHyperswitchSdk.presentPaymentSheet(params)
    result->parsePaymentSheetResult
  } catch {
  | Exn.Error(obj) =>
    switch Exn.message(obj) {
    | Some(error) => {
      getError(~error)}
    | None => getError()
    }
  | _ => getError()
  }
}

type useHyper = {
  initPaymentSession: initPaymentSessionParams => promise<initPaymentSessionResult>,
  presentPaymentSheet: presentPaymentSheetParams => promise<presentPaymentSheetResult>,
}

@genType
let useHyper = () => {
  let (contextData, _) = React.useContext(HyperProvider.hyperProviderContext)
  let isReady = contextData.isInitialized && contextData.error->Belt.Option.isNone

  let initPaymentSession = React.useCallback0((params: initPaymentSessionParams) => {
     _initPaymentSession(params)
  })

  let presentPaymentSheet = React.useCallback1((params: presentPaymentSheetParams) => {
    if !isReady {
      let a: promise<presentPaymentSheetResult> = Promise.resolve(
        getError(~error="Hyperswitch is not initialized"),
      )
      a
    } else {
      _presentPaymentSheet(params)
    }
  }, [isReady])

  {
    initPaymentSession,
    presentPaymentSheet,
  }
}
