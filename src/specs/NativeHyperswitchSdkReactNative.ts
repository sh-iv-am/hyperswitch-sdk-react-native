import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  initialise(
    publishableKey: string,
    customBackendUrl: undefined | string,
    customLogUrl: undefined | string,
    customParams: undefined | Object
  ): Promise<void>;
  initPaymentSession(paymentIntentClientSecret: string): Promise<string>;
  presentPaymentSheet(configuration: Object): Promise<string>;
  handleBackPress(widgetId: string): Promise<boolean>;
  confirmPayment(widgetId: string): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'HyperswitchSdkReactNative'
);
