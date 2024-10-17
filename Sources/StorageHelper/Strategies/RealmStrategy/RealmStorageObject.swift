//
//  RealmStorageObject.swift
//
//
//  Created by Görkem Gür on 17.10.2024.
//

import Foundation
import RealmSwift

internal final class RealmStorageObject: Object {
    @Persisted(primaryKey: true) var key: String
    @Persisted var data: Data?
    
    convenience init(key: String, data: Data?) {
        self.init()
        self.key = key
        self.data = data
    }
}
