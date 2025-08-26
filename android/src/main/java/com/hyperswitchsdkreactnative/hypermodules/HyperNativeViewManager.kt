package com.hyperswitchsdkreactnative.hypermodules

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.HyperswitchSdkReactNativeViewManagerInterface
import com.facebook.react.viewmanagers.HyperswitchSdkReactNativeViewManagerDelegate

@ReactModule(name = HyperNativeViewManager.NAME)
class HyperNativeViewManager : SimpleViewManager<HyperNativeView>(),
  HyperswitchSdkReactNativeViewManagerInterface<HyperNativeView> {
  private val mDelegate: ViewManagerDelegate<HyperNativeView>

  init {
    mDelegate = HyperswitchSdkReactNativeViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<HyperNativeView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): HyperNativeView {
    return HyperNativeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: HyperNativeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "HyperswitchSdkReactNativeView"
  }
}
