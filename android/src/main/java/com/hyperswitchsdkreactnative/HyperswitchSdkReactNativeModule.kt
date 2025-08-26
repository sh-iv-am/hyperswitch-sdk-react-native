package com.hyperswitchsdkreactnative

import android.annotation.SuppressLint
import android.app.Activity
import android.os.Bundle
import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import com.facebook.react.ReactActivity
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableType
import com.hyperswitchsdkreactnative.internal.ReactFragment
import com.hyperswitchsdkreactnative.payment.PaymentSession
import com.hyperswitchsdkreactnative.payment.PaymentSessionHandler
import com.hyperswitchsdkreactnative.react.ReactUtils

@ReactModule(name = HyperswitchSdkReactNativeModule.NAME)
class HyperswitchSdkReactNativeModule(reactContext: ReactApplicationContext) :
  NativeHyperswitchSdkReactNativeSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun initPaymentSession(
    params: ReadableMap?,
    promise: Promise?
  ) {
    Log.i(NAME, params.toString())
    val publishableKey = params?.getString("publishableKey")
    Companion.publishableKey = publishableKey ?: ""
    val clientSecret = params?.getString("clientSecret")
    val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
    paymentSession.initPaymentSession(clientSecret ?: "")
    Companion.paymentSession = paymentSession
    val map = Arguments.createMap()
    map.putString("type_", "")
    map.putString("code", "")
    map.putString("message", "payment session initialised")
    map.putString("status", "success")
//    callback?.invoke(map)
    promise?.resolve(map)
  }

  override fun presentPaymentSheet(
    sessionParams: ReadableMap?,
    promise: Promise?
  ) {
    Log.i("DEBUG_LOG", "reached_here")
    val bundleObj = toBundleObject(sessionParams)
    Log.i("data", promise.toString())
    if (promise != null) {
      sheetPromise = promise
//      sheetCallback = callback
    }
    Log.i("Bundle Obj", bundleObj.toString())
    ReactUtils.openReactView(currentActivity as ReactActivity,
      bundleObj, "payment", null)
  }

  override fun getCustomerSavedPaymentMethods(
    sessionParams: ReadableMap?,
    callback: Callback?,
    promise: Promise?
  ) {
    TODO("Not yet implemented")
  }

  override fun getCustomerDefaultSavedPaymentMethodData(
    sessionParams: ReadableMap?,
    callback: Callback?,
    promise: Promise?
  ) {
    TODO("Not yet implemented")
  }

  override fun getCustomerLastUsedPaymentMethodData(
    sessionParams: ReadableMap?,
    callback: Callback?,
    promise: Promise?
  ) {
    TODO("Not yet implemented")
  }

  override fun getCustomerSavedPaymentMethodData(
    sessionParams: ReadableMap?,
    callback: Callback?,
    promise: Promise?
  ) {
    TODO("Not yet implemented")
  }

  override fun confirmWithCustomerDefaultPaymentMethod(
    sessionParams: ReadableMap?,
    cvc: String?,
    callback: Callback?,
    promise: Promise?
  ) {
    TODO("Not yet implemented")
  }

  override fun confirmWithCustomerLastUsedPaymentMethod(
    sessionParams: ReadableMap?,
    cvc: String?,
    callback: Callback?,
    promise: Promise?
  ) {
    TODO("Not yet implemented")
  }

  override fun confirmWithCustomerPaymentToken(
    sessionParams: ReadableMap?,
    cvc: String?,
    paymentToken: String?,
    callback: Callback?,
    promise: Promise?
  ) {
    TODO("Not yet implemented")
  }

   fun launchPaymentSheet() {
    val activity = currentActivity as? FragmentActivity
    activity?.let {
      val bundle = Bundle().apply {
        putBundle("props", Bundle().apply {
          putString("type", "payment")
          putString("publishableKey", "")
          putString("clientSecret", "")
        })
      }

      val reactFragment = ReactFragment.Builder()
        .setComponentName("hyperSwitch")
        .setLaunchOptions(bundle)
        .build()

      val fragmentManager: FragmentManager = it.supportFragmentManager
      val fragmentTransaction: FragmentTransaction = fragmentManager.beginTransaction()
      fragmentTransaction.add(android.R.id.content, reactFragment)
      fragmentTransaction.commit()
    }
  }

  companion object {
    const val NAME = "HyperswitchSDKReactNative"

    @SuppressLint("StaticFieldLeak")
    @JvmStatic
    lateinit var paymentSession: PaymentSession

    @JvmStatic
    lateinit var paymentSessionHandler: PaymentSessionHandler

    @JvmStatic
    lateinit var googlePayCallback: Callback

    @JvmStatic
    lateinit var sheetPromise: Promise

    lateinit var sheetCallback : Callback

    @JvmStatic
    lateinit var publishableKey: String

    fun resolvePaymentSheet(result: Any) {
      try {
        sheetPromise.resolve(result)
      } catch (e: Exception) {
        Log.e("HyperSwitchSDK", "Error resolving payment sheet promise", e)
      }
    }

    fun rejectPaymentSheet(code: String, message: String) {
      try {
        sheetPromise.reject(code, message)
      } catch (e: Exception) {
        Log.e("HyperSwitchSDK", "Error rejecting payment sheet promise", e)
      }
    }


    private fun toBundleObject(readableMap: ReadableMap?): Bundle {
      val result = Bundle()
      val iterator = readableMap?.keySetIterator()
      while (iterator?.hasNextKey() ?: false) {
        val key: String = iterator.nextKey()
        when (readableMap.getType(key)) {
          ReadableType.Null -> result.putString(key, null)
          ReadableType.Boolean -> result.putBoolean(key, readableMap.getBoolean(key))
          ReadableType.Number -> result.putDouble(key, readableMap.getDouble(key))
          ReadableType.String -> result.putString(key, readableMap.getString(key))
          ReadableType.Map -> {
            val nestedMap = readableMap.getMap(key)
            if (nestedMap != null) {
              result.putBundle(key, toBundleObject(nestedMap))
            }
          }
          else -> result.putString(key, readableMap.getString(key))
        }
      }
      return result
    }
  }
}
