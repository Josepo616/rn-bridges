//
//  HapticStore.swift
//  RnBridge
//
//  Created by JoseAlvarez on 6/14/26.
//

import CoreData
import Foundation
import os

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

}

// MARK: Managed Object subclass

@objc(HapticEvent)
public class HapticEvent: NSManagedObject {
  @NSManaged public var type: String
  @NSManaged public var timestamp: Date
}
