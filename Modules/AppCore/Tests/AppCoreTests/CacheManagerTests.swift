import XCTest
@testable import AppCore

class CacheManagerTests: XCTestCase {
    var cacheManager: CacheManager!
    var cacheMock: CacheMock!
    
    override func setUp() {
        super.setUp()
        cacheMock = CacheMock()
        cacheManager = CacheManager(cache: cacheMock)
    }
    
    override func tearDown() {
        cacheManager = nil
        cacheMock = nil
        super.tearDown()
    }
    
    func testLoadObject_whenInCache_returnObject() async throws {
        // Given
        let cacheKey = "TestKey"
        let object = "TestObject"
        let encoder = cacheManager.encoder
        let cacheData = try encoder.encode(object)
        cacheMock.set(cacheKey, cacheData)
        
        // When
        let loadedObject: String? = try cacheManager.loadObject(cacheKey)
        
        // Then
        XCTAssertEqual(loadedObject, object)
        XCTAssertTrue(cacheMock.getMethodCalled)
        XCTAssertEqual(cacheMock.getMethodCallCount, 1)
        XCTAssertEqual(cacheMock.getMethodCalledWithKey, cacheKey)
    }
    
    func testLoadObject_whenNotInCache_returnNil() async throws {
        // Given
        let cacheKey = "TestKey"
        
        // When
        let loadedObject: String? = try cacheManager.loadObject(cacheKey)
        
        // Then
        XCTAssertNil(loadedObject)
        XCTAssertTrue(cacheMock.getMethodCalled)
        XCTAssertEqual(cacheMock.getMethodCallCount, 1)
        XCTAssertEqual(cacheMock.getMethodCalledWithKey, cacheKey)
    }
    
    func testStoreObject_whenSuccessfullyStoredInCache_returnObject()  async throws {
        // Given
        let cacheKey = "TestKey"
        let object = "TestObject"
        
        // When
        let storedObject = await cacheManager.storeObject(object, key: cacheKey)
        
        // Then
        XCTAssertEqual(storedObject, object)
        XCTAssertTrue(cacheMock.setMethodCalled)
        XCTAssertEqual(cacheMock.setMethodCallCount, 1)
        XCTAssertEqual(cacheMock.setMethodCalledWithKey, cacheKey)
    }
}
