//
//  CRDSettings.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 11/7/17.
//
/*
 Copyright © 2018 Christopher Disdero.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

/**
 Class that represents the settings for the app as read in from the settings bundle.
 */
public class CRDSettings: NSObject {
    
    // MARK: - Public properties
    
    /// The collection of groups (if any) in the settings.
    public var groups: [CRDSettingsGroup]? {
        
        get {
            
            return self.groupsInternal
        }
    }
    
    // MARK: - Notifications
    
    /// Notification sent to subscribers when the settings have changed in some way.
    public static let NotificationSettingsChanged = Notification.Name("NotificationSettingsChanged")
    
    /// The user info key name of the value representing the *CRDSettingsEntry* that was changed in a *CRDSettings.NotificationSettingsChanged* notification message.
    public static let NotificationSettingsChangedSettingKey = "setting"

    // MARK: - Private symbols

    /// Threshold in nanoseconds to check whether a duplicate call was made to the KVO.
    private static let KVODuplicateCallThresholdNanos: UInt64 = 5000000
    
    // MARK: - Private properties
    
    /// Collection of groups.
    private var groupsInternal: [CRDSettingsGroup] = []
    
    /// Collection of setting value identifiers (keys) in the dictionary.
    private var settingsIdentifiers: [String] = []
    
    /// The list of notification observers.
    private var observers: [NSObjectProtocol] = []
    
    /// The name of the settings bundle for the app - defaults to "Settings"
    private var settingsBundleName: String = "Settings"
    
    /// Accurate timer used to measure time between KVO observer calls to avoid duplicate calls in rapid succession. (a bug supposedly fixed by Apple in iOS 11 - https://developer.apple.com/library/content/releasenotes/Foundation/RN-Foundation/index.html, but I've observed that it still happens).
    private static var timeInfo = mach_timebase_info(numer: 0, denom: 0)
    
    /// Timer related private member for tracking KVO observer calls in rapid succession.
    private var _previousTime: UInt64 = 0
    
    /// Timer related private member for tracking KVO observer calls in rapid succession.
    private var _newTime: UInt64 = 0
    
    /// Timer related private member for tracking KVO observer calls in rapid succession.
    private var _elapsed: UInt64 = 0
    
    /// Timer related private member for tracking KVO observer calls in rapid succession.
    private var _elapsedNano: UInt64 = 0
    
    /// Timer related private member for tracking KVO observer calls in rapid succession.
    private var _threshold: UInt64 = 0

    /// Timer related private member for tracking KVO observer calls in rapid succession.
    private var _previousIdentifier: String? = nil

    // MARK: - Public initializers
    
    /**
     Instantiates a new *CRDSettings* object with the given settings bundle name.
     
     - parameter settingsBundleName: The name of the settings bundle to use. Default is nil which causes the framework to use the name "Settings".
     */
    public convenience init(_ settingsBundleName: String? = nil) {
        
        self.init()
        
        // Initialize the timebase structure for measuring whether calls to the KVO observer pass a threshold time so as to avoid multiple calls in rapid succession (a bug supposedly fixed by Apple in iOS 11 - https://developer.apple.com/library/content/releasenotes/Foundation/RN-Foundation/index.html, but I've observed that it still happens).
        mach_timebase_info(&CRDSettings.timeInfo)

        // Set the name of the settings bundle.
        if let settingsBundleName = settingsBundleName {
        
            self.settingsBundleName = settingsBundleName
        }
        
        // Copy settings bundle defaults into user defaults.
        registerDefaultsFromSettingsBundle()
        
        // Update the settings dictionary.
        updateCurrentSettingsDictionary()
        
        // Monitor pertinent changes in settings.
        for settingsKey in self.settingsIdentifiers {
            
            UserDefaults.standard.addObserver(self, forKeyPath: settingsKey, options: [.new, .old], context: nil)
        }
    }
    
    // MARK: - Private initializers
    
    private override init() {
        
        super.init()
    }
    
    deinit {
        
        // Remove KVO observers for settings identifiers
        for settingsIdentifier in self.settingsIdentifiers {

            UserDefaults.standard.removeObserver(self, forKeyPath: settingsIdentifier)
        }
        
        // Remove the observers for this view.
        for observer in observers {
            
            NotificationCenter.default.removeObserver(observer)
        }
        observers.removeAll()
    }
    
    // MARK: - Public methods
    
    /**
     Returns a *CRDSettingsGroup* object representing the first group found matching the group title specified.
     
     - parameter title: The group title name as it appears in the Root.plist of the settings bundle.
     
     - returns: The *CRDSettingsGroup* object representing the group found for the given title, or nil if not found.
     */
    public func findGroup(title: String) -> CRDSettingsGroup? {
        
        guard let groups = groups else { return nil }
        let groupsFound = groups.filter({ (groupFound) -> Bool in
            
            return groupFound.title.compare(title) == .orderedSame
        })
        return groupsFound.count > 0 ? groupsFound.first : nil
    }
    
    /**
     Returns a *CRDSettingsEntry* object representing the first setting found matching the identifier specified across all groups.
     
     - parameter identifier: The identifier as it appears in the Root.plist of the settings bundle.
     
     - returns: The *CRDSettingsEntry* object representing the setting found for the given identifier, or nil if not found.
     */
    public func findSetting(identifier: String) -> CRDSettingsEntry? {
        
        guard let groups = groups else { return nil }

        for group in groups {
            
            if let settingFound = group.find(identifier) {
                
                return settingFound
            }
        }
        
        return nil
    }
    
    // MARK: - Observers
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Check whether we are within the threshold for considering this call to this observer a duplicate call, and if so bail out.
        guard let identifier = keyPath, timeThresholdForKeyPathExceeded(identifier: identifier) else { return }
        
        // Update the settings dictionary.
        updateCurrentSettingsDictionary()
        
        if let settingChanged = findSetting(identifier: identifier) {
            
            // Post a notification with the changed settings key and value.
            NotificationCenter.default.post(name: CRDSettings.NotificationSettingsChanged, object: self, userInfo: [CRDSettings.NotificationSettingsChangedSettingKey: settingChanged])
        }
    }
    
    // MARK: - Private methods
    
    /**
     Checks to see if the time this routine was previously called with the same identifier is below the specified threshold time in nanoseconds or not.
     
     - parameter identifier: The identifier to check.
     - parameter thresholdNanos: The threshold in nanoseconds to check.  Defaults to *CRDSettings.KVODuplicateCallThresholdNanos*
     
     - returns: If the identifier specified is different than the previous identifier checked (the last time this routine was called), or if the threshold has been exceeded between now and the last time this routine was called, true is returned.  Otherwise false is returned.
     
     - note: Used for determining whether calls to the KVO observer pass a threshold time so as to avoid multiple calls in rapid succession (a bug supposedly fixed by Apple in iOS 11 - https://developer.apple.com/library/content/releasenotes/Foundation/RN-Foundation/index.html, but I've observed that it still happens).
     
     */
    private func timeThresholdForKeyPathExceeded(identifier: String, thresholdNanos: UInt64 = CRDSettings.KVODuplicateCallThresholdNanos) -> Bool {
        
        _previousTime = _newTime
        _newTime = mach_absolute_time()
        
        if _previousTime > 0 {
            
            _elapsed = _newTime - _previousTime
            _elapsedNano = _elapsed * UInt64(CRDSettings.timeInfo.numer) / UInt64(CRDSettings.timeInfo.denom)
        }
        
        if _elapsedNano == 0 || _elapsedNano > thresholdNanos || (_previousIdentifier != nil && identifier.caseInsensitiveCompare(_previousIdentifier!) != .orderedSame) {
            
            _previousIdentifier = identifier
            return true
        }
        
        return false
    }
    
    /**
     Registers the current values from the app settings bundle with user defaults, if none are currently found in user defaults.
     
     - note: This is only important to do when you first start up the app as it may be the first time the app has ever been started and in that case the user defaults for the app settings will not exist.
     */
    private func registerDefaultsFromSettingsBundle() {
        
        // Get the path for the main app settings bundle.
        guard let settingsPath = Bundle.main.path(forResource: settingsBundleName, ofType: "bundle") else { return }
        
        // Get the settings from the bundle as a dictionary.
        guard let settingsRootURL = NSURL(fileURLWithPath: settingsPath).appendingPathComponent("Root.plist"), let settings = NSDictionary(contentsOf: settingsRootURL) else { return }
        
        // Get all the preference specifiers from the dictionary.
        let preferences = settings["PreferenceSpecifiers"] as! NSArray
        var defaultsToRegister = [String: AnyObject]()
        
        // Loop through each preference specifier.
        for prefSpecification in preferences {
            
            if let specifier = prefSpecification as? [String: AnyObject] {
                
                // Check that there is a key and a default value for the specifier.
                guard let key = specifier["Key"] as? String, let defaultValue = specifier["DefaultValue"] else {
                    
                    continue
                }
                
                // Store the default value to set for the key for this specifier.
                defaultsToRegister[key] = defaultValue
            }
        }
        
        // Set all the defaults in the user defaults.  This won't do anything of the key and value already exist there.
        UserDefaults.standard.register(defaults: defaultsToRegister)
    }
    
    /**
     Returns the localized string for the given string using the Root.strings file from the app settings bundle.
     
     - parameter unlocalized: The string to find a localized version of in Root.strings of the settings bundle.
     
     - returns: The localized string found, or the unlocalized string if not found.
     */
    private func localizedSettingsStringForString(unlocalized: String) -> String {
        
        // Set the return to point to the incoming unlocalized string in case something goes wrong.
        var localized = unlocalized
        
        // Get the settings bundle.
        guard let settingsPath = Bundle.main.path(forResource: settingsBundleName, ofType: "bundle"), let settingsBundle = Bundle(path: settingsPath) else { return localized }
        
        // Get the first language code from the list of preferred languages - this will presumably be the language of the device currently.
        if let languageCode = Locale.preferredLanguages.first {
            
            // Get the pathname for the Root.strings from from the settings bundle.
            if let localizedRootStringsPathname = settingsBundle.path(forResource: "Root", ofType: "strings", inDirectory: "\(languageCode).lproj") {
                
                // Lookup the string in the Root.strings file and if found set it as the returned localized string.
                if let localizedRootStringsDictionary = NSDictionary(contentsOfFile: localizedRootStringsPathname), let translation = localizedRootStringsDictionary[unlocalized] as? String, !translation.isEmpty {
                    
                    localized = translation
                }
            }
        }
        
        return localized
    }

    /**
     Initializes the internal collection of setting value keys and *CRDSettingsGroup* objects from the app settings bundle.
     */
    private func initCurrentSettingsDictionary() {
        
        // Reset the collections first.
        settingsIdentifiers = []
        groupsInternal = []
        
        // Make sure we have the dictionary of settings keys and PreferenceSpecfiers from the settings bundle.
        guard let settingsPath = Bundle.main.path(forResource: settingsBundleName, ofType: "bundle"),
            let settingsRootURL = NSURL(fileURLWithPath: settingsPath).appendingPathComponent("Root.plist"),
            let settingsDictionary = NSDictionary(contentsOf: settingsRootURL),
            let preferenceSpecifiers = settingsDictionary["PreferenceSpecifiers"] as? [NSDictionary] else { return }
        
        // The current CRDSettingsGroup in which to add CRDSettingsEntry objects as found in the dictionary.
        var group: CRDSettingsGroup? = nil
        
        // Loop through all the PreferenceSpecifiers found in the dictionary.
        for specifierElement in preferenceSpecifiers {
            
            // Make a copy of the preference specifier structure found.
            let editedSpecifierElement = NSMutableDictionary(dictionary: specifierElement)
            
            // If this specifier has a title, then try to localize it and put it back in the copy of the specifier structure.
            if let unlocalizedTitle = editedSpecifierElement["Title"] as? String, !unlocalizedTitle.isEmpty {
    
                // Try to find localized version of the title
                let localizedTitle = localizedSettingsStringForString(unlocalized:  unlocalizedTitle)
                editedSpecifierElement["Title"] = localizedTitle
            }
            
            // If this specifier has a type...
            if let specifierElementType = editedSpecifierElement["Type"] as? String {
                
                // Is this specifier a group type?
                if specifierElementType.caseInsensitiveCompare("psgroupspecifier") == .orderedSame {
                    
                    // Start a new group
                    let title = editedSpecifierElement["Title"] as! String
                    group = CRDSettingsGroup(title)
                    groupsInternal.append(group!)
                    
                    // Skip to the next item.
                    continue
                    
                // Is this specifier a multi-value type?
                } else if specifierElementType.caseInsensitiveCompare("psmultivaluespecifier") == .orderedSame {
                    
                    // Get all the titles of the multi-value specifier.
                    if let specifierElementTitles = editedSpecifierElement["Titles"] as? [String] {
                        
                        let totalTitles = specifierElementTitles.count
                        if totalTitles > 0 {
                            
                            // Make a copy of the titles and then try to localize each title.
                            let editedTitles = NSMutableArray(array: specifierElementTitles, copyItems: true)
                            for i in 0..<totalTitles {
                                
                                if let unlocalizedTitle = editedTitles[i] as? String {
                                    
                                    // Try to find localized version of the title
                                    editedTitles[i] = localizedSettingsStringForString(unlocalized:  unlocalizedTitle)
                                }
                            }
                            
                            // Put back into the copy of the preference specifier the localized titles.
                            editedSpecifierElement["Titles"] = editedTitles
                        }
                    }
                }
                
                // If this specifier has a key then add it into our collection of keys.
                if let key = specifierElement["Key"] as? String {
                
                    settingsIdentifiers.append(key)
                }
            }
            
            // If there's no group, create a default group.
            if group == nil {
                
                group = CRDSettingsGroup("Default Group")
                groupsInternal.append(group!)
            }
            
            // Add the entry based on the copy of the preference specifier to the current group
            if let entry = CRDSettingsEntry.createFrom(dictionary: editedSpecifierElement) {
            
                group!.add(entry)
            }
        }
    }

    /**
     Updates the internal collection of *CRDSettingsEntry* objects with the current value of each setting from user defaults, optionally initializing the collection of *CRDSettingsGroup* objects and list of keys from the settings bundle if it was not previously done.
     */
    private func updateCurrentSettingsDictionary() {
        
        // If we have no groups, then that must mean we need to initialize the internal collections from the settings bundle.
        if groupsInternal.count == 0 {
            
            initCurrentSettingsDictionary()
        }

        // If we still don't have any groups, then something must have gone wrong so bail out.
        guard groupsInternal.count > 0 else {
            
            return
        }
        
        // Synchronize user defaults and get the latest dictionary representation of them.
        UserDefaults.standard.synchronize()
        let currentSettings = UserDefaults.standard.dictionaryRepresentation()
        
        // Loop through all the groups and all the settings entries in each group and set the current value from the user defaults.
        for group in groupsInternal {
            
            if let entries = group.entries, entries.count > 0 {
    
                for entry in entries {
                    
                    if let currentSettingsValue = currentSettings[entry.identifier] {
                        
                        entry.currentValue = currentSettingsValue
                    }
                }
            }
        }
    }
}
