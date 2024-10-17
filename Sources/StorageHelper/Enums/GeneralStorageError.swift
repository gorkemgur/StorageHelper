//
//  GeneralStorageError.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

/// Represents general storage errors that can occur across different storage strategies.
public enum GeneralStorageError: Error {
    /// Thrown when data encoding fails.
    case encodingFailed
    /// Thrown when data decoding fails.
    case decodingFailed
    /// Thrown when an invalid key is used.
    case invalidKey
    /// Thrown when there's insufficient storage space.
    case insufficientStorage
    /// Thrown when the operation is not permitted.
    case permissionDenied
    /// Thrown for unexpected errors not covered by other cases.
    case unexpectedError(Error)
}

extension GeneralStorageError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode data."
        case .decodingFailed:
            return "Failed to decode data."
        case .invalidKey:
            return "The provided key is invalid."
        case .insufficientStorage:
            return "Insufficient storage space available."
        case .permissionDenied:
            return "Permission denied for the requested operation."
        case .unexpectedError(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}

