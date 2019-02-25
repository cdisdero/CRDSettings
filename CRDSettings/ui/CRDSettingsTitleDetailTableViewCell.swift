//
//  CRDSettingsTitleDetailTableViewCell.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/22/18.
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

import UIKit

/**
 Class representing types of *CRDSettingsEntry* that can be represented in a table view cell that has a title and detail label.
 */
internal class CRDSettingsTitleDetailTableViewCell: CRDSettingsEntryTableViewCell {

    // MARK: - Lifecycle methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        // Set the enablement of the fields depending on the settings entry.
        if let enabled = settingEntry?.enabled {
        
            self.textLabel?.isEnabled = enabled
            self.detailTextLabel?.isEnabled = enabled
        }

        // Set the title from the setting entry.
        if let title = settingEntry?.title {
        
            self.textLabel?.text = title
        }
        
        // Set the current value from the settings entry.
        if let multiValueEntry = settingEntry as? CRDSettingsMultiValue {
            
            self.detailTextLabel?.text = multiValueEntry.selectedTitle

        } else if let textFieldEntry = settingEntry as? CRDSettingsTextField {
            
            self.detailTextLabel?.text = textFieldEntry.isSecure ? "*****" : textFieldEntry.currentValue as? String

        } else {
    
            if let currentValue = settingEntry?.currentValue as? String {
                
                self.detailTextLabel?.text = currentValue
            }
        }
    }
}
