//
//  DatabaseManager.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

final class DatabaseManager {
    static let shared = DatabaseManager()
    public let USER_KEY = "UserKey"
    private init() {}
    
    func saveUserID(userID: String?) {
        UserDefaults.standard.set(userID, forKey: USER_KEY)
    }
    
    func getCurrentUserID() -> String? {
        guard let userID = UserDefaults.standard.string(forKey: USER_KEY) else {
            return nil
        }
        return userID
    }
    
    func deleteUser() {
        UserDefaults.standard.set(nil, forKey: USER_KEY)
    }
}
