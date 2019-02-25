//
//  CRDSettingsButtonTableViewCell
//  CRDSettings
//
//  Created by Christopher Disdero on 11/30/17.
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
 Class representing a button type *CRDSettingsEntry* in a table view cell.
 */
internal class CRDSettingsButtonTableViewCell: CRDSettingsEntryTableViewCell {

    // MARK: - Internal members
    
    /// Notification when the button is pressed.
    static let NotificationSettingsButtonPressed = "NotificationSettingsButtonPressed"

    /// Outlet for the button.
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry as? CRDSettingsActionButton else { return }

        // Since this method gets called when the cell is presented, we take advantage of it and set the button title from the settings entry title.
        button.setTitle(settingEntry.title, for: .normal)
        
        // Set whether the button is enabled based on the enabled property of the setting entry.
        button.isEnabled = settingEntry.enabled
    }

    // MARK: - UI handlers
    
    @IBAction func onButtonTap(_ sender: UIButton) {
        
        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry as? CRDSettingsActionButton else { return }

        // If we have a *CRDSettingsAction* code block, execute it when the button is pressed.
        if let action = settingEntry.action {
            
            action(settingEntry)
        }
    }
}
