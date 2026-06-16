//
//  HapticStore.swift
//  RnBridge
//
//  Created by JoseAlvarez on 6/14/26.
//

import CoreData
import Foundation
import os

struct HapticRecord: Identifiable {
  let id = UUID()
  let type: String
  let timestamp: Date
}

@objc public protocol RnBridgeNetworkDelegate: AnyObject {
  func sendNetworkChanged(_ status: [String: Any])
}

@objc public class HapticStore: NSObject {

  @objc public static let shared = HapticStore()

  // Modern Apple logger. subsystem = module identifier, category = area
  private let logger = Logger(
    subsystem: "com.josealvarez.RnBridge",
    category: "HapticStore"
  )

  // MARK: - Core Data Stack (programatic, no xcdatamodeld necessary)
  private lazy var managedObjectModel: NSManagedObjectModel = {
    let model = NSManagedObjectModel()

    // Define HapticEvent entity in code
    let entity = NSEntityDescription()
    entity.name = "HapticEvent"
    entity.managedObjectClassName = NSStringFromClass(HapticEvent.self)

    // Attribute: Type = String
    let typeAttr = NSAttributeDescription()
    typeAttr.name = "type"
    typeAttr.attributeType = .stringAttributeType
    typeAttr.isOptional = false

    // Attribute Timestamp = Date
    let timestampAttr = NSAttributeDescription()
    timestampAttr.name = "timestamp"
    timestampAttr.attributeType = .dateAttributeType
    timestampAttr.isOptional = false

    entity.properties = [typeAttr, timestampAttr]
    model.entities = [entity]

    return model
  }()

  private lazy var persistenContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(
      name: "HapticStore",
      managedObjectModel: managedObjectModel
    )

    container.loadPersistentStores { [weak self] description, error in
      if let error = error {
        self?.logger.error(
          "Failed to load Core Data store: \(error.localizedDescription)"
        )
      } else {
        self?.logger.info(
          "Core Data store loaded at: \(description.url?.absoluteString ?? "unknown")"
        )
      }
    }

    return container
  }()

  private var context: NSManagedObjectContext {
    persistenContainer.viewContext
  }

  @objc public override init() {
    super.init()
    // force the load while starting
    _ = persistenContainer
  }

  // MARK: Public API

  @objc public func record(type: String) {
    let event = HapticEvent(context: context)
    event.type = type
    event.timestamp = Date()

    do {
      try context.save()
      logger.debug("Recorded haptic event: \(type, privacy: .public)")
    } catch {
      logger.debug("Failed to save haptic event: \(error.localizedDescription)")
    }
  }

  @objc public func count() -> Int {
    let request = NSFetchRequest<HapticEvent>(entityName: "HapticEvent")

    do {
      return try context.count(for: request)
    } catch {
      logger.error("Failed to count events: \(error.localizedDescription)")
      return 0
    }
  }

  @objc public func getHistory(limit: Int) -> [[String: Any]] {
    let request = NSFetchRequest<HapticEvent>(entityName: "HapticEvent")

    // Most recent first
    request.sortDescriptors = [
      NSSortDescriptor(key: "timestamp", ascending: false)
    ]

    // 0 = no limits, any other value applies
    if limit > 0 {
      request.fetchLimit = limit
    }

    do {
      let events = try context.fetch(request)
      logger.debug("Fetched \(events.count) haptic events")

      return events.map { event in
        return [
          "type": event.type,
          // timestamp with epoch in milliseconds (what js understands easy)
          "timestamp": event.timestamp.timeIntervalSince1970 * 1000,
        ]
      }
    } catch {
      logger.error("Fail to fetch history: \(error.localizedDescription)")
      return []
    }
  }
  
  func allRecords() -> [HapticRecord] {
    let request = NSFetchRequest<HapticEvent>(entityName: "HapticEvent")
    request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    do {
      let events = try context.fetch(request)
      return events.map { HapticRecord(type: $0.type, timestamp: $0.timestamp) }
    } catch {
      logger.error("Failed to fetch records: \(error.localizedDescription)")
      return []
    }
  }
  
  @objc public func getStats() -> [String: Any] {
    let request = NSFetchRequest<HapticEvent>(entityName: "HapticEvent")
    do {
      let events = try context.fetch(request)
      var byType: [String: Int] = [:]
      for event in events {
        byType[event.type, default: 0] += 1
      }
      logger.debug("Computed stats: \(events.count) total")
      return [
        "total": events.count,
        "byType": byType
      ]
    } catch {
      logger.error("Failed to compute stats: \(error.localizedDescription)")
      return ["total": 0, "byType": [:]]
    }
  }

  @objc public func clearHistory() -> Int {
    let request = NSFetchRequest<HapticEvent>(entityName: "HapticEvent")
    do {
      let events = try context.fetch(request)
      let count = events.count
      for event in events {
        context.delete(event)
      }
      try context.save()
      logger.info("Cleared \(count) haptic events")
      return count
    } catch {
      logger.error("Failed to clear history: \(error.localizedDescription)")
      return 0
    }
  }
}

// MARK: Managed Object subclass

@objc(HapticEvent)
class HapticEvent: NSManagedObject {
  @NSManaged var type: String
  @NSManaged var timestamp: Date
}

