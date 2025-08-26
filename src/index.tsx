// // import HyperswitchSdkReactNative from './specs/NativeHyperswitchSdkReactNative';
export { default as HyperswitchReactNativeView } from './specs/HyperswitchSdkReactNativeViewNativeComponent';

// // export function launchPaymentSheet(): void {
// //   return HyperswitchSdkReactNative.launchPaymentSheet();
// // }

export { useHyper } from './hooks/HyperHooks.gen';
export { make as HyperProvider } from './context/HyperProvider.gen';

// Export types
export type { sessionParams, initPaymentSheetParamTypes, responseFromNativeModule, savedPaymentMethodType, headlessConfirmResponseType } from './types/HyperTypes.gen';
export type { confirmPaymentMethodArgumentType, confirmWithCustomerPaymentTokenArgumentType, useHyperReturnType } from './types/HyperCommonTypes.gen';
