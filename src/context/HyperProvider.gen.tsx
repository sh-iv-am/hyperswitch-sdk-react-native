/* TypeScript file generated from HyperProvider.res by genType. */

/* eslint-disable */
/* tslint:disable */

import * as HyperProviderJS from './HyperProvider.mjs';

export type hyperProviderData = { readonly publishableKey: string; readonly customBackendUrl?: string };

export type props<children,publishableKey,customBackendUrl> = {
  readonly children: children; 
  readonly publishableKey?: publishableKey; 
  readonly customBackendUrl?: customBackendUrl
};

export const make: React.ComponentType<{
  readonly children: React.ReactNode; 
  readonly publishableKey?: string; 
  readonly customBackendUrl?: (undefined | string)
}> = HyperProviderJS.make as any;
