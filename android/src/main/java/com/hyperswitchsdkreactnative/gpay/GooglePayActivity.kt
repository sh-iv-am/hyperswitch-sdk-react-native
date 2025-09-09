package com.hyperswitchsdkreactnative.gpay

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.wallet.AutoResolveHelper
import com.google.android.gms.wallet.PaymentData
import org.json.JSONException
import org.json.JSONObject
import androidx.activity.viewModels
import com.hyperswitchsdkreactnative.gpay.GooglePayCallbackManager.getCallback


class GooglePayActivity : AppCompatActivity() {

  private val gPayRequestCode = 1212

  private val model: GooglePayViewModel by viewModels()


  @SuppressLint("SuspiciousIndentation")
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    try {
      val intent = intent
      val gPayRequest = JSONObject(intent.getStringExtra("gPayRequest").toString())
      var isReadyToPayJson: JSONObject? = null
      var environment = "TEST" // Default Value is Test
      if (gPayRequest.has("paymentDataRequest") and gPayRequest.has("environment")) {
        isReadyToPayJson = gPayRequest.getJSONObject("paymentDataRequest")
        environment = gPayRequest.getString("environment").uppercase()
      }

      var test = false

      if (isReadyToPayJson != null) {
        test = model.fetchCanUseGooglePay(isReadyToPayJson, environment)
      }

      if (test && gPayRequest.has("paymentDataRequest")) {
        requestPayment(gPayRequest.getJSONObject("paymentDataRequest"))
      } else {
        Log.e("GooglePay", "GPay PaymentRequest Not available")
      }
    } catch (e: Exception) {
      Log.e("GooglePay", "Error in onCreate: ${e.message}")
      finish()
    }
  }


  private fun requestPayment(paymentDataRequestJson: JSONObject) {
    try {
      val task = model.getLoadPaymentDataTask(paymentDataRequestJson)

      // Calling GPay UI for Payment with gPayRequestCode for onActivityResult
      AutoResolveHelper.resolveTask(task, this, gPayRequestCode)
    } catch (e: Exception) {
      handleError("Failed to initiate Google Pay payment: ${e.message}")
    }
  }

  private fun handlePaymentSuccess(paymentData: PaymentData) {
    val map: MutableMap<String, Any?> = mutableMapOf()
    try {
      // Use MutableMap for dynamic data
      val paymentInformation = paymentData.toJson()
      map["paymentMethodData"] = JSONObject(paymentInformation).toString()
      getCallback()?.invoke(map)
    } catch (error: JSONException) {
      map["error"] = error.message
      getCallback()?.invoke(map)
    }
    finish()
  }

  private fun handleError(message: String) {
    val map: MutableMap<String, Any?> = mutableMapOf()
    map["error"]  =  message
    getCallback()?.invoke(map)
    finish()
  }


  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)

    if (requestCode == gPayRequestCode) {
      when (resultCode) {
        RESULT_OK -> data?.let { intent ->
          PaymentData.getFromIntent(intent)?.let(::handlePaymentSuccess)
        }
        RESULT_CANCELED -> handleError("Cancel")
        else -> handleError("Failure")
      }
    }
  }
}
