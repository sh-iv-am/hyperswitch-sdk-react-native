package com.hyperswitchsdkreactnative.modules

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.hyperswitchsdkreactnative.NativeHyperswitchSdkReactNativeSpec
import com.hyperswitchsdkreactnative.provider.HyperProvider

@ReactModule(name = HyperswitchSdkReactNativeModule.NAME)
class HyperswitchSdkReactNativeModule(reactContext: ReactApplicationContext) :
  NativeHyperswitchSdkReactNativeSpec(reactContext) {

  private var hyperProvider: HyperProvider? = null

  override fun getName(): String {
    return NAME
  }

  override fun initialise(
    publishableKey: String,
    customBackendUrl: String?,
    customLogUrl: String?,
    customParams: ReadableMap?,
    promise: Promise?
  ) {
    try {
      currentActivity?.let { activity ->
        hyperProvider = HyperProvider(activity)
        hyperProvider!!.initialise(publishableKey, customBackendUrl, customLogUrl, customParams)
        promise?.resolve(null)
      } ?: run {
        promise?.reject("INITIALIZATION_ERROR", "Current activity is null")
      }
    } catch (e: Exception) {
      promise?.reject("INITIALIZATION_ERROR", "Failed to initialize Hyperswitch SDK: ${e.message}")
    }
  }

  override fun initPaymentSession(paymentIntentClientSecret: String, promise: Promise?) {
    try {
      hyperProvider?.let { provider ->
        provider.initPaymentSession(clientSecret = paymentIntentClientSecret)
        promise?.resolve(null)
      } ?: run {
        promise?.reject("INIT_ERROR", "HyperProvider not initialized")
      }
    } catch (e: Exception) {
      promise?.reject("INIT_ERROR", "Failed to initialize payment sheet: ${e.message}")
    }
  }

  override fun presentPaymentSheet(promise: Promise?) {
    try {
      hyperProvider?.let { provider ->
        provider.presentPaymentSheet { result ->
          when (result.status) {
            "completed" -> {
              val resultMap: WritableMap = WritableNativeMap().apply {
                putString("status", "completed")
                putString("message", result.message)
              }
              promise?.resolve(resultMap)
            }
            "canceled" -> {
              val resultMap: WritableMap = WritableNativeMap().apply {
                putString("status", "canceled")
                putString("message", "canceled")
              }
              promise?.resolve(resultMap)
            }
            "failed" -> {
              promise?.reject("PAYMENT_ERROR", result.message)
            }
          }
        }
      }
    } catch (e: Exception) {
      promise?.reject("PRESENT_ERROR", "Failed to present payment sheet: ${e.message}")
    }
  }

  companion object {
    const val NAME = "HyperswitchSdkReactNative"
  }
}
