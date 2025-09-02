
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

type presentPaymentSheetResult = {
  status: status,
  message: string,
  error?: string,
  \"type"?: string,
}

@genType
type presentPaymentSheet = presentPaymentSheetParams => promise<string>

type nativeHyperswitchSdk = {
  initialise: initialise,
  initPaymentSession: initPaymentSession,
  presentPaymentSheet: presentPaymentSheet,
}

@module("../specs/NativeHyperswitchSdkReactNative")
external nativeHyperswitchSdk: nativeHyperswitchSdk = "default"
