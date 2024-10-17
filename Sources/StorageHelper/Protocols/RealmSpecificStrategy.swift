//
//  RealmSpecificStrategy.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation

public protocol RealmSpecificStrategy {
    func deleteMultipleItems(forKeys keys: [String]) throws
    func delete(where predicate: NSPredicate) throws
    func reset() throws
}
