//
//  RealmStorageTests.swift
//  
//
//  Created by Görkem Gür on 17.10.2024.
//

import XCTest
import RealmSwift
@testable import StorageHelper

class RealmStorageTests: XCTestCase {
    var storageManager: StorageManager!
    let testKey = "testUser"
    var testRealm: Realm!
    
    override func setUp() {
        super.setUp()
        // Given: In-memory Realm configuration for testing
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        testRealm = try! Realm(configuration: config)
        storageManager = StorageManager(storageType: .realm(config))
    }
    
    override func tearDown() {
        try? testRealm.write {
            testRealm.deleteAll()
        }
        storageManager = nil
        testRealm = nil
        super.tearDown()
    }
    
    func testSaveAndFetchRealm() {
        // Given
        let testUser = User(id: 1, name: "Jane Doe")
        
        // When
        storageManager.save(testUser, forKey: testKey)
        let fetchedUser: User? = storageManager.fetch(forKey: testKey)
        
        // Then
        XCTAssertNotNil(fetchedUser, "Fetched user should not be nil")
        XCTAssertEqual(fetchedUser?.id, testUser.id, "Fetched user ID should match the original")
        XCTAssertEqual(fetchedUser?.name, testUser.name, "Fetched user name should match the original")
    }
    
    func testDeleteRealm() {
        // Given
        let testUser = User(id: 1, name: "Jane Doe")
        storageManager.save(testUser, forKey: testKey)
        
        // When
        storageManager.delete(forKey: testKey)
        
        // Then
        let fetchedUser: User? = storageManager.fetch(forKey: testKey)
        XCTAssertNil(fetchedUser, "User should be nil after deletion")
    }
    
    func testUpdateExistingObjectInRealm() {
        // Given
        let initialUser = User(id: 1, name: "Jane Doe")
        storageManager.save(initialUser, forKey: testKey)
        
        // When
        let updatedUser = User(id: 1, name: "Jane Smith")
        storageManager.save(updatedUser, forKey: testKey)
        
        // Then
        let fetchedUser: User? = storageManager.fetch(forKey: testKey)
        XCTAssertNotNil(fetchedUser, "Updated user should not be nil")
        XCTAssertEqual(fetchedUser?.id, updatedUser.id, "Fetched user ID should match the updated user")
        XCTAssertEqual(fetchedUser?.name, updatedUser.name, "Fetched user name should match the updated user")
    }
}

fileprivate struct User: Codable, Equatable {
    let id: Int
    let name: String
}
