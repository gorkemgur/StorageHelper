import XCTest
@testable import StorageHelper

class UserDefaultsStorageTests: XCTestCase {
    var storageManager: StorageManager!
    let testKey = "testUser"
    
    override func setUp() {
        super.setUp()
        storageManager = StorageManager(storageType: .userDefaults)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: testKey)
        storageManager = nil
        super.tearDown()
    }
    
    func testSaveAndFetchUserDefaults() {
        // Given
        let testUser = User(id: 1, name: "John Doe")
        
        // When
        storageManager.save(testUser, forKey: testKey)
        let fetchedUser: User? = storageManager.fetch(forKey: testKey)
        
        // Then
        XCTAssertNotNil(fetchedUser, "Fetched user should not be nil")
        XCTAssertEqual(fetchedUser?.id, testUser.id, "Fetched user ID should match the original")
        XCTAssertEqual(fetchedUser?.name, testUser.name, "Fetched user name should match the original")
    }
    
    func testDeleteUserDefaults() {
        // Given
        let testUser = User(id: 1, name: "John Doe")
        storageManager.save(testUser, forKey: testKey)
        
        // When
        storageManager.delete(forKey: testKey)
        
        // Then
        let fetchedUser: User? = storageManager.fetch(forKey: testKey)
        XCTAssertNil(fetchedUser, "User should be nil after deletion")
    }
}

fileprivate struct User: Codable, Equatable {
    let id: Int
    let name: String
}
