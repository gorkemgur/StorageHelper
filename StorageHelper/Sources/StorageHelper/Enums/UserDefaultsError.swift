//
//  UserDefaultsError.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

/// Represents errors specific to UserDefaults operations.
public enum UserDefaultsError: Error {
    /// Thrown when saving to UserDefaults fails.
    case saveFailed
    /// Thrown when fetching from UserDefaults fails.
    case fetchFailed
    /// Thrown when deleting from UserDefaults fails.
    case deleteFailed
    /// Thrown when data is not found in UserDefaults.
    case dataNotFound
}

extension UserDefaultsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save item to UserDefaults."
        case .fetchFailed:
            return "Failed to fetch item from UserDefaults."
        case .deleteFailed:
            return "Failed to delete item from UserDefaults."
        case .dataNotFound:
            return "Data not found in UserDefaults."
        }
    }
}
