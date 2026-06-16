package com.rnbridge

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.Arguments

class RnBridgeModule(reactContext: ReactApplicationContext) :
  NativeRnBridgeSpec(reactContext) {

  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  override fun greet(name: String): String {
    return "Hello, $name!"
  }

  override fun triggerHaptic(type: String, promise: Promise): Unit {
    // TODO: Implement haptic feedback for Android
    // For now, just log it
    android.util.Log.i("RnBridge", "Haptic triggered: $type")
  }

  override fun getHapticHistory(limit: Double): WritableArray {
    // Return an empty array for now
    return Arguments.createArray()
  }

  override fun presentHapticHistory(): Unit {
    // TODO: Present the haptic history UI for Android
    android.util.Log.i("RnBridge", "presentHapticHistory called")
  }

  override fun getCurrentNetworkStatus(promise: Promise) {
    // TODO: Implement real network status for Android
    // For now, return a mock status
    val result = Arguments.createMap().apply {
      putBoolean("isConnected", true)
      putString("type", "wifi")
    }
    promise.resolve(result)
  }

  companion object {
    const val NAME = NativeRnBridgeSpec.NAME
  }
}
