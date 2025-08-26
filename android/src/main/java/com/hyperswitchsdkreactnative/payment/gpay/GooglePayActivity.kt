package com.hyperswitchsdkreactnative.payment.gpay

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.wallet.AutoResolveHelper
import com.google.android.gms.wallet.PaymentData
import com.hyperswitchsdkreactnative.payment.gpay.GooglePayCallbackManager.getCallback

import org.json.JSONException
import org.json.JSONObject

class GooglePayActivity : AppCompatActivity() {

    private val gPayRequestCode = 1212

    private val model: GooglePayViewModel by viewModels()


    @SuppressLint("SuspiciousIndentation")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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

    }


    private fun requestPayment(paymentDataRequestJson: JSONObject) {
        val task = model.getLoadPaymentDataTask(paymentDataRequestJson)

        // Calling GPay UI for Payment with gPayRequestCode for onActivityResult
        AutoResolveHelper.resolveTask(task, this, gPayRequestCode)
    }

  private fun handlePaymentSuccess(paymentData: PaymentData) {
    // Use MutableMap for dynamic data
    val map: MutableMap<String, Any?> = mutableMapOf()
    try {
      val paymentInformation = paymentData.toJson()
      map["paymentMethodData"] = JSONObject(paymentInformation).toString()
    } catch (error: JSONException) {
      map["error"] = error.message
    }
    getCallback()?.invoke(map)
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
