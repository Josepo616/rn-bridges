package com.rnbridge

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.WritableArray
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

  companion object {
    const val NAME = NativeRnBridgeSpec.NAME
  }
}
