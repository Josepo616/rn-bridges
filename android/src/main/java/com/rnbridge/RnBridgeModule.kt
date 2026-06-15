package com.rnbridge

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Promise

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

  companion object {
    const val NAME = NativeRnBridgeSpec.NAME
  }
}
