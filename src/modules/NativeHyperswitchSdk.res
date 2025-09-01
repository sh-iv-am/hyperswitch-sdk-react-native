type initialiseResult = {
  isready?: bool,
  error?: string,
  status?: string,
  message?: string,
  code?: string,
}

type initialise = (
  ~publishableKey: string,
  ~customBackendUrl: string=?,
  ~customLogUrl: string=?,
  ~customParams: Js.Json.t=?,
) => promise<initialiseResult>

type initPaymentSession = (~paymentIntentClientSecret: string) => promise<initialiseResult>

@genType
type initPaymentSessionParams = {paymentIntentClientSecret?: string}

@genType
type initPaymentSessionResult = initialiseResult

@genType
type presentPaymentSheetParams = PaymentSheetConfiguration.options

type status =
  | @as("Completed") Completed
  | @as("Canceled") Canceled
  | @as("Failed") Failed

type presentPaymentSheetResult = {
  status: status,
  message: string,
  error?: string,
  \"type"?: string,
}

@genType
type presentPaymentSheet = presentPaymentSheetParams => promise<presentPaymentSheetResult>

type nativeHyperswitchSdk = {
  initialise: initialise,
  initPaymentSession: initPaymentSession,
  presentPaymentSheet: presentPaymentSheet,
}

@module("../specs/NativeHyperswitchSdkReactNative")
external nativeHyperswitchSdk: nativeHyperswitchSdk = "default"
