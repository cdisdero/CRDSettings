//
//  CRDSettingsActionButton.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/20/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit

/**
 Class represents action button type entries in the app settings bundle.
 */
public class CRDSettingsActionButton: CRDSettingsEntry {

    // MARK: - Public properties
    
    /// The *CRDSettingsAction* block of code to execute for this setting entry when the button is pressed, if any.
    public var action: CRDSettingsAction? {
        
        get {
            
            return self.actionInternal
        }
    }
    
    // MARK: - Private members
    
    /// The *CRDSettingsAction* associated with this entry, if any.
    private var actionInternal: CRDSettingsAction? = nil
    
    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsActionButton* object with the given settings dictionary entry and action, if any.
     
     - parameter identifier: The identifier of this button.
     - parameter title: The title of this button.
     - parameter action: A *CRDSettingsAction* code block to associate with this setting, if any.  It will be executed if the setting is selected, such as for a button.
     */
    public init(identifier: String, title: String, action: CRDSettingsAction? = nil) {

        // Create a dictionary to contain the specified values for the button and pass on to the base class for initialization.
        let dictionary: NSDictionary = ["Key": identifier, "Type": "button", "Title": title]
        
        // We assume this will never throw because we are specifying a 'Key' entry in the dictionary passed in.
        try! super.init(dictionary: dictionary)
        
        // If an action code block was specified to this initializer, then store a reference to it for later use.
        if let action = action {
            
            self.actionInternal = action
        }
    }

    // MARK: - CustomStringConvertible extension
    
    public override var description: String {
        
        // Return the identifier as expected for this settings entry.
        return "CRDSettingsAction {id: \(identifier)}"
    }
}
