/* TypeScript file generated from HyperTurboModules.res by genType. */

/* eslint-disable */
/* tslint:disable */

import * as HyperTurboModulesJS from './HyperTurboModules.mjs';

import type {confirmPaymentMethodArgumentType as HyperCommonTypes_confirmPaymentMethodArgumentType} from '../../src/types/HyperCommonTypes.gen';

import type {confirmWithCustomerPaymentTokenArgumentType as HyperCommonTypes_confirmWithCustomerPaymentTokenArgumentType} from '../../src/types/HyperCommonTypes.gen';

import type {headlessConfirmResponseType as HyperTypes_headlessConfirmResponseType} from '../../src/types/HyperTypes.gen';

import type {initPaymentSheetParamTypes as HyperTypes_initPaymentSheetParamTypes} from '../../src/types/HyperTypes.gen';

import type {responseFromNativeModule as HyperTypes_responseFromNativeModule} from '../../src/types/HyperTypes.gen';

import type {savedPaymentMethodType as HyperTypes_savedPaymentMethodType} from '../../src/types/HyperTypes.gen';

import type {sessionParams as HyperTypes_sessionParams} from '../../src/types/HyperTypes.gen';

export const initPaymentSession: (initPaymentSessionParams:HyperTypes_initPaymentSheetParamTypes) => Promise<HyperTypes_responseFromNativeModule> = HyperTurboModulesJS.initPaymentSession as any;

export const presentPaymentSheet: (sessionParams:HyperTypes_sessionParams) => Promise<HyperTypes_responseFromNativeModule> = HyperTurboModulesJS.presentPaymentSheet as any;

export const getCustomerSavedPaymentMethods: (sessionParams:HyperTypes_sessionParams) => Promise<HyperTypes_sessionParams> = HyperTurboModulesJS.getCustomerSavedPaymentMethods as any;

export const getCustomerDefaultSavedPaymentMethodData: (sessionParams:HyperTypes_sessionParams) => Promise<HyperTypes_savedPaymentMethodType> = HyperTurboModulesJS.getCustomerDefaultSavedPaymentMethodData as any;

export const getCustomerLastUsedPaymentMethodData: (sessionParams:HyperTypes_sessionParams) => Promise<HyperTypes_savedPaymentMethodType> = HyperTurboModulesJS.getCustomerLastUsedPaymentMethodData as any;

export const getCustomerSavedPaymentMethodData: (sessionParams:HyperTypes_sessionParams) => Promise<HyperTypes_savedPaymentMethodType[]> = HyperTurboModulesJS.getCustomerSavedPaymentMethodData as any;

export const confirmWithCustomerDefaultPaymentMethod: (args:HyperCommonTypes_confirmPaymentMethodArgumentType) => Promise<HyperTypes_headlessConfirmResponseType> = HyperTurboModulesJS.confirmWithCustomerDefaultPaymentMethod as any;

export const confirmWithCustomerLastUsedPaymentMethod: (args:HyperCommonTypes_confirmPaymentMethodArgumentType) => Promise<HyperTypes_headlessConfirmResponseType> = HyperTurboModulesJS.confirmWithCustomerLastUsedPaymentMethod as any;

export const confirmWithCustomerPaymentToken: (args:HyperCommonTypes_confirmWithCustomerPaymentTokenArgumentType) => Promise<HyperTypes_headlessConfirmResponseType> = HyperTurboModulesJS.confirmWithCustomerPaymentToken as any;
