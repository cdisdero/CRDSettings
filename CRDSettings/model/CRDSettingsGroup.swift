//
//  CRDSettingsGroup
//  Scalr
//
//  Created by Christopher Disdero on 11/28/17.
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
 Class that represents a setting entry of type PSGroupSpecifier.
 */
public class CRDSettingsGroup {
    
    // MARK: - Public properties
    
    /// The title of the group
    public var title: String {
        
        get {
            
            return titleInternal
        }
    }
    
    /// The collection of *CRDSettingsEntry* objects within this group, if any.
    public var entries: [CRDSettingsEntry]? {
        
        get {
            
            return entriesInternal
        }
    }

    // MARK: - Private members
    
    /// The title of the group.
    private var titleInternal: String
    
    /// The collection of *CRDSettingsEntry* objects for this group, if any.
    private var entriesInternal: [CRDSettingsEntry]? = nil

    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsGroup* object with the specified title.
     
     - parameter title: The title for the group.
     */
    internal init(_ title: String) {
        
        // Set the group title.
        self.titleInternal = title
    }
    
    // MARK: - Public methods
    
    /**
     Adds the specified *CRDSettingsEntry* to this group after the entry with the identifer specified, if specified and if found, or to the end of the group, otherwise.
     
     - parameter entry: The *CRDSettingsEntry* to add to this group.
     - parameter afterIdentifier: If the identifier as it appears in the Root.plist of the settings bundle of the *CRDSettingsEntry* in this group to find is specified, then add after if found, or if nil, append to the end of the group.
     */
    public func add(_ entry: CRDSettingsEntry, afterIdentifier: String? = nil) {
        
        // Initialize the collection of entries for this group if necessary.
        if entriesInternal == nil {
            
            entriesInternal = []
        }
        
        // If there are currently no entries in this group, then just append the entry to the end.
        if entriesInternal!.count == 0 {
            
            entriesInternal?.append(entry)
            return
        }

        // Flag to record whether we added the entry after a specified entry.
        var added = false

        // If we have a valid identifier to add after...
        if let identifier = afterIdentifier {
    
            for (index, entryFound) in entriesInternal!.enumerated() {
                
                // Try to find the index of the specified identifier in this group.
                if entryFound.identifier.caseInsensitiveCompare(identifier) == .orderedSame {
                    
                    // Compute the index at which to insert the entry after the one with the specified identifier.
                    let newIndex = index + 1 > entriesInternal!.endIndex ? entriesInternal!.endIndex : index + 1
                    
                    // Insert the entry.
                    entriesInternal!.insert(entry, at: newIndex)
                    
                    // Set the flag to indicate we added the entry to the group.
                    added = true
                    
                    break
                }
            }
        }
        
        // If we didn't add the entry, append it now to the end of the group.
        if !added {

            entriesInternal?.append(entry)
        }
    }
    
    /**
     Inserts the specified *CRDSettingsEntry* to this group at the index specified.
     
     - parameter entry: The *CRDSettingsEntry* to insert into this group.
     - parameter atIndex: The index at which to insert the entry into the group.  If the index is greater than the last index of the group, the entry will be appended to the group.  If it is less than 0, the entry is inserted at position 0.
     */
    public func insert(_ entry: CRDSettingsEntry, atIndex: Int) {
        
        // Initialize the collection of entries for this group if necessary.
        if entriesInternal == nil {
            
            entriesInternal = []
        }
        
        // If the specified index is less than 0, insert the entry at the 0th position.
        if atIndex < 0 {
            
            entriesInternal?.insert(entry, at: 0)
            return
        }
        
        // If the specified index is greater than the end index, append to the end of the group.
        if atIndex > entriesInternal!.endIndex {
            
            entriesInternal?.append(entry)
            return
        }

        // Otherwise, insert at the specified index.
        entriesInternal?.insert(entry, at: atIndex)
    }
    
    /**
     Returns the first *CRDSettingsEntry* matching the identifer specified, or nil if not found.
     
     - parameter identifier: The identifier as it appears in the Root.plist of the settings bundle to find.

     - returns: The first *CRDSettingsEntry* matching the specified identifier in the group, or nil if none found.
     */
    public func find(_ identifier: String) -> CRDSettingsEntry? {
        
        // Initialize the collection of entries for this group if necessary.
        if entriesInternal == nil {
            
            entriesInternal = []
        }
        
        // Find all the entries in the group matching the identifier specified.
        if let entriesMatched = entriesInternal?.filter({ (entry) -> Bool in
            
            return entry.identifier.caseInsensitiveCompare(identifier) == .orderedSame
        
        }) {
            
            // If we found any, return the first one, otherwise return nil.
            return entriesMatched.count > 0 ? entriesMatched.first : nil
        }

        // If filter() returns nil, then return nil.
        return nil
    }
}
