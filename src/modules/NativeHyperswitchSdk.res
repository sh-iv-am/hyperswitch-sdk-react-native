
type initialise = (
  ~publishableKey: string,
  ~customBackendUrl: string=?,
  ~customLogUrl: string=?,
  ~customParams: Js.Json.t=?,
) => promise<unit>

type initPaymentSession = (~paymentIntentClientSecret: string) => promise<unit>

@genType
type initPaymentSessionParams = {paymentIntentClientSecret?: string}

@genType
type initPaymentSessionResult = {error?: string}

@genType
type presentPaymentSheetParams = PaymentSheetConfiguration.options

type status =
  | @as("succeeded") Completed
  | @as("cancelled") Canceled
  | @as("Failed") Failed

@genType
type paymentResult = {
  status: string,
  message: string,
  error?: string,
  \"type"?: string,
}

@genType
type error = {
  code?: string,
  message?: string
}

@genType
type presentPaymentSheetResult = {
  error?: error,
  paymentResult?: paymentResult
}

@genType
type presentPaymentSheet = presentPaymentSheetParams => promise<string>

@genType
type handleBackPressType = (~widgetId: string) => promise<bool>

@genType
type confirmPaymentType = (~widgetId: string) => promise<presentPaymentSheetResult>

type nativeHyperswitchSdk = {
  initialise: initialise,
  initPaymentSession: initPaymentSession,
  presentPaymentSheet: presentPaymentSheet,
  handleBackPress: handleBackPressType,
  confirmPayment: confirmPaymentType,
}

@module("../specs/NativeHyperswitchSdkReactNative")
external nativeHyperswitchSdk: nativeHyperswitchSdk = "default"

@genType
type widgetHandle = {
  goBack: unit => Js.Promise.t<bool>,
  confirmPayment: unit => Js.Promise.t<presentPaymentSheetResult>,
}

@genType
type useHyper = {
  initPaymentSession: initPaymentSessionParams => promise<initPaymentSessionResult>,
  presentPaymentSheet: presentPaymentSheetParams => promise<presentPaymentSheetResult>,
  isPaymentReady: bool,
  paymentMethods: string,
  handleBackPress: string => promise<bool>,
  confirmPayment: string => promise<presentPaymentSheetResult>,
}