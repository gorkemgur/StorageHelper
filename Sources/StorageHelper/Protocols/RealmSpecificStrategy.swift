//
//  RealmSpecificStrategy.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

/// The `RealmSpecificStrategy` protocol defines specialized operations for the Realm database.
/// This protocol is used to perform Realm-specific operations such as deleting multiple items,
/// deleting based on a specific condition, and resetting the entire database.
public protocol RealmSpecificStrategy {
    /// Deletes multiple items based on their keys.
    ///
    /// - Parameter keys: An array containing the keys of the items to be deleted.
    /// - Throws: An error if the deletion operation fails.
    func deleteMultipleItems(forKeys keys: [String]) throws

    /// Deletes all items that satisfy the given predicate.
    ///
    /// - Parameter predicate: An NSPredicate object that specifies which items to delete.
    /// - Throws: An error if the deletion operation fails.
    func delete(where predicate: NSPredicate) throws

    /// Resets all data in the database.
    ///
    /// - Throws: An error if the reset operation fails.
    func reset() throws
}
