
// ReScript bindings for Hyperswitch SDK turbo modules
@module("../specs/NativeHyperswitchSdkReactNative") external hyperswitchSdk: 'a = "default"

// External bindings for the native SDK methods
@send
external initPaymentSessionNative: ('a, HyperTypes.initPaymentSheetParamTypes) => Js.Promise.t<'b> = "initPaymentSession"

@send
external presentPaymentSheetNative: ('a, HyperTypes.sessionParams) => Js.Promise.t<string> = "presentPaymentSheet"

@send
external getCustomerSavedPaymentMethodsNative: ('a, Js.Json.t) => Js.Promise.t<Js.Json.t> = "getCustomerSavedPaymentMethods"

@send
external getCustomerDefaultSavedPaymentMethodDataNative: ('a, Js.Json.t) => Js.Promise.t<Js.Json.t> = "getCustomerDefaultSavedPaymentMethodData"

@send
external getCustomerLastUsedPaymentMethodDataNative: ('a, Js.Json.t) => Js.Promise.t<Js.Json.t> = "getCustomerLastUsedPaymentMethodData"

@send
external getCustomerSavedPaymentMethodDataNative: ('a, Js.Json.t) => Js.Promise.t<Js.Json.t> = "getCustomerSavedPaymentMethodData"

@send
external confirmWithCustomerDefaultPaymentMethodNative: ('a, Js.Json.t, option<string>) => Js.Promise.t<Js.Json.t> = "confirmWithCustomerDefaultPaymentMethod"

@send
external confirmWithCustomerLastUsedPaymentMethodNative: ('a, Js.Json.t, option<string>) => Js.Promise.t<Js.Json.t> = "confirmWithCustomerLastUsedPaymentMethod"

@send
external confirmWithCustomerPaymentTokenNative: ('a, Js.Json.t, option<string>, string) => Js.Promise.t<Js.Json.t> = "confirmWithCustomerPaymentToken"

// ReScript wrapper functions
@genType
let initPaymentSession = (initPaymentSessionParams: HyperTypes.initPaymentSheetParamTypes): Js.Promise.t<HyperTypes.responseFromNativeModule> => {
  hyperswitchSdk->initPaymentSessionNative(initPaymentSessionParams)
}


@genType
let presentPaymentSheet = (sessionParams: HyperTypes.sessionParams): Js.Promise.t<HyperTypes.responseFromNativeModule> => {
  hyperswitchSdk->presentPaymentSheetNative(sessionParams)
  ->Js.Promise.then_(result => {
    result
    ->Js.Json.parseExn
    ->Js.Json.decodeObject
    ->Option.getOr(Dict.make())
    ->HyperTypes.parseResponseFromNativeModule
    ->Js.Promise.resolve
  }, _)
}

@genType
let getCustomerSavedPaymentMethods = (sessionParams: HyperTypes.sessionParams): Js.Promise.t<HyperTypes.sessionParams> => {
  hyperswitchSdk->getCustomerSavedPaymentMethodsNative(sessionParams->HyperCommonTypes.parser)
  ->Js.Promise.then_(_ => {
    sessionParams->Js.Promise.resolve
  }, _)
}

@genType
let getCustomerDefaultSavedPaymentMethodData = (sessionParams: HyperTypes.sessionParams): Js.Promise.t<HyperTypes.savedPaymentMethodType> => {
  hyperswitchSdk->getCustomerDefaultSavedPaymentMethodDataNative(sessionParams->HyperCommonTypes.parser)
  ->Js.Promise.then_(result => {
    result
    ->Js.Json.decodeObject
    ->Option.getOr(Dict.make())
    ->HyperTypes.parseSavedPaymentMethod
    ->Js.Promise.resolve
  }, _)
}

@genType
let getCustomerLastUsedPaymentMethodData = (sessionParams: HyperTypes.sessionParams): Js.Promise.t<HyperTypes.savedPaymentMethodType> => {
  hyperswitchSdk->getCustomerLastUsedPaymentMethodDataNative(sessionParams->HyperCommonTypes.parser)
  ->Js.Promise.then_(result => {
    result
    ->Js.Json.decodeObject
    ->Option.getOr(Dict.make())
    ->HyperTypes.parseSavedPaymentMethod
    ->Js.Promise.resolve
  }, _)
}

@genType
let getCustomerSavedPaymentMethodData = (sessionParams: HyperTypes.sessionParams): Js.Promise.t<array<HyperTypes.savedPaymentMethodType>> => {
  hyperswitchSdk->getCustomerSavedPaymentMethodDataNative(sessionParams->HyperCommonTypes.parser)
  ->Js.Promise.then_(result => {
    result
    ->Js.Json.decodeObject
    ->Option.getOr(Dict.make())
    ->HyperTypes.parseAllSavedPaymentMethods
    ->Js.Promise.resolve
  }, _)
}

@genType
let confirmWithCustomerDefaultPaymentMethod = (args: HyperCommonTypes.confirmPaymentMethodArgumentType): Js.Promise.t<HyperTypes.headlessConfirmResponseType> => {
  hyperswitchSdk->confirmWithCustomerDefaultPaymentMethodNative(
    args.sessionParams->HyperCommonTypes.parser,
    args.cvc
  )
  ->Js.Promise.then_(result => {
    result
    ->Js.Json.decodeObject
    ->Option.getOr(Dict.make())
    ->HyperTypes.parseConfirmResponse
    ->Js.Promise.resolve
  }, _)
}

@genType
let confirmWithCustomerLastUsedPaymentMethod = (args: HyperCommonTypes.confirmPaymentMethodArgumentType): Js.Promise.t<HyperTypes.headlessConfirmResponseType> => {
  hyperswitchSdk->confirmWithCustomerLastUsedPaymentMethodNative(
    args.sessionParams->HyperCommonTypes.parser,
    args.cvc
  )
  ->Js.Promise.then_(result => {
    result
    ->Js.Json.decodeObject
    ->Option.getOr(Dict.make())
    ->HyperTypes.parseConfirmResponse
    ->Js.Promise.resolve
  }, _)
}

@genType
let confirmWithCustomerPaymentToken = (args: HyperCommonTypes.confirmWithCustomerPaymentTokenArgumentType): Js.Promise.t<HyperTypes.headlessConfirmResponseType> => {
  hyperswitchSdk->confirmWithCustomerPaymentTokenNative(
    args.sessionParams->HyperCommonTypes.parser,
    args.cvc,
    args.paymentToken
  )

  ->Js.Promise.then_(result => {
    result
    ->Js.Json.decodeObject
    ->Option.getOr(Dict.make())
    ->HyperTypes.parseConfirmResponse
    ->Js.Promise.resolve
  }, _)
}
