//
//  StorageType.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation
import RealmSwift

/// Represents the available storage types for the StorageManager.
/// This enum is extensible, allowing users to add their own storage types.
public enum StorageType {
    /// UserDefaults storage type.
    case userDefaults
    
    /// Realm storage type with associated Realm configuration.
    case realm(Realm.Configuration)
    
    /// A case for custom storage types.
    /// Associated value should be a type conforming to `StorageStrategyProtocol`.
    case custom(StorageStrategyProtocol)
}
