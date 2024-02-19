import Foundation
import AppCore

class CacheMock: CacheProtocol {
    
    private var cache: [String: Data] = [:]
    
    var setMethodCalled = false
    var setMethodCallCount = 0
    var setMethodCalledWithKey: String?
    func set(_ key: String, _ data: Data) {
        cache[key] = data
        setMethodCalled = true
        setMethodCallCount += 1
        setMethodCalledWithKey = key
    }
    
    var getMethodCalled = false
    var getMethodCallCount = 0
    var getMethodCalledWithKey: String?
    func get(_ key: String) -> Data? {
        getMethodCalled = true
        getMethodCallCount += 1
        getMethodCalledWithKey = key
        return cache[key]
    }
    
    var removeMethodCalled = false
    var removeMethodCallCount = 0
    var removeMethodCalledWithKey: String?
    func remove(_ key: String) {
        cache.removeValue(forKey: key)
        removeMethodCalled = true
        removeMethodCallCount += 1
        removeMethodCalledWithKey = key
    }
    
    var resetMethodCalled = false
    var resetMethodCallCount = 0
    func reset() {
        cache = [:]
        resetMethodCalled = true
        resetMethodCallCount += 1
    }
}
