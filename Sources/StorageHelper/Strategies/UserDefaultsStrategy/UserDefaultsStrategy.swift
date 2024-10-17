//
//  UserDefaultsStrategy.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

import Foundation

/// A storage strategy that uses UserDefaults to persist and retrieve data.
/// This strategy conforms to the `StorageStrategyProtocol` protocol and provides
/// methods to save, fetch, and delete `Codable` objects using UserDefaults.
public class UserDefaultsStrategy: StorageStrategyProtocol {
    
    /// Saves a `Codable` item to UserDefaults.
    ///
    /// - Parameters:
    ///   - item: The item to save. Must conform to `Codable`.
    ///   - key: The key under which to save the item in UserDefaults.
    /// - Throws:
    ///   - `GeneralStorageError.encodingFailed` if encoding fails.
    ///   - `UserDefaultsError.saveFailed` if the save operation fails.
    public func save<T: Codable>(_ item: T, forKey key: String) throws {
        do {
            let data = try JSONEncoder().encode(item)
            UserDefaults.standard.set(data, forKey: key)
            StorageLogger.shared.log("Successfully saved item for key: \(key)", level: .info)
        } catch EncodingError.invalidValue(_, _) {
            StorageLogger.shared.log("Failed to encode item for key: \(key)", level: .error)
            throw GeneralStorageError.encodingFailed
        } catch {
            StorageLogger.shared.log("Failed to save item for key: \(key). Error: \(error)", level: .error)
            throw UserDefaultsError.saveFailed
        }
    }
    
    /// Fetches a `Codable` item from UserDefaults.
    ///
    /// - Parameter key: The key of the item to fetch from UserDefaults.
    /// - Returns: The fetched and decoded item.
    /// - Throws:
    ///   - `UserDefaultsError.dataNotFound` if no data is found for the key.
    ///   - `GeneralStorageError.decodingFailed` if decoding fails.
    public func fetch<T: Codable>(forKey key: String) throws -> T {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            StorageLogger.shared.log("No data found for key: \(key)", level: .warning)
            throw UserDefaultsError.dataNotFound
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
    
    /// Deletes an item from UserDefaults.
    ///
    /// - Parameter key: The key of the item to delete from UserDefaults.
    public func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        StorageLogger.shared.log("Deleted item for key: \(key)", level: .info)
    }
}
