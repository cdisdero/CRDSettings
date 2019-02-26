//
//  CRDSettingsEntry
//  CRDSettings
//
//  Created by Christopher Disdero on 11/27/17.
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
 Class represents the base class of all non-group type entries in the app settings bundle.
 */
public class CRDSettingsEntry: CustomStringConvertible {
    
    // MARK: - Public properties
    
    /// The identifier of the setting entry.
    public var identifier: String {
        
        get {
            
            return self.identifierInternal
        }
    }
    
    /// The title of the setting entry, if any.
    public var title: String? {
        
        get {
            
            return self.titleInternal
        }
    }

    /// The current value for the setting entry, if any.
    public var currentValue: Any? = nil

    /// Flag to control whether this setting is disabled (true) or hidden (false) when another setting entry it depends on (see also *dependsOn*) is false
    public var disableOnDepends: Bool = false
    
    /// Flag to indicate whether this setting entry is enabled for user interaction.
    public var enabled: Bool = true
    
    /// The identifier of another *CRDSettingsEntry* that this entry depends on.  If the current value of that entry changes to false, this entry will either be disabled or hidden depending on the value of this setting entry's property *disableOnDepends*.
    public var dependsOn: String? {
        
        get {
            
            // For now, just get the first entry in the internal depends-on collection.  Support more than one dependsOn in future versions.
            return dependsOnInternal.count > 0 ? dependsOnInternal.first : nil
        }
        
        set {
            
            // Make sure we have a valid entry identifier specified.
            guard let newValue = newValue else { return }
            
            // For now, make sure there is at most one depends-on entry in the collection.  Support more than one in future versions.
            if dependsOnInternal.count > 0 {
                
                dependsOnInternal.removeAll()
            }
            
            // Add the specified identifier to the list.
            dependsOnInternal.append(newValue)
        }
    }
    
    // MARK: - Private members
    
    /// The identifier of this setting entry.
    private var identifierInternal: String
    
    /// The title of this setting entry.
    private var titleInternal: String? = nil
    
    /// The list of other *CRDSettingsEntry* object identifiers that this entry depends on.
    private var dependsOnInternal: [String] = []
    
    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsEntry* object with the given settings dictionary entry and action, if any.
     
     - parameter dictionary: The the settings bundle dictionary entry for the settings entry to create.
     */
    internal init(dictionary: NSDictionary) throws {
        
        // Ensure every entry has an identifier.
        guard let key = dictionary.object(forKey: "Key") as? String else { throw CRDSettingsEntryError.missingIdentifier }
        self.identifierInternal = key
        
        // Set the title from the settings bundle entry dictionary.
        if let title = dictionary.object(forKey: "Title") as? String {
            
            self.titleInternal = title
        }
        
        // Set the current value from the settings bundle entry dictionary key for default value.
        if let defaultValue = dictionary.object(forKey: "DefaultValue") {
            
            self.currentValue = defaultValue
        }
    }
    
    // MARK: - Internal methods
    
    internal static func createFrom(dictionary: NSDictionary) -> CRDSettingsEntry? {
        
        // Make sure the type is specified in the settings bundle entry dictionary.
        guard let type = dictionary.object(forKey: "Type") as? String else { return nil }

        do {

            switch type.lowercased() {
            case "pstoggleswitchspecifier":
                return try CRDSettingsToggleSwitch(dictionary: dictionary)
            case "pssliderspecifier":
                return try CRDSettingsSlider(dictionary: dictionary)
            case "pstitlevaluespecifier":
                return try CRDSettingsTitle(dictionary: dictionary)
            case "pstextfieldspecifier":
                return try CRDSettingsTextField(dictionary: dictionary)
            case "psmultivaluespecifier":
                return try CRDSettingsMultiValue(dictionary: dictionary)
            default:
                return nil
            }

        } catch {
         
            return nil
        }
    }

    // MARK: - CustomStringConvertible extension

    public var description: String {
        
        // Return the identifier and the current value formatted as expected for this settings entry.
        return "CRDSettingsEntry {id: \(identifier), value: \(currentValue != nil ? String(describing: currentValue!) : "nil")}"
    }
}
