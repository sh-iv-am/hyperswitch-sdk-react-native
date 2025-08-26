// Common types shared across Hyperswitch SDK modules
// This file contains types used by both HyperHooks and HyperNativeModules

// JSON parser utility for session parameters
external parser: HyperTypes.sessionParams => Js.Json.t = "%identity"

// Argument type for payment methods that require CVC
@genType
type confirmPaymentMethodArgumentType = {
  sessionParams: HyperTypes.sessionParams,
  cvc?: string,
}

// Argument type for payment methods with customer payment token
@genType
type confirmWithCustomerPaymentTokenArgumentType = {
  sessionParams: HyperTypes.sessionParams,
  cvc?: string,
  paymentToken: string,
}

// Hook return type defining all available payment operations
@genType
type useHyperReturnType = {
  initPaymentSession: (HyperTypes.initPaymentSheetParamTypes) => promise<HyperTypes.sessionParams>,
  presentPaymentSheet: (HyperTypes.sessionParams) => promise<HyperTypes.responseFromNativeModule>,
  getCustomerSavedPaymentMethods: HyperTypes.sessionParams => promise<HyperTypes.sessionParams>,
  getCustomerDefaultSavedPaymentMethodData: HyperTypes.sessionParams => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerLastUsedPaymentMethodData: HyperTypes.sessionParams => promise<
    HyperTypes.savedPaymentMethodType,
  >,
  getCustomerSavedPaymentMethodData: HyperTypes.sessionParams => promise<
    array<HyperTypes.savedPaymentMethodType>,
  >,
  confirmWithCustomerDefaultPaymentMethod: confirmPaymentMethodArgumentType => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
  confirmWithCustomerLastUsedPaymentMethod: confirmPaymentMethodArgumentType => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
  confirmWithCustomerPaymentToken: confirmWithCustomerPaymentTokenArgumentType => promise<
    HyperTypes.headlessConfirmResponseType,
  >,
}

// Native module callback function types
type jsonFunWithCallback = (Js.Json.t, Js.Dict.t<Js.Json.t> => unit) => unit
type strFunWithCallback = (Js.Json.t, option<string>, Js.Dict.t<Js.Json.t> => unit) => unit
type strFun2WithCallback = (Js.Json.t, option<string>, string, Js.Dict.t<Js.Json.t> => unit) => unit