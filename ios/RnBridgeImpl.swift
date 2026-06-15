//
//  RnBridgeImpl.swift
//  RnBridge
//
//  Created by JoseAlvarez on 5/21/26.
//

import Foundation
import UIKit

@objc public class RnBridgeImpl: NSObject {

  @objc public static let shared = RnBridgeImpl()

  @objc public override init() {
    super.init()
  }

  @objc public func greet(_ name: String) -> String {
    return "Hello, \(name)!"
  }

  @objc public func triggerHaptic(type: String) {

    // Register in core data before executing
    HapticStore.shared.record(type: type)

    DispatchQueue.main.async {
      switch type {
      case "light":
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()

      case "medium":
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()

      case "heavy":
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()

      case "success":
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)

      case "warning":
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)

      case "error":
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)

      default:
        print("Unknown haptic type: \(type)")
        break
      }
    }
  }
}
