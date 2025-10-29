package com.hyperswitchsdkreactnative.views

import android.annotation.SuppressLint
import android.app.Activity
import android.util.Log
import android.view.Choreographer
import android.view.View
import android.widget.FrameLayout
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import com.facebook.react.bridge.Arguments
import com.facebook.react.uimanager.ThemedReactContext
import com.hyperswitchsdkreactnative.internal.ReactFragment
import com.hyperswitchsdkreactnative.provider.HyperProvider

@SuppressLint("ViewConstructor")
class HyperPaymentWidget(private val context: ThemedReactContext) : FrameLayout(context) {

  companion object {
    private const val TAG = "HyperPaymentWidget"
  }

  var widgetType: String = "widgetButtonSheet"
    set(value) {
      field = value
      Log.d(TAG, "Expandable set to: $value")
    }


  private var reactFragment: ReactFragment? = null
  private var fragmentManager: FragmentManager? = null
  private var isInitialized = false


  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    // Delay fragment initialization to ensure view is fully ready
    post {
      initializeWidget()
    }
  }

  private fun initializeWidget() {
    try {
      val activity = this.context.currentActivity
      if (activity is FragmentActivity) {
        fragmentManager = activity.supportFragmentManager
        setupReactFragment()
      }
    } catch (e: Exception) {
    }
  }

  private fun setupReactFragment() {
    try {
      if (id == View.NO_ID) {
        id = View.generateViewId()
      }

      val launchOptions = HyperProvider.getLaunchOptions(
        activity = this.context.currentActivity as Activity,
        Arguments.createMap(),
        widgetType
      )

      reactFragment = ReactFragment.Builder()
        .setComponentName("hyperSwitch")
        .setLaunchOptions(launchOptions)
        .build()

      fragmentManager?.let { fm ->
        if (!isInitialized) {
          val transaction = fm.beginTransaction()
          reactFragment?.let { fragment ->
            transaction.add(
              id,
              fragment,
              "HyperPaymentWidget")
            transaction.commitNow()
            isInitialized = true
          }
        }
      } ?: run {
      }
    } catch (e: Exception) {
    }
  }


  override fun requestLayout() {
    super.requestLayout()

    // Schedule layout update for next frame
    Choreographer.getInstance().postFrameCallback {
      measure(
        MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
        MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY)
      )
      layout(left, top, right, bottom)
    }
  }

  // Public method to refresh the widget
  @SuppressLint("DetachAndAttachSameFragment")
  fun refresh() {
    try {
      reactFragment?.let { fragment ->
        fragmentManager?.let { fm ->
          if (fragment.isAdded) {
            val transaction = fm.beginTransaction()
            transaction.detach(fragment)
            transaction.attach(fragment)
            transaction.commitAllowingStateLoss()
          }
        }
      }
    } catch (e: Exception) {
      Log.e(TAG, "Error refreshing widget: ${e.message}", e)
    }
  }

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    // Clean up fragment when view is detached
    try {
      fragmentManager?.let { fm ->
        reactFragment?.let { fragment ->
          if (fragment.isAdded) {
            val transaction = fm.beginTransaction()
            transaction.remove(fragment)
            transaction.commitAllowingStateLoss()
          }
        }
      }
      reactFragment = null
      isInitialized = false
    } catch (e: Exception) {
      Log.e(TAG, "Error cleaning up fragment: ${e.message}", e)
    }
  }
}
