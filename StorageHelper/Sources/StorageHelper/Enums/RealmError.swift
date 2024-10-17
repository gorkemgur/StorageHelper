//
//  RealmError.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

/// Represents errors specific to Realm operations.
public enum RealmError: Error {
    /// Thrown when Realm initialization fails.
    case initializationFailed
    /// Thrown when a Realm transaction fails.
    case transactionFailed
    /// Thrown when a Realm migration is required.
    case migrationRequired
    /// Thrown when Realm schema validation fails.
    case schemaValidationFailed
    /// Thrown when a Realm object is not found.
    case objectNotFound
    /// Thrown when a Realm query is invalid.
    case invalidQuery
}

extension RealmError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .initializationFailed:
            return "Failed to initialize Realm."
        case .transactionFailed:
            return "Realm transaction failed."
        case .migrationRequired:
            return "Realm migration is required."
        case .schemaValidationFailed:
            return "Realm schema validation failed."
        case .objectNotFound:
            return "Realm object not found."
        case .invalidQuery:
            return "Invalid Realm query."
        }
    }
}
