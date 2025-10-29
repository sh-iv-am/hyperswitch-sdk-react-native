package com.hyperswitchsdkreactnative.modules

import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import org.json.JSONException
import com.hyperswitchsdkreactnative.NativeHyperswitchSdkNativeSpec
import com.hyperswitchsdkreactnative.modules.HyperswitchSdkReactNativeModule.Companion.resetView
import com.hyperswitchsdkreactnative.modules.HyperswitchSdkReactNativeModule.Companion.resolvePromise
import com.hyperswitchsdkreactnative.gpay.GooglePayCallbackManager
import com.hyperswitchsdkreactnative.modules.HyperswitchSdkReactNativeModule.Companion.resolveBackPromise
import org.json.JSONObject

/**
 * HyperModules TurboModule implementation that bridges the bundle's expectations
 * with the existing HyperswitchSdkModule functionality
 */
class HyperswitchSdkNativeModule(reactContext: ReactApplicationContext) :
  NativeHyperswitchSdkNativeSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  private var listenerCount = 0

  init {
    HyperEventEmitter.initialize(this.reactApplicationContext)
  }

  @ReactMethod
  fun addListener(eventName: String?) {
    if (listenerCount == 0) {
      HyperEventEmitter.initialize(this.reactApplicationContext)
    }
    listenerCount += 1
  }

  @ReactMethod
  fun removeListeners(count: Int) {
    listenerCount -= count
    if (listenerCount == 0) {
      // Remove upstream listeners, stop unnecessary background task
    }
  }

  @ReactMethod
  override fun sendMessageToNative(message: String) {
    Log.d(NAME, "sendMessageToNative called with: $message")
//    val jsonObject = JSONObject(message)
//    Log.i("NativeEventReceived", jsonObject.toString())
//    if (jsonObject.optString("eventName", "event") == "BACK_BUTTON_RES") {
////        resolveBackPromise(jsonObject.getJSONObject("data").optBoolean("shouldBackPress"))
//    }

  }

  @ReactMethod
  override fun launchApplePay(requestObj: String, callback: Callback) {
//    Log.d(NAME, "launchApplePay called")
    // Implementation for Apple Pay
    callback.invoke("Apple Pay not implemented")
  }

  override fun invalidate() {
    super.invalidate()
    HyperEventEmitter.deinitialize()
  }

  @ReactMethod
  override fun launchGPay(requestObj: String, callback: Callback) {
    currentActivity?.let {
      GooglePayCallbackManager.setCallback(
        it,
        requestObj,
        fun(data: Map<String, Any?>) {
          callback.invoke(mapToWritableMap(data))
        },
      )
    } ?: run {
      GooglePayCallbackManager.setCallback(
        reactApplicationContext,
        requestObj,
        fun(data: Map<String, Any?>) {
          callback.invoke(mapToWritableMap(data))
        },
      )
    }
  }

  @ReactMethod
  override fun exitPaymentsheet(rootTag: Double, result: String, reset: Boolean) {
    try {
      resetView()
      resolvePromise(result)
    } catch (e: JSONException) {
      // Log.e(NAME, "Failed to parse JSON result: $result", e)
      resolvePromise(result)
    }

  }

  @ReactMethod
  override fun exitPaymentMethodManagement(rootTag: Double, result: String, reset: Boolean) {
//    Log.d(NAME, "exitPaymentMethodManagement called $result")
    resolvePromise(result)

    // Implementation for exiting payment method management
  }

  @ReactMethod
  override fun exitWidget(result: String, widgetType: String) {
//    Log.d(NAME, "exitWidget called with result: $result, widgetType: $widgetType")
    resolvePromise(result)
    // Implementation for exiting widget
  }

  @ReactMethod
  override fun exitCardForm(result: String) {
//    Log.d(NAME, "exitCardForm called with result: $result")
//    try {
//      resetView()
//      resolvePromise(result)
//    } catch (e: JSONException) {
//      // Log.e(NAME, "Failed to parse JSON result: $result", e)
//      resolvePromise(result)
//    }
    // Implementation for exiting card form
  }

  @ReactMethod
  override fun exitWidgetPaymentsheet(rootTag: Double, result: String, reset: Boolean) {
//    Log.d(NAME, "exitWidgetPaymentsheet called")
//    try {
////      resetView()
//      resolvePromise(result)
//    } catch (e: JSONException) {
//      // Log.e(NAME, "Failed to parse JSON result: $result", e)
//      resolvePromise(result)
//    }
    // Implementation for exiting widget payment sheet
  }

  @ReactMethod
  override fun launchWidgetPaymentSheet(requestObj: String, callback: Callback) {
//    Log.d(NAME, "launchWidgetPaymentSheet called")
    // Implementation for launching widget payment sheet
    callback.invoke("Widget payment sheet not implemented")
  }

  @ReactMethod
  override fun updateWidgetHeight(height: Double) {
//    Log.d(NAME, "updateWidgetHeight called with height: $height")
    // Implementation for updating widget height
  }

  @ReactMethod
  override fun onAddPaymentMethod(data: String) {
//    Log.d(NAME, "onAddPaymentMethod called with data: $data")
    // Implementation for adding payment method
  }

  private fun mapToWritableMap(map: Map<String, Any?>): WritableMap {
    val writableMap = WritableNativeMap()
    for ((key, value) in map) {
      when (value) {
        null -> writableMap.putNull(key)
        is Boolean -> writableMap.putBoolean(key, value)
        is Double -> writableMap.putDouble(key, value)
        is Int -> writableMap.putInt(key, value)
        is String -> writableMap.putString(key, value)
        is Map<*, *> -> writableMap.putMap(key, mapToWritableMap(value as Map<String, Any?>))
        else -> writableMap.putString(key, value.toString())
      }
    }
    return writableMap
  }

  companion object {
    const val NAME = "HyperModules"

    fun handleBackPressFromRN() {
      val eventData = mutableMapOf<String, String?>(
        "message" to "handleBackPress is called in js side from native"
      )
      HyperEventEmitter.confirmStatic("handleBackPress", eventData)
    }

    fun handlePaymentFromRN(){
      val eventData = mutableMapOf<String, String?>(
        "message" to "confirmPayment is called in js side from native"
      )
      HyperEventEmitter.confirmStatic("confirmPayment", eventData)
    }
  }
}
