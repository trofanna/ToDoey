//
//  AppDelegate.swift
//  Todoey
//
//  Created by Angela Yu on 16/11/2017.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // print(Realm.Configuration.defaultConfiguration.fileURL)        
        // changed: _ = try Realm() as warning about no errors can be thrown when ! is present
        
        do {
        _ = try Realm()
        } catch {
            print("Error creating Realm \(error)")
        }
        return true
 
    }

}

