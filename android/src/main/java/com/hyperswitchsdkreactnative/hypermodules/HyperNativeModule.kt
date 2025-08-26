package com.hyperswitchsdkreactnative.hypermodules

import android.app.Activity
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactMethod
import android.util.Log
import com.facebook.react.ReactActivity
import com.facebook.react.bridge.Arguments
import com.hyperswitchsdkreactnative.HyperswitchSdkReactNativeModule
import com.hyperswitchsdkreactnative.NativeHyperModulesSpec
import com.hyperswitchsdkreactnative.react.ReactUtils

/**
 * HyperModules TurboModule implementation that bridges the bundle's expectations
 * with the existing HyperswitchSdkModule functionality
 */
class HyperNativeModule(reactContext: ReactApplicationContext) :
  NativeHyperModulesSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  override fun sendMessageToNative(message: String) {
    Log.d(NAME, "sendMessageToNative called with: $message")
    // Forward to HyperswitchSdkModule if needed
  }

  @ReactMethod
  override fun launchApplePay(requestObj: String, callback: Callback) {
    Log.d(NAME, "launchApplePay called")
    // Implementation for Apple Pay
    callback.invoke("Apple Pay not implemented")
  }

  @ReactMethod
  override fun startApplePay(requestObj: String, callback: Callback) {
    Log.d(NAME, "startApplePay called")
    callback.invoke("Apple Pay start not implemented")
  }

  @ReactMethod
  override fun presentApplePay(requestObj: String, callback: Callback) {
    Log.d(NAME, "presentApplePay called")
    callback.invoke("Apple Pay present not implemented")
  }

  @ReactMethod
  override fun launchGPay(requestObj: String, callback: Callback) {
    Log.d(NAME, "launchGPay called")
    // Implementation for Google Pay
    callback.invoke("Google Pay not implemented")
  }

  @ReactMethod
  override fun exitPaymentsheet(rootTag: Double, result: String, reset: Boolean) {
    Log.d(NAME, "exitPaymentsheet called")
    ReactUtils.hideFragment(currentActivity as ReactActivity, true)
    HyperswitchSdkReactNativeModule.resolvePaymentSheet(result)
  }

  @ReactMethod
  override fun exitPaymentMethodManagement(rootTag: Double, result: String, reset: Boolean) {
    Log.d(NAME, "exitPaymentMethodManagement called")
    // Implementation for exiting payment method management
  }

  @ReactMethod
  override fun exitWidget(result: String, widgetType: String) {
    Log.d(NAME, "exitWidget called with result: $result, widgetType: $widgetType")
    // Implementation for exiting widget
  }

  @ReactMethod
  override fun exitCardForm(result: String) {
    Log.d(NAME, "exitCardForm called with result: $result")
    // Implementation for exiting card form
  }

  @ReactMethod
  override fun exitWidgetPaymentsheet(rootTag: Double, result: String, reset: Boolean) {
    Log.d(NAME, "exitWidgetPaymentsheet called")
    // Implementation for exiting widget payment sheet
  }

  @ReactMethod
  override fun launchWidgetPaymentSheet(requestObj: String, callback: Callback) {
    Log.d(NAME, "launchWidgetPaymentSheet called")
    // Implementation for launching widget payment sheet
    callback.invoke("Widget payment sheet not implemented")
  }

  @ReactMethod
  override fun updateWidgetHeight(height: Double) {
    Log.d(NAME, "updateWidgetHeight called with height: $height")
    // Implementation for updating widget height
  }

  @ReactMethod
  override fun onAddPaymentMethod(data: String) {
    Log.d(NAME, "onAddPaymentMethod called with data: $data")
    // Implementation for adding payment method
  }

  companion object {
    const val NAME = "HyperModules"
  }
}
