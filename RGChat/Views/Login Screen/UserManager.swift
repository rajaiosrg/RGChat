//
//  UserManager.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation

class UserManager {

    func userNumber() -> String {
        return UserDefaults.standard.value(forKey: "phoneNumber") as! String
    }
    
    func userDisplayName() -> String {
        return UserDefaults.standard.value(forKey: "displayname") as! String
    }
    
    func markUserAsLoggedIn() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func logOutUser() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.setValue("", forKey: "phoneNumber")
        UserDefaults.standard.setValue("", forKey: "displayname")
        UserDefaults.standard.synchronize()
    }
}
