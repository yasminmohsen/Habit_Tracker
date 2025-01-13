//
//  DatabaseManager.swift
//  HabitTracker
//
//  Created by Yasmin Mohsen on 11/01/2025.
//

import Foundation

final class DatabaseManager {
    //MARK: - Properties
    static let shared = DatabaseManager()
    private let USER_KEY = "UserKey"
    
    //MARK: - Initializer-SingleTone
    private init() {}
    
    //MARK: - Helpers
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
