import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  // Initialize a payment session with configuration parameters
  initPaymentSession(params: Object): Promise<Object>;

  // Present the payment sheet UI to the user
  presentPaymentSheet(sessionParams: Object): Promise<Object>;

  // Retrieve all saved payment methods for the customer
  getCustomerSavedPaymentMethods(sessionParams: Object, callback: (result: Object) => void): Promise<Object>;

  // Get the customer's default saved payment method
  getCustomerDefaultSavedPaymentMethodData(
    sessionParams: Object,
    callback: (result: Object) => void
  ): Promise<Object>;

  // Get the customer's last used payment method
  getCustomerLastUsedPaymentMethodData(sessionParams: Object, callback: (result: Object) => void): Promise<Object>;

  // Get all customer's saved payment method data
  getCustomerSavedPaymentMethodData(
    sessionParams: Object,
    callback: (result: Object) => void
  ): Promise<Array<Object>>;

  // Confirm payment with customer's default payment method
  confirmWithCustomerDefaultPaymentMethod(
    sessionParams: Object,
    cvc: string | null | undefined,
    callback: (result: Object) => void
  ): Promise<Object>;

  // Confirm payment with customer's last used payment method
  confirmWithCustomerLastUsedPaymentMethod(
    sessionParams: Object,
    cvc: string | null | undefined,
    callback: (result: Object) => void
  ): Promise<Object>;

  // Confirm payment with specific customer payment token
  confirmWithCustomerPaymentToken(
    sessionParams: Object,
    cvc: string | null | undefined,
    paymentToken: string,
    callback: (result: Object) => void
  ): Promise<Object>;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'HyperswitchSDKReactNative'
) as Spec;
