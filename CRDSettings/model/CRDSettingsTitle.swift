//
//  CRDSettingsTitle.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/20/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit

/**
 Class represents PSTitleValueSpecifier type entries in the app settings bundle.
 */
public class CRDSettingsTitle: CRDSettingsEntry {

    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsTitle* object with the given settings dictionary entry and action, if any.
     
     - parameter dictionary: The the settings bundle dictionary entry for the settings entry to create.
     */
    internal override init(dictionary: NSDictionary) throws {
        
        try super.init(dictionary: dictionary)
    }
    
    // MARK: - CustomStringConvertible extension
    
    public override var description: String {
        
        // Return the identifier and the current value formatted as expected for this settings entry.
        return "CRDSettingsTitle {id: \(identifier), value: \(currentValue != nil && currentValue is String ? (currentValue as! String) : "nil")}"
    }
}
