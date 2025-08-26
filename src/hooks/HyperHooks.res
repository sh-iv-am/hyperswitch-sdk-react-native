// Import common types
open HyperCommonTypes

// Re-export types for external usage
@genType
type confirmPaymentMethodArgumentType = HyperCommonTypes.confirmPaymentMethodArgumentType

@genType
type confirmWithCustomerPaymentTokenArgumentType = HyperCommonTypes.confirmWithCustomerPaymentTokenArgumentType

@genType
type useHyperReturnType = HyperCommonTypes.useHyperReturnType

// Check if TurboModules are available via global.__turboModuleProxy
@val external turboModuleProxy: Js.Nullable.t<'a> = "global.__turboModuleProxy"

let isTurboModuleAvailable = () => {
  true
  // turboModuleProxy->Js.Nullable.isNullable->not
}

@genType
let useHyper = (): useHyperReturnType => {
  let (hyperVal, _) = React.useContext(HyperProvider.hyperProviderContext)

  let initPaymentSession =async (
    initPaymentSheetParams: HyperTypes.initPaymentSheetParamTypes,
  ) => {
    let hsSdkParams: HyperTypes.sessionParams = {
      configuration: initPaymentSheetParams.configuration->Option.getOr({}),
      customBackendUrl: hyperVal.customBackendUrl,
      publishableKey: initPaymentSheetParams.publishableKey->Option.getOr(hyperVal.publishableKey),
      clientSecret: initPaymentSheetParams.clientSecret,
      \"type": "payment",
      from: "rn",
    }

    let res = await HyperTurboModules.initPaymentSession(initPaymentSheetParams)
    if (res.status === "success") {
      Console.log2("Initialized payment session:", res)
      hsSdkParams
    }else{
      let errorMessage = res.message == "" ? "Failed to initialize payment session" : res.message
      Js.Exn.raiseError(errorMessage)
    }

  }

  let presentPaymentSheet = (
    paySheetParams: HyperTypes.sessionParams,
  ) => {
    // if isTurboModuleAvailable() {
      HyperTurboModules.presentPaymentSheet(paySheetParams)
    // } else {
    //   let paySheetParamsJson = paySheetParams->parser

    //   Js.Promise.make((~resolve: HyperTypes.responseFromNativeModule => unit, ~reject as _) => {
    //     let responseResolve = _ => {
    //       resolve({
    //         type_: "payment",
    //         code: "200",
    //         message: "Payment sheet presented successfully",
    //         status: "success",
    //       })
    //     }
    //     HyperNativeModules.presentPaymentSheet(paySheetParamsJson, responseResolve)
    //   })
    // }
  }
  

  let getCustomerSavedPaymentMethods = (paySheetParams: HyperTypes.sessionParams) => {
    if isTurboModuleAvailable() {
      HyperTurboModules.getCustomerSavedPaymentMethods(paySheetParams)
    } else {
      let paySheetParamsJson = paySheetParams->parser
      Js.Promise.make((~resolve: HyperTypes.sessionParams => unit, ~reject as _) => {
        let responseResolve = _ => {
          resolve(paySheetParams)
        }
        HyperNativeModules.getCustomerSavedPaymentMethods(paySheetParamsJson, responseResolve)
      })
    }
  }
  let getCustomerDefaultSavedPaymentMethodData = (paySheetParams: HyperTypes.sessionParams) => {
    if isTurboModuleAvailable() {
      HyperTurboModules.getCustomerDefaultSavedPaymentMethodData(paySheetParams)
    } else {
      let paySheetParamsJson = paySheetParams->parser
      Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
        let responseResolve = arg => {
          let val = arg->HyperTypes.parseSavedPaymentMethod
          resolve(val)
        }
        HyperNativeModules.getCustomerDefaultSavedPaymentMethodData(
          paySheetParamsJson,
          responseResolve,
        )
      })
    }
  }

  let getCustomerLastUsedPaymentMethodData = (paySheetParams: HyperTypes.sessionParams) => {
    if isTurboModuleAvailable() {
      HyperTurboModules.getCustomerLastUsedPaymentMethodData(paySheetParams)
    } else {
      let paySheetParamsJson = paySheetParams->parser
      Js.Promise.make((~resolve: HyperTypes.savedPaymentMethodType => unit, ~reject as _) => {
        let responseResolve = arg => {
          let val = arg->HyperTypes.parseSavedPaymentMethod
          resolve(val)
        }
        HyperNativeModules.getCustomerLastUsedPaymentMethodData(paySheetParamsJson, responseResolve)
      })
    }
  }

  let getCustomerSavedPaymentMethodData = (paySheetParams: HyperTypes.sessionParams) => {
    if isTurboModuleAvailable() {
      HyperTurboModules.getCustomerSavedPaymentMethodData(paySheetParams)
    } else {
      let paySheetParamsJson = paySheetParams->parser
      Js.Promise.make((
        ~resolve: array<HyperTypes.savedPaymentMethodType> => unit,
        ~reject as _,
      ) => {
        let responseResolve = arg => {
          let val = arg->HyperTypes.parseAllSavedPaymentMethods
          resolve(val)
        }
        HyperNativeModules.getCustomerSavedPaymentMethodData(paySheetParamsJson, responseResolve)
      })
    }
  }

  let confirmWithCustomerDefaultPaymentMethod = (arguments: confirmPaymentMethodArgumentType) => {
    if isTurboModuleAvailable() {
      HyperTurboModules.confirmWithCustomerDefaultPaymentMethod(arguments)
    } else {
      let paySheetParamsJson = arguments.sessionParams->parser
      Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
        let responseResolve = arg => {
          let val = arg->HyperTypes.parseConfirmResponse
          resolve(val)
        }
        HyperNativeModules.confirmWithCustomerDefaultPaymentMethod(
          paySheetParamsJson,
          arguments.cvc,
          responseResolve,
        )
      })
    }
  }

  let confirmWithCustomerLastUsedPaymentMethod = (arguments: confirmPaymentMethodArgumentType) => {
    if isTurboModuleAvailable() {
      HyperTurboModules.confirmWithCustomerLastUsedPaymentMethod(arguments)
    } else {
      let paySheetParamsJson = arguments.sessionParams->parser
      Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
        let responseResolve = arg => {
          let val = arg->HyperTypes.parseConfirmResponse
          resolve(val)
        }
        HyperNativeModules.confirmWithCustomerLastUsedPaymentMethod(
          paySheetParamsJson,
          arguments.cvc,
          responseResolve,
        )
      })
    }
  }

  let confirmWithCustomerPaymentToken = (
    arguments: confirmWithCustomerPaymentTokenArgumentType,
  ) => {
    if isTurboModuleAvailable() {
      HyperTurboModules.confirmWithCustomerPaymentToken(arguments)
    } else {
      let paySheetParamsJson = arguments.sessionParams->parser
      Js.Promise.make((~resolve: HyperTypes.headlessConfirmResponseType => unit, ~reject as _) => {
        let responseResolve = arg => {
          let val = arg->HyperTypes.parseConfirmResponse
          resolve(val)
        }
        HyperNativeModules.confirmWithCustomerPaymentToken(
          paySheetParamsJson,
          arguments.cvc,
          arguments.paymentToken,
          responseResolve,
        )
      })
    }
  }

  {
    initPaymentSession,
    presentPaymentSheet,
    getCustomerSavedPaymentMethods,
    getCustomerDefaultSavedPaymentMethodData,
    getCustomerLastUsedPaymentMethodData,
    getCustomerSavedPaymentMethodData,
    confirmWithCustomerDefaultPaymentMethod,
    confirmWithCustomerLastUsedPaymentMethod,
    confirmWithCustomerPaymentToken,
  }
}
