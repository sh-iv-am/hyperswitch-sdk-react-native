package com.hyperswitchsdkreactnative.views

import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = HyperPaymentWidgetViewManager.NAME)
class HyperPaymentWidgetViewManager : SimpleViewManager<HyperPaymentWidget>() {

    override fun getName(): String {
        return NAME
    }

    public override fun createViewInstance(context: ThemedReactContext): HyperPaymentWidget {
        return HyperPaymentWidget(context)
    }

    public override fun onAfterUpdateTransaction(view: HyperPaymentWidget) {
        super.onAfterUpdateTransaction(view)
        // Trigger any updates needed after all props are set
        view.refresh()
    }

    @ReactProp(name = "widgetType")
    fun setWidgetType(view: HyperPaymentWidget?, value: String) {
        view?.widgetType = value
    }



    companion object {
        const val NAME = "HyperswitchPaymentWidget"
    }
}
