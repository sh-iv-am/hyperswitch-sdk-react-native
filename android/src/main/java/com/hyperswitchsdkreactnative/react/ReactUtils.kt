package com.hyperswitchsdkreactnative.react

import android.content.Context
import android.content.pm.ActivityInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import android.webkit.WebSettings
import androidx.appcompat.app.AppCompatActivity
import com.hyperswitchsdkreactnative.internal.ReactFragment
import java.util.Locale

class ReactUtils {
  companion object {

    @JvmStatic
    lateinit var rNFragmentCard: ReactFragment

    @JvmStatic
    var reactNativeFragmentSheet: ReactFragment? = null

    @JvmStatic
    var lastRequest: Bundle? = null
    @JvmStatic
    var flags: Int = 0

    fun openReactView(
      context: AppCompatActivity,
      request: Bundle,
      message: String,
      id: Int?,
      isHidden: Boolean? = false
    ) {
      context.runOnUiThread {
        try {
          val userAgent = getUserAgent(context)
          val ipAddress = getDeviceIPAddress(context)
          context.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LOCKED

          flags = context.window.attributes.flags

          reactNativeFragmentSheet = ReactFragment.Builder()
            .setComponentName("hyperSwitch")
            .setLaunchOptions(
              getLaunchOptions(
                request,
                message,
                context.packageName,
                context.resources.configuration.locale.country,
                userAgent,
                ipAddress
              )
            ).setFabricEnabled(true)
            .build()
          val transaction = context.supportFragmentManager.beginTransaction()
          if (isHidden == true) {
            transaction.hide(reactNativeFragmentSheet!!)
          }
          transaction.add(android.R.id.content, reactNativeFragmentSheet!!)
            .commit()

        } catch (e: Exception) {

        }
      }
    }

    fun getUserAgent(context: Context): String {
      return try {
        WebSettings.getDefaultUserAgent(context)
      } catch (e: RuntimeException) {
        System.getProperty("http.agent") ?: ""
      }
    }

    fun getCurrentTime(): Double {
      return System.currentTimeMillis().toDouble()
    }

    fun getDeviceIPAddress(context: Context): String {
      return try {
        val wifiManager =
          context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val wifiInfo = wifiManager.connectionInfo
        val ipAddress = wifiInfo.ipAddress
        String.format(
          Locale.getDefault(), "%d.%d.%d.%d",
          ipAddress and 0xff,
          ipAddress shr 8 and 0xff,
          ipAddress shr 16 and 0xff,
          ipAddress shr 24 and 0xff
        )
      } catch (e: SecurityException) {
        Log.w("HyperswitchSDK", "ACCESS_WIFI_STATE permission not granted, returning default IP")
        "0.0.0.0"
      } catch (e: Exception) {
        Log.w("HyperswitchSDK", "Failed to get IP address: ${e.message}")
        "0.0.0.0"
      }
    }

    fun hideFragment(context: AppCompatActivity, reset: Boolean) {
      if (reactNativeFragmentSheet != null) {
        context.supportFragmentManager
          .beginTransaction()
//          .setCustomAnimations(R.anim.enter_from_bottom, R.anim.exit_to_bottom)
          .remove(reactNativeFragmentSheet!!)
          .commit()
      }
      context.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
      if (flags != 0) {
        context.runOnUiThread {
          context.window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
          context.window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
          context.window.addFlags(flags)
        }
      }
      if (reset) {
        reactNativeFragmentSheet = null
      }
    }

    fun toBundle(readableMap: Map<*, *>): Bundle {
      val bundle = Bundle()
      for ((key, value) in readableMap) {
        val keyString = key.toString()
        when (value) {
          null -> {} //bundle.putString(keyString, null)
          is Boolean -> bundle.putBoolean(keyString, value)
          is Number -> bundle.putDouble(keyString, value.toDouble())
          is String -> bundle.putString(keyString, value)
          is Map<*, *> -> bundle.putBundle(keyString, toBundle(value))
          is Array<*> -> bundle.putSerializable(keyString, value as? Array<*>)
          else -> throw IllegalArgumentException("Could not convert object with key: $keyString.")
        }
      }
      return bundle
    }

    private fun getLaunchOptions(
      request: Bundle,
      message: String,
      packageName: String,
      country: String,
      userAgent: String,
      ipAddress: String
    ): Bundle {
      request.putString("type", message)
      request.putString("rootTag", "1")
      val hyperParams = Bundle()
      hyperParams.putString("appId", packageName)
      hyperParams.putString("country", country)
      hyperParams.putString("user-agent", userAgent)
      hyperParams.putString("ip", ipAddress)
      hyperParams.putDouble("launchTime", getCurrentTime())
      hyperParams.putString("sdkVersion", "")
      hyperParams.putString("device_model", Build.MODEL)
      hyperParams.putString("os_type", "android")
      hyperParams.putString("os_version", Build.VERSION.RELEASE)
      hyperParams.putString("deviceBrand", Build.BRAND)
      request.putBundle("hyperParams", hyperParams)
      val bundle = Bundle()
      bundle.putBundle("props", request)
      return bundle
    }

  }
}
