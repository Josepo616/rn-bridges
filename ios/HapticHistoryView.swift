//
//  HapticHistoryView.swift
//  RnBridge
//
//  Created by JoseAlvarez on 6/15/26.
//

import SwiftUI

struct HapticHistoryView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var records: [HapticRecord] = []
  @State private var total: Int = 0
  @State private var byType: [String: Int] = [:]

  private let typeColors: [String: Color] = [
    "light": .blue, "medium": .indigo, "heavy": .purple,
    "success": .green, "warning": .orange, "error": .red,
  ]

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        statsHeader
        Divider()
        if records.isEmpty { emptyState } else { list }
      }
      .navigationTitle("Haptic History")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close") { dismiss() }
        }
        ToolbarItem(placement: .destructiveAction) {
          Button {
            clearAll()
          } label: {
            Image(systemName: "trash")
          }
          .disabled(records.isEmpty)
        }
      }
    }
    .onAppear(perform: reload)
  }

  private var statsHeader: some View {
    VStack(spacing: 12) {
      Text("\(total)")
        .font(.system(size: 48, weight: .bold, design: .rounded))
      Text("Total Haptics")
        .font(.subheadline)
        .foregroundColor(.secondary)

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
          ForEach(byType.sorted { $0.value > $1.value }, id: \.key) {
            key,
            count in
            VStack(spacing: 4) {
              Text("\(count)").font(.headline)
              Text(key).font(.caption2).foregroundColor(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background((typeColors[key] ?? .gray).opacity(0.15))
            .clipShape(Capsule())
          }
        }
        .padding(.horizontal)
      }
    }
    .padding(.vertical, 20)
    .frame(maxWidth: .infinity)
  }

  private var list: some View {
    List(records) { record in
      HStack {
        Circle()
          .fill(typeColors[record.type] ?? .gray)
          .frame(width: 10, height: 10)
        Text(record.type.capitalized).font(.body)
        Spacer()
        Text(record.timestamp, style: .time)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
    }
    .listStyle(.plain)
  }

  private var emptyState: some View {
    VStack(spacing: 12) {
      Spacer()
      Image(systemName: "waveform.path")
        .font(.system(size: 48))
        .foregroundColor(.secondary)
      Text("No haptics recorded yet").foregroundColor(.secondary)
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func reload() {
    records = HapticStore.shared.allRecords()
    let stats = HapticStore.shared.getStats()
    total = stats["total"] as? Int ?? 0
    byType = stats["byType"] as? [String: Int] ?? [:]
  }

  private func clearAll() {
    _ = HapticStore.shared.clearHistory()
    reload()
  }
}
