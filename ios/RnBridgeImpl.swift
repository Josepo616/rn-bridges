//
//  RnBridgeImpl.swift
//  RnBridge
//
//  Created by JoseAlvarez on 5/21/26.
//

import Foundation
import UIKit
import SwiftUI

@objc public class RnBridgeImpl: NSObject {

  @objc public static let shared = RnBridgeImpl()

  @objc public override init() {
    super.init()
  }

  @objc public func greet(_ name: String) -> String {
    return "Hello, \(name)!"
  }

  @objc public func triggerHaptic(
    type: String,
    resolve: @escaping (Any?) -> Void,
    reject: @escaping (String, String, Error?) -> Void
  ) {

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
      // Resolve after all is finished
      resolve(nil)
    }
  }

  @objc public func getHapticHistory(limit: Int) -> [[String: Any]] {
    return HapticStore.shared.getHistory(limit: limit)
  }
  
  @objc public func presentHapticHistory() {
    DispatchQueue.main.async {
      guard let topVC = Self.topViewController() else {
        print("[RnBridge] No view controller available to present from")
        return
      }
      let host = UIHostingController(rootView: HapticHistoryView())
      if let sheet = host.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.prefersGrabberVisible = true
      }
      topVC.present(host, animated: true)
    }
  }

  private static func topViewController() -> UIViewController? {
    guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
      return nil
    }
    let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first
    guard var top = window?.rootViewController else { return nil }
    while let presented = top.presentedViewController {
      top = presented
    }
    return top
  }
}
