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
  | @as("Completed") Completed
  | @as("Canceled") Canceled
  | @as("Failed") Failed

type presentPaymentSheetResult = {
  status: status,
  message: string,
  error?: string,
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
