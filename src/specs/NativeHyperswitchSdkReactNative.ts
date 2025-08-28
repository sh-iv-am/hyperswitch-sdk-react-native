import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  initialise(
    publishableKey: string,
    customBackendUrl: undefined | string,
    customLogUrl: undefined | string,
    customParams: undefined | Object
  ): Promise<void>;
  initPaymentSession(paymentIntentClientSecret: string): Promise<void>;
  presentPaymentSheet(configuration: Object): Promise<Object>;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'HyperswitchSdkReactNative'
);
