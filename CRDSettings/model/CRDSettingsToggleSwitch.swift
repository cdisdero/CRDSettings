//
//  CRDSettingsToggleSwitch.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/20/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit

/**
 Class represents PSToggleSwitchSpecifier type entries in the app settings bundle.
 */
public class CRDSettingsToggleSwitch: CRDSettingsEntry {

    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsToggleSwitch* object with the given settings dictionary entry and action, if any.
     
     - parameter dictionary: The the settings bundle dictionary entry for the settings entry to create.
     */
    internal override init(dictionary: NSDictionary) throws {
        
        try super.init(dictionary: dictionary)
    }

    // MARK: - CustomStringConvertible extension

    public override var description: String {
        
        // Return the identifier and the current value formatted as expected for this settings entry.
        return "CRDSettingsToggleSwitch {id: \(identifier), value: \(currentValue != nil && currentValue is Bool ? (currentValue as! Bool) ? "ON" : "OFF" : "nil")}"
    }
}
