package com.rnbridge

import com.facebook.react.bridge.ReactApplicationContext

class RnBridgeModule(reactContext: ReactApplicationContext) :
  NativeRnBridgeSpec(reactContext) {

  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  companion object {
    const val NAME = NativeRnBridgeSpec.NAME
  }
}
