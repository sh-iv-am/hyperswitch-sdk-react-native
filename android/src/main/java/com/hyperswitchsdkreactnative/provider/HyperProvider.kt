package com.hyperswitchsdkreactnative.provider

import android.app.Activity
import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import com.facebook.react.bridge.ReadableMap
import com.hyperswitchsdkreactnative.internal.ReactFragment
import org.json.JSONObject

data class PaymentResult(
  val status: String,
  val message: String,
)

internal class HyperProvider internal constructor(private val activity: Activity) {

  private var publishableKey: String? = null
  private var customBackendUrl: String? = null
  private var customLogUrl: String? = null
  private var customParams: ReadableMap? = null
  private var clientSecret: String? = null

  fun initialise(
    publishableKey: String?,
    customBackendUrl: String?,
    customLogUrl: String?,
    customParams: ReadableMap?
  ) {
    this.publishableKey = publishableKey
    this.customBackendUrl = customBackendUrl
    this.customLogUrl = customLogUrl
    this.customParams = customParams
  }

  fun initPaymentSession(clientSecret: String) {
    this.clientSecret = clientSecret
  }

  fun presentPaymentSheet(callback: (PaymentResult) -> Unit) {
    val activity = activity as? FragmentActivity
    activity?.let {
      val propsBundle = Bundle().apply {
        putString("type", "payment")
        putString("publishableKey", publishableKey ?: "")
        putString("clientSecret", clientSecret ?: "")
        customBackendUrl?.let { url -> putString("customBackendUrl", url) }
        customLogUrl?.let { url -> putString("customLogUrl", url) }
        customParams?.let { params -> putString("customParams", JSONObject(params.toHashMap()).toString()) }
      }

      val bundle = Bundle().apply {
        putBundle("props", propsBundle)
      }

      val reactFragment = ReactFragment.Builder()
        .setComponentName("hyperSwitch")
        .setLaunchOptions(bundle)
        .build()

      val fragmentManager: FragmentManager = it.supportFragmentManager
      val fragmentTransaction: FragmentTransaction = fragmentManager.beginTransaction()
      fragmentTransaction.add(android.R.id.content, reactFragment, "HyperPaymentSheet")
      fragmentTransaction.addToBackStack("HyperPaymentSheet")
      fragmentTransaction.commit()
    } ?: run {
      callback(PaymentResult(status = "failed", message = "Activity is not a FragmentActivity"))
    }
  }
}
