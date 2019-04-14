//
//  CRDSettingsMultiValue.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/20/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit

/**
 Class represents PSMultiValueSpecifier type entries in the app settings bundle.
 */
public class CRDSettingsMultiValue: CRDSettingsEntry {

    // MARK: - Public properties
    
    /// The currently selected title for a multi-value type setting entry.
    public var selectedTitle: String? { get { return self.selectedTitleInternal } }
    
    /// The list of titles for a multi-value type setting entry.
    public var titles: [String]?  { get { return self.titlesInternal } }
    
    /// The list of values associated with the *titles* for a multi-value type setting entry.
    public var values: [Any]?  { get { return self.valuesInternal } }
    
    /// The current value for the setting entry, if any.
    public override var currentValue: Any? {
        
        didSet {
            
            // Whenever we set a current value in the setting, update the selected title if we have a setting that is multi-value type.
            updateMultiValueTypeSelectedTitle()
        }
    }
    
    // MARK: - Private members
    
    private var selectedTitleInternal: String? = nil
    private var titlesInternal: [String]? = nil
    private var valuesInternal: [Any]? = nil
    
    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsMultiValue* object with the given settings dictionary entry and action, if any.
     
     - parameter dictionary: The the settings bundle dictionary entry for the settings entry to create.
     */
    internal override init(dictionary: NSDictionary) throws {
        
        try super.init(dictionary: dictionary)
        
        // Set the titles and values from the settings bundle entry dictionary.
        if let titles = dictionary.object(forKey: "Titles") as? [String], let values = dictionary.object(forKey: "Values") as? [Any] {
            
            self.titlesInternal = titles
            self.valuesInternal = values
        }
    }

    // MARK: - Private methods
    
    /**
     Updates the selected title from the list of titles for a multi-value setting entry type based on the current value of the setting entry.
     */
    private func updateMultiValueTypeSelectedTitle() {
        
        guard let titles = self.titles, let values = self.values else { return }
        
        if let currentValue = self.currentValue as? NSNumber, let numberValues = values as? [NSNumber] {
            
            if let indexFound = numberValues.firstIndex(where: { (value) -> Bool in
                
                return value.isEqual(to: currentValue)
                
            }) {
                
                self.selectedTitleInternal = titles[indexFound]
            }
        }
        
        if let currentValue = self.currentValue as? String, let stringValues = values as? [String] {
            
            if let indexFound = stringValues.firstIndex(where: { (value) -> Bool in
                
                return value.caseInsensitiveCompare(currentValue) == .orderedSame
                
            }) {
                
                self.selectedTitleInternal = titles[indexFound]
            }
        }
    }
    
    // MARK: - CustomStringConvertible extension
    
    public override var description: String {
        
        // Try to get the current value string given the current value.
        var currentValueString: String? = nil
        if let titles = self.titles, let values = self.values {
            
            if let currentValue = self.currentValue as? NSNumber, let numberValues = values as? [NSNumber] {
                
                if let indexFound = numberValues.firstIndex(where: { (value) -> Bool in
                    
                    return value.isEqual(to: currentValue)
                    
                }) {
                    
                    currentValueString = titles[indexFound]
                }
            }
            
            if let currentValue = self.currentValue as? String, let stringValues = values as? [String] {
                
                if let indexFound = stringValues.firstIndex(where: { (value) -> Bool in
                    
                    return value.caseInsensitiveCompare(currentValue) == .orderedSame
                    
                }) {
                    
                    currentValueString = titles[indexFound]
                }
            }
        }
        
        // Return the identifier and the current value formatted as expected for this settings entry.
        return "CRDSettingsMultiValue {id: \(identifier), value: \(currentValueString != nil ? currentValueString! : "nil")}"
    }
}
