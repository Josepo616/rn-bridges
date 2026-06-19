//
//  NetworkDetailsView.swift
//  RnBridge
//
//  Created by JoseAlvarez on 6/15/26.
//

import SwiftUI
import Network

class NetworkDetailsViewModel: ObservableObject {
  @Published var isConnected: Bool = false
  @Published var type: String = "unknown"
  @Published var isExpensive = false
  @Published var isConstrained = false
  @Published var supportsIPv4 = false
  @Published var supportsIPv6 = false
  @Published var supportsDNS = false
  
  func update(from dict: [String: Any]) {
    isConnected = dict["isConnected"] as? Bool ?? false
    type = dict["type"] as? String ?? "unknown"
    isExpensive = dict["isExpensive"] as? Bool ?? false
    isConstrained = dict["isConstrained"] as? Bool ?? false
    supportsIPv4 = dict["supportsIPv4"] as? Bool ?? false
    supportsIPv6 = dict["supportsIPv6"] as? Bool ?? false
    supportsDNS = dict["supportsDNS"] as? Bool ?? false
  }
}

struct NetworkDetailsView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var model: NetworkDetailsViewModel
  
  private var statusColor: Color {
    model.isConnected ? .green : .red
  }
  
  private var typeIcon: String {
    switch model.type {
    case "wifi": return "wifi"
    case "cellular": return "antenna.radiowaves.left.and.right"
    case "ethernet": return "cable.connector"
    case "none": return "wifi.slash"
    default: return "network"
    }
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 24) {
          VStack(spacing: 12) {
            Image(systemName: typeIcon)
              .font(.system(size: 56))
              .foregroundColor(statusColor)
            Text(model.isConnected ? "Connected" : "Offline")
              .font(.title2.bold())
            Text(model.type.capitalized)
              .font(.headline)
              .foregroundColor(.secondary)
          }
          .padding(.top, 20)
          
          VStack(spacing: 0) {
            detailRow("Connection", value: model.type.capitalized, icon: typeIcon)
            Divider().padding(.leading, 52)
            detailRow("Expensive", value: model.isExpensive ? "Yes" : "No",
                      icon: "dollarsign.circle",
                      tint: model.isExpensive ? .orange : .secondary)
            Divider().padding(.leading, 52)
            detailRow("Low Data Mode", value: model.isConstrained ? "On" : "Off",
                      icon: "tortoise",
                      tint: model.isConstrained ? .orange : .secondary)
            Divider().padding(.leading, 52)
            detailRow("IPv4", value: model.supportsIPv4 ? "Supported" : "—", icon: "4.circle")
            Divider().padding(.leading, 52)
            detailRow("IPv6", value: model.supportsIPv6 ? "Supported" : "—", icon: "6.circle")
            Divider().padding(.leading, 52)
            detailRow("DNS", value: model.supportsDNS ? "Available" : "—", icon: "magnifyingglass")
          }
          .background(Color(.secondarySystemGroupedBackground))
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .padding(.horizontal)
          
          Text("Updates live as your connection changes")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.bottom, 30)
      }
      .background(Color(.systemGroupedBackground))
      .navigationTitle("Network")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close") { dismiss() }
        }
      }
    }
  }
  
  private func detailRow(_ label: String, value: String, icon: String, tint: Color = .secondary) -> some View {
    HStack(spacing: 14) {
      Image(systemName: icon)
        .font(.system(size: 18))
        .foregroundColor(tint)
        .frame(width: 24)
      Text(label)
        .font(.body)
      Spacer()
      Text(value)
        .font(.body.weight(.medium))
        .foregroundColor(.primary)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
  }
}
