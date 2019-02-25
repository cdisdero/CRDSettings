//
//  CRDSettingsEditTextTableViewCell
//  CRDSettings
//
//  Created by Christopher Disdero on 3/11/18.
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
 Class representing a text field type *CRDSettingsEntry* in a table view cell.
 */
internal class CRDSettingsEditTextTableViewCell: CRDSettingsEntryTableViewCell {

    // MARK: - Internal members

    /// Outlet for the text field.
    @IBOutlet weak var editTextField: UITextField!
    
    // MARK: - Lifecycle methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry as? CRDSettingsTextField else { return }

        // Set whether this is a password field from the settings entry.
        editTextField.isSecureTextEntry = settingEntry.isSecure
        
        // Set the type of keyboard used for the text field.
        editTextField.keyboardType = UIKeyboardType(settingEntry.keyboardType)
        
        // Set the autocapitalization for the text field.
        editTextField.autocapitalizationType = UITextAutocapitalizationType(settingEntry.autoCapitalizationType)
        
        // Set the autocorrection style for the text field.
        editTextField.autocorrectionType = UITextAutocorrectionType(settingEntry.autoCorrectionType)
        
        // Since this method gets called when the cell is presented, we take advantage of it and set the text field state from the settings entry properties.
        if let value = settingEntry.currentValue as? String {
            
            editTextField.text = value
        }

        // Set whether the text field is enabled based on the enabled property of the setting entry.
        editTextField.isEnabled = settingEntry.enabled
        
        // If the text field is enabled, set it to be the first responder so it will get focus.
        if editTextField.isEnabled {
            
            editTextField.becomeFirstResponder()
        }
    }

    // MARK: - UI handlers
    
    @IBAction func onEditFieldChanged(_ sender: UITextField) {
        
        // Update the current value of the associated settings entry from the text field text.
        settingEntry?.currentValue = sender.text
    }    
}

