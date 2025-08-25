import HyperswitchSdkReactNative from './specs/NativeHyperswitchSdkReactNative';
export { default as HyperswitchReactNativeView } from './specs/HyperswitchSdkReactNativeViewNativeComponent';

export function launchPaymentSheet(): void {
  return HyperswitchSdkReactNative.launchPaymentSheet();
}