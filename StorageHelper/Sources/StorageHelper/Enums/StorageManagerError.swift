//
//  StorageManagerError.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

/// Represents errors specific to the StorageManager.
public enum StorageManagerError: Error {
    /// Thrown when the StorageManager fails to initialize.
    case initializationFailed
    /// Thrown when a storage strategy is not initialized.
    case strategyNotInitialized
    /// Thrown when an unsupported storage type is used.
    case unsupportedStorageType
    /// Thrown when a concurrency-related error occurs.
    case concurrencyError
}


extension StorageManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .initializationFailed:
            return "Failed to initialize the storage manager."
        case .strategyNotInitialized:
            return "Storage strategy is not initialized."
        case .unsupportedStorageType:
            return "Unsupported storage type."
        case .concurrencyError:
            return "A concurrency error occurred."
        }
    }
}
