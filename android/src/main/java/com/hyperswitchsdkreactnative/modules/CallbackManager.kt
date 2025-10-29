package com.hyperswitchsdkreactnative.modules

import java.util.concurrent.ConcurrentHashMap

object CallbackManager {
    private val callbacks = ConcurrentHashMap<String, () -> Unit>()

    fun register(widgetId: String, callback: () -> Unit) {
        callbacks[widgetId] = callback
    }

    fun execute(widgetId: String): Boolean {
        return callbacks[widgetId]?.let { callback ->
            callback()
            true
        } ?: false
    }

    fun unregister(widgetId: String) {
        callbacks.remove(widgetId)
    }

    fun reset() {
        callbacks.clear()
    }
}
