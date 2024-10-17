//
//  StorageLogger.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

internal enum StorageLogLevel: String {
    case info
    case warning
    case error
    
    var infoMessageImage: String {
        switch self {
        case .info:
            "ℹ️"
        case .warning:
            "⚠️"
        case .error:
            "‼️"
        }
    }
}

public final class StorageLogger {
    public static let shared = StorageLogger()
    
    private var isEnabled: Bool = true
    
    private init() {}
    
    public func setLoggingEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    internal func log(_ message: String, level: StorageLogLevel) {
        guard isEnabled else { return }
        print("\(level.infoMessageImage) [\(level.rawValue.uppercased())] \(message)")
    }
}
