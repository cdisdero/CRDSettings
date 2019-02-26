//
//  CRDSettingsTextField.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/20/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit

/**
 Class represents PSTextFieldSpecifier type entries in the app settings bundle.
 */
public class CRDSettingsTextField: CRDSettingsEntry {

    // MARK: - Public properties
    
    /// A flag indicating whether the field is secure (like a password).
    public var isSecure: Bool { get { return self.isSecureInternal } }
    
    /// The type of soft keyboard to display when editing this field.
    public var keyboardType: CRDSettingsTextFieldKeyboardType  { get { return self.keyboardTypeInternal } }
    
    /// The type of auto-capitalization for this field.
    public var autoCapitalizationType: CRDSettingsTextFieldAutoCapitalizationType  { get { return self.autoCapitalizationTypeInternal } }
    
    /// The type of auto-correction for this field.
    public var autoCorrectionType: CRDSettingsTextFieldAutoCorrectionType  { get { return self.autoCorrectionTypeInternal } }

    // MARK: - Private members
    
    private var isSecureInternal: Bool = false
    private var keyboardTypeInternal: CRDSettingsTextFieldKeyboardType = CRDSettingsTextFieldKeyboardType.Alphabet
    private var autoCapitalizationTypeInternal: CRDSettingsTextFieldAutoCapitalizationType = CRDSettingsTextFieldAutoCapitalizationType.None
    private var autoCorrectionTypeInternal: CRDSettingsTextFieldAutoCorrectionType = CRDSettingsTextFieldAutoCorrectionType.Default
    
    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsTextField* object with the given settings dictionary entry and action, if any.
     
     - parameter dictionary: The the settings bundle dictionary entry for the settings entry to create.
     */
    internal override init(dictionary: NSDictionary) throws {
        
        try super.init(dictionary: dictionary)
        
        // Set the secure field flag.
        if let isSecure = dictionary.object(forKey: "IsSecure") as? Bool {
            
            self.isSecureInternal = isSecure
        }
        
        // Set the keyboard type.
        if let keyboardTypeRaw = dictionary.object(forKey: "KeyboardType") as? String, let keyboardType = CRDSettingsTextFieldKeyboardType(rawValue: keyboardTypeRaw) {
            
            self.keyboardTypeInternal = keyboardType
        }
        
        // Set the auto-correction type.
        if let autocorrectionTypeRaw = dictionary.object(forKey: "AutocorrectionType") as? String, let autocorrectionType = CRDSettingsTextFieldAutoCorrectionType(rawValue: autocorrectionTypeRaw) {
            
            self.autoCorrectionTypeInternal = autocorrectionType
        }
        
        // Set the auto-capitalization type.
        if let autocapitalizationTypeRaw = dictionary.object(forKey: "AutocapitalizationType") as? String, let autocapitalizationType = CRDSettingsTextFieldAutoCapitalizationType(rawValue: autocapitalizationTypeRaw) {
            
            self.autoCapitalizationTypeInternal = autocapitalizationType
        }
    }
    
    // MARK: - CustomStringConvertible extension
    
    public override var description: String {
        
        // Return the identifier and the current value formatted as expected for this settings entry.
        return "CRDSettingsSlider {id: \(identifier), value: \(currentValue != nil && currentValue is String ? (currentValue as! String) : "nil")}"
    }
}
