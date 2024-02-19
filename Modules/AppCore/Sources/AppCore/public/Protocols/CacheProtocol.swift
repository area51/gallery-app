import Foundation

public protocol CacheProtocol {
    
    /// Sets the data for the given key
    /// - parameter key: The key to store the data
    /// - parameter data: The data to store
    func set(_ key: String, _ data: Data)
    
    /// Returns the data for the given key
    /// - parameter key: The key to retrieve the data
    /// - returns: The data for the given key
    func get(_ key: String) -> Data?
    
    /// Removes the data for the given key
    /// - parameter key: The key to remove the data
    func remove(_ key: String)
    
    /// Resets the cache
    func reset()
}

