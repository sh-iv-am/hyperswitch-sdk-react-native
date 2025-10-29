// import PaymentWidget from './specs/PaymentWidget';

export type { props as HyperProviderProps } from './context/HyperProvider.gen';
export type {
  initPaymentSessionParams as InitPaymentSessionParams,
  initPaymentSessionResult as InitPaymentSessionResult,
  presentPaymentSheetParams as PresentPaymentSheetParams,
  presentPaymentSheetResult as PresentPaymentSheetResult,
  widgetHandle as PaymentWidgetHandle,
} from './modules/NativeHyperswitchSdk.gen';

export {
  make as HyperProvider,
  initHyperswitch,
} from './context/HyperProvider.gen';
export { useHyper } from './hooks/useHyper.gen';
export { make as PaymentWidget } from './components/HyperswitchPaymentWidget.res';
