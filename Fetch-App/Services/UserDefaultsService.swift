//
//  UserDefaultsService.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import Foundation

class UserDefaultsService {
    
    /// Saves any codable struct to UserDefaults with a key
    /// - Parameters:
    ///   - object: Codable object to save
    ///   - key: key under which to save object
    static func save<T: Codable>(object: T, withKey key: String) {
        do {
            let encodedObject = try JSONEncoder().encode(object)
            UserDefaults.standard.set(encodedObject, forKey: key)
        } catch {
            print("Failed to encode and save object under key \(key): \(error)")
        }
    }
    
    /// Loads a codable struct from UserDefaults using a key
    /// - Parameters:
    ///   - type: Type of Codable object to load
    ///   - key: Key from which to load the object
    /// - Returns: Decoded object if successful, or nil otherwise
    static func load<T: Codable>(type: T.Type, withKey key: String) -> T? {
        guard let savedData = UserDefaults.standard.data(forKey: key) else {
            print("No data found for key \(key)")
            return nil
        }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: savedData)
            //print("Loaded: type [\(T.self)] key [\(key)]")
            return decodedObject
        } catch {
            print("Failed to decode object of type \(T.self) under key \(key): \(error)")
            return nil
        }
    }
    
    /// Removes struct associated with  key from UserDefaults
    /// - Parameter key: Key whose data should be removed
    static func delete(withKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        print("Removed struct under key \(key).")
    }
}

/// save and load using simple string keys
extension UserDefaultsService {
    /// Saves a string to UserDefaults with a key
    static func save(string: String, withKey key: String) {
        UserDefaults.standard.set(string, forKey: key)
    }
    
    /// Loads a string from UserDefaults using a key
    static func loadString(withKey key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}

