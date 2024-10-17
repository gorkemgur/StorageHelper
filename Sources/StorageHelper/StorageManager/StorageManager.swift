//
//  StorageManager.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation


/// A flexible manager for handling different storage strategies in Swift applications.
/// It provides a unified interface for saving, fetching, and deleting `Codable` objects
/// using various storage backends such as UserDefaults and Realm.
public class StorageManager {
    private let storageType: StorageType
    private lazy var strategy: StorageStrategyProtocol? = nil
    private var concurrentQueue = DispatchQueue(label: "com.helper.storageConcurrentQueue", attributes: .concurrent)
    
    /// Initializes a new StorageManager with the specified storage type.
    ///
    /// - Parameter storageType: The type of storage to use. It can be either `.userDefaults`, `.realm(RealmConfiguration)`, or `.custom(StorageStrategyProtocol)`.
    /// - Throws: `StorageManagerError.initializationFailed` if the strategy cannot be created.
    public init(storageType: StorageType) throws {
        self.storageType = storageType
        do {
            self.strategy = try buildStrategy(with: storageType)
        } catch {
            StorageLogger.shared.log("Failed to initialize StorageManager: \(error)", level: .error)
            throw StorageManagerError.initializationFailed
        }
    }
    
    /// Saves a `Codable` item to the storage.
    ///
    /// - Parameters:
    ///   - item: The item to save. Must conform to `Codable`.
    ///   - key: The key under which to save the item.
    /// - Throws: Any error thrown by the underlying storage strategy.
    public func save<T: Codable>(_ item: T, forKey key: String) throws {
        try concurrentQueue.sync(flags: .barrier) {
            guard let strategy = self.strategy else { throw StorageManagerError.strategyNotInitialized }
            try strategy.save(item, forKey: key)
        }
    }
    
    /// Fetches a `Codable` item from the storage.
    ///
    /// - Parameter key: The key of the item to fetch.
    /// - Returns: The fetched item.
    /// - Throws: Any error thrown by the underlying storage strategy.
    public func fetch<T: Codable>(forKey key: String) throws -> T {
        try concurrentQueue.sync {
            guard let strategy = self.strategy else { throw StorageManagerError.strategyNotInitialized }
            return try strategy.fetch(forKey: key)
        }
    }
    
    /// Deletes an item from the storage.
    ///
    /// - Parameter key: The key of the item to delete.
    /// - Throws: Any error thrown by the underlying storage strategy.
    public func delete(forKey key: String) throws {
        try concurrentQueue.sync(flags: .barrier) {
            guard let strategy = self.strategy else { throw StorageManagerError.strategyNotInitialized }
            try strategy.delete(forKey: key)
        }
    }
    
    /// Enables or disables logging for storage operations.
    ///
    /// - Parameter enabled: Boolean value to enable or disable logging.
    public static func setLoggingEnabled(_ enabled: Bool) {
        StorageLogger.shared.setLoggingEnabled(enabled)
    }
    
    /// Returns the current strategy as a `RealmStorageStrategy` if applicable.
    ///
    /// - Returns: The current strategy as `RealmStorageStrategy` if it's a Realm strategy, otherwise `nil`.
    public func asRealmStrategy() -> RealmStorageStrategy? {
        return strategy as? RealmStorageStrategy
    }
}

// MARK: - Private Helper Methods

private extension StorageManager {
    /// Creates and returns the appropriate storage strategy based on the given `StorageType`.
    ///
    /// - Parameter storageType: The type of storage to create a strategy for.
    /// - Returns: An instance of `StorageStrategyProtocol` corresponding to the given storage type.
    /// - Throws: `StorageManagerError.unsupportedStorageType` if the storage type is not supported.
    func buildStrategy(with storageType: StorageType) throws -> StorageStrategyProtocol {
        switch storageType {
        case .userDefaults:
            return UserDefaultsStrategy()
        case .realm(let realmConfiguration):
            do {
                return try RealmStrategy(realmConfiguration: realmConfiguration)
            } catch {
                throw RealmError.initializationFailed
            }
        case .custom(let customStrategy):
            return customStrategy
        }
    }
}
