//
//  AppDelegate.swift
//  CRDSettingsTestApp
//
//  Created by Christopher Disdero on 3/9/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit
import CRDSettings

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CRDSettingsAppProtocol {
    
    // MARK: - CRDSettingsAppProtocol

    /// Reference to the *CRDSettings* framework.
    var settings: CRDSettings?

    // MARK: - Internal members
    
    var window: UIWindow?
    
    // MARK: - Private members
    
    /// The list of notification observers.
    private var observers: [NSObjectProtocol] = []

    // MARK: - App lifecycle methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create a new CRDSettings instance for the app.
        settings = CRDSettings()
        
        // Customize and initialize some settings.
        if let settings = settings {
            
            // Set the increment for the slider setting entry.
            if let sliderSetting = settings.findSetting(identifier: "myslider2_preference") as? CRDSettingsSlider {
                
                sliderSetting.incrementValue = 0.2
            }
            
            // Put a button in the "MyGroup" group after the "myswitch1_preference" switch.
            if let groups = settings.groups, groups.count > 0 {
                
                if let supportGroup = settings.findGroup(title: "MyGroup1") {
                    
                    // Create a new button called 'My Button' and set an action for it.
                    let entry = CRDSettingsActionButton(identifier: "mybutton1_preference", title: "My Button", action: { (settingEntry) in
                        
                        // Show an alert that the button was pressed.
                        let alertController = UIAlertController(title: "My Button", message:
                            "My Button was pressed.", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.window?.rootViewController?.presentedViewController?.present(alertController, animated: true, completion: nil)
                    })
                    
                    // Set this button to depend on the switch setting so that when it is off, this button is disabled.
                    entry.dependsOn = "myswitch1_preference"
                    entry.disableOnDepends = true
                    
                    // Add the button to the group.
                    supportGroup.add(entry, afterIdentifier: "myswitch1_preference")
                }
            }
        }

        // Setup an observer for the *CRDSettings.NotificationSettingsChanged* notification so that whenever setting values change, we are notified and handed the current value.
        observers.append(NotificationCenter.default.addObserver(forName: CRDSettings.NotificationSettingsChanged, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Get the *CRDSettingsEntry* out of the notification by looking for the value with the key *CRDSettings.NotificationSettingsChangedSettingKey*
            guard let userInfo = notification.userInfo, let settingsEntry = userInfo[CRDSettings.NotificationSettingsChangedSettingKey] as? CRDSettingsEntry else { return }
            
            // Print out the changed settings entry to the console.
            print("Changed: \(settingsEntry)")
        })

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        // Remove the observers for this view.
        for observer in observers {
            
            NotificationCenter.default.removeObserver(observer)
        }
        observers.removeAll()
    }
}

