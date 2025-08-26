/* TypeScript file generated from HyperNativeModules.res by genType. */

/* eslint-disable */
/* tslint:disable */

import type {sessionParams as HyperTypes_sessionParams} from '../../src/types/HyperTypes.gen';

export type confirmPaymentMethodArgumentType = { readonly sessionParams: HyperTypes_sessionParams; readonly cvc?: string };

export type confirmWithCustomerPaymentTokenArgumentType = {
  readonly sessionParams: HyperTypes_sessionParams; 
  readonly cvc?: string; 
  readonly paymentToken: string
};
