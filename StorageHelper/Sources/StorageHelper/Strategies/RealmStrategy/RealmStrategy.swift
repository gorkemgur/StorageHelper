//
//  RealmStrategy.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation
import RealmSwift

/// A typealias that combines the `StorageStrategyProtocol` and `RealmSpecificStrategy` protocols.
/// This allows `RealmStrategy` to implement both general storage operations and Realm-specific functionalities.
public typealias RealmStorageStrategy = StorageStrategyProtocol & RealmSpecificStrategy


/// A storage strategy that uses Realm to persist and retrieve data.
/// This class implements both `StorageStrategyProtocol` and `RealmSpecificStrategy` protocols,
/// providing methods to save, fetch, delete, and perform other Realm-specific operations.
public final class RealmStrategy: RealmStorageStrategy {
    private let realm: Realm
    private let realmConfiguration: Realm.Configuration
    
    /// Initializes a new instance of RealmStrategy with a specific Realm configuration.
    ///
    /// - Parameter realmConfiguration: The configuration to use for the Realm instance.
    /// - Throws: `RealmError.initializationFailed` if the Realm instance cannot be created.
    public init(realmConfiguration: Realm.Configuration) throws {
        self.realmConfiguration = realmConfiguration
        do {
            self.realm = try Realm(configuration: realmConfiguration)
        } catch {
            StorageLogger.shared.log("Realm initialization failed: \(error)", level: .error)
            throw RealmError.initializationFailed
        }
    }
    
    /// Saves a `Codable` item to Realm.
    ///
    /// - Parameters:
    ///   - item: The item to save. Must conform to `Codable`.
    ///   - key: The key under which to save the item in Realm.
    /// - Throws: `RealmError.transactionFailed` if the save operation fails.
    public func save<T: Codable>(_ item: T, forKey key: String) throws {
        do {
            let data = try JSONEncoder().encode(item)
            let object = RealmStorageObject(key: key, data: data)
            
            try realm.write {
                realm.add(object, update: .modified)
            }
            StorageLogger.shared.log("Successfully saved item for key: \(key)", level: .info)
        } catch {
            StorageLogger.shared.log("Failed to save item for key: \(key). Error: \(error)", level: .error)
            throw RealmError.transactionFailed
        }
    }
    
    /// Fetches a `Codable` item from Realm.
    ///
    /// - Parameter key: The key of the item to fetch from Realm.
    /// - Returns: The fetched and decoded item.
    /// - Throws:
    ///   - `RealmError.objectNotFound` if no object is found for the given key.
    ///   - `GeneralStorageError.decodingFailed` if decoding fails.
    public func fetch<T: Codable>(forKey key: String) throws -> T {
        guard let object = realm.object(ofType: RealmStorageObject.self, forPrimaryKey: key) else {
            StorageLogger.shared.log("No object found for key: \(key)", level: .warning)
            throw RealmError.objectNotFound
        }
        
        guard let data = object.data else {
            StorageLogger.shared.log("No data found for key: \(key)", level: .error)
            throw RealmError.objectNotFound
        }
        
        do {
            let decodedItem = try JSONDecoder().decode(T.self, from: data)
            StorageLogger.shared.log("Successfully fetched item for key: \(key)", level: .info)
            return decodedItem
        } catch {
            StorageLogger.shared.log("Failed to decode item for key: \(key). Error: \(error)", level: .error)
            throw GeneralStorageError.decodingFailed
        }
    }
    
    /// Deletes an item from Realm.
    ///
    /// - Parameter key: The key of the item to delete from Realm.
    /// - Throws: `RealmError.transactionFailed` if the delete operation fails.
    public func delete(forKey key: String) throws {
        guard let object = realm.object(ofType: RealmStorageObject.self, forPrimaryKey: key) else {
            StorageLogger.shared.log("No object found to delete for key: \(key)", level: .warning)
            return
        }
        
        do {
            try realm.write {
                realm.delete(object)
            }
            StorageLogger.shared.log("Successfully deleted item for key: \(key)", level: .info)
        } catch {
            StorageLogger.shared.log("Failed to delete item for key: \(key). Error: \(error)", level: .error)
            throw RealmError.transactionFailed
        }
    }
    
    /// Resets the entire Realm database.
    ///
    /// - Throws: `RealmError.transactionFailed` if the reset operation fails.
    public func reset() throws {
        do {
            try realm.write {
                realm.deleteAll()
            }
            StorageLogger.shared.log("Successfully reset Realm database", level: .info)
        } catch {
            StorageLogger.shared.log("Failed to reset Realm database. Error: \(error)", level: .error)
            throw RealmError.transactionFailed
        }
    }
    
    /// Deletes items from Realm that match the given predicate.
    ///
    /// - Parameter predicate: An NSPredicate that defines the condition for deletion.
    /// - Throws: `RealmError.transactionFailed` if the delete operation fails.
    public func delete(where predicate: NSPredicate) throws {
        let objects = realm.objects(RealmStorageObject.self).filter(predicate)
        do {
            try realm.write {
                realm.delete(objects)
            }
            StorageLogger.shared.log("Successfully deleted items matching predicate", level: .info)
        } catch {
            StorageLogger.shared.log("Failed to delete items matching predicate. Error: \(error)", level: .error)
            throw RealmError.transactionFailed
        }
    }
    
    /// Deletes multiple items from Realm based on their keys.
    ///
    /// - Parameter keys: An array of keys identifying the items to be deleted.
    /// - Throws: `RealmError.transactionFailed` if the delete operation fails.
    public func deleteMultipleItems(forKeys keys: [String]) throws {
        let objects = realm.objects(RealmStorageObject.self).filter("key IN %@", keys)
        do {
            try realm.write {
                realm.delete(objects)
            }
            StorageLogger.shared.log("Successfully deleted multiple items", level: .info)
        } catch {
            StorageLogger.shared.log("Failed to delete multiple items. Error: \(error)", level: .error)
            throw RealmError.transactionFailed
        }
    }
}
