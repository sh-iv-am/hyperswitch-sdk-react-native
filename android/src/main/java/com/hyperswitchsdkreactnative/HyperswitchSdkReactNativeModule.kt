package com.hyperswitchsdkreactnative

import android.os.Bundle
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import com.hyperswitchreactnative.internal.ReactFragment

@ReactModule(name = HyperswitchSdkReactNativeModule.NAME)
class HyperswitchSdkReactNativeModule(reactContext: ReactApplicationContext) :
  NativeHyperswitchSdkReactNativeSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun launchPaymentSheet() {
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
    const val NAME = "HyperswitchSdkReactNative"
  }
}
