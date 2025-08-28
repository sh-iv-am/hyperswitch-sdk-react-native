package com.hyperswitchsdkreactnative.modules

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.HyperswitchSdkReactNativeViewManagerInterface
import com.facebook.react.viewmanagers.HyperswitchSdkReactNativeViewManagerDelegate

@ReactModule(name = HyperswitchSdkReactNativeViewManager.NAME)
class HyperswitchSdkReactNativeViewManager : SimpleViewManager<HyperswitchSdkReactNativeView>(),
  HyperswitchSdkReactNativeViewManagerInterface<HyperswitchSdkReactNativeView> {
  private val mDelegate: ViewManagerDelegate<HyperswitchSdkReactNativeView>

  init {
    mDelegate = HyperswitchSdkReactNativeViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<HyperswitchSdkReactNativeView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): HyperswitchSdkReactNativeView {
    return HyperswitchSdkReactNativeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: HyperswitchSdkReactNativeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "HyperswitchSdkReactNativeView"
  }
}
