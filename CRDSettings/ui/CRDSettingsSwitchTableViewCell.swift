//
//  CRDSettingsSwitchTableViewCell
//  CRDSettings
//
//  Created by Christopher Disdero on 11/3/17.
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
 Class representing a toggle switch type *CRDSettingsEntry* in a table view cell.
 */
internal class CRDSettingsSwitchTableViewCell: CRDSettingsEntryTableViewCell {

    // MARK: - Internal members

    /// Notification when the switch is changed.
    static let NotificationSettingsSwitchChanged = "NotificationSettingsSwitchChanged"

    /// Outlet for the title label.
    @IBOutlet weak var title: UILabel!
    
    /// Outlet for the switch.
    @IBOutlet weak var cellSwitch: UISwitch!
    
    // MARK: - Lifecycle methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry else { return }
        
        // Since this method gets called when the cell is presented, we take advantage of it and set the switch title and state from the settings entry properties.
        title.text = settingEntry.title
        cellSwitch.isOn = settingEntry.currentValue as! Bool
        
        // Set whether the switch is enabled based on the enabled property of the setting entry.
        title.isEnabled = settingEntry.enabled
        cellSwitch.isEnabled = settingEntry.enabled
    }
    
    // MARK: - UI handlers

    @IBAction func onSwitch(_ sender: UISwitch) {

        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry else { return }
        
        // Notfiy observers that the switch has changed.
        NotificationCenter.default.post(name: Notification.Name(CRDSettingsSwitchTableViewCell.NotificationSettingsSwitchChanged), object: self, userInfo: [CRDSettings.NotificationSettingsChangedSettingKey: settingEntry, "isOn": sender.isOn])
    }
}
