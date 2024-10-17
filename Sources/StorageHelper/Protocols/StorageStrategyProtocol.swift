//
//  StorageStrategyProtocol.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

/// Protocol defining the basic operations for any storage strategy.
public protocol StorageStrategyProtocol {
    /// Saves a `Codable` item to storage.
    /// - Parameters:
    ///   - item: The item to save.
    ///   - key: The key under which to save the item.
    /// - Throws: An error if the save operation fails.
    func save<T: Codable>(_ item: T, forKey key: String) throws
    
    /// Fetches a `Codable` item from storage.
    /// - Parameter key: The key of the item to fetch.
    /// - Returns: The fetched item.
    /// - Throws: An error if the fetch operation fails.
    func fetch<T: Codable>(forKey key: String) throws -> T
    
    /// Deletes an item from storage.
    /// - Parameter key: The key of the item to delete.
    /// - Throws: An error if the delete operation fails.
    func delete(forKey key: String) throws
}
