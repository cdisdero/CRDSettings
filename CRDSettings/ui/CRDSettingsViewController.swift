//
//  CRDSettingsViewController
//  CRDSettings
//
//  Created by Christopher Disdero on 9/24/17.
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
 Class representing the main view controller for displaying a list of the app's settings.
 */
internal class CRDSettingsViewController: UITableViewController {
    
    // MARK: - Private members
    
    /// The list of notification observers.
    private var observers: [NSObjectProtocol] = []
    
    /// Reference to the app's instance of *CRDSettings* as required by adopting *CRDSettingsAppProtocol*
    private var settings: CRDSettings? = (UIApplication.shared.delegate as? CRDSettingsAppProtocol)?.settings

    // MARK: - Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Setup observer for when a switch type setting changes value.
        observers.append(NotificationCenter.default.addObserver(forName: Notification.Name(CRDSettingsSwitchTableViewCell.NotificationSettingsSwitchChanged), object: nil, queue: OperationQueue.main) { (notification) in
            
            // Get the setting values from the notification.
            guard let userInfo = notification.userInfo, let setting = userInfo["setting"] as? CRDSettingsEntry, let isOn = userInfo["isOn"] as? Bool else { return }
            
            // Update the user default entry corresponding to the setting that changed value.
            UserDefaults.standard.set(isOn, forKey: setting.identifier)
            UserDefaults.standard.synchronize()
        })

        // Setup observer for when a slider type setting changes value.
        observers.append(NotificationCenter.default.addObserver(forName: Notification.Name(CRDSettingsSliderTableViewCell.NotificationSettingsSliderChanged), object: nil, queue: OperationQueue.main) { (notification) in
            
            // Get the setting values from the notification.
            guard let userInfo = notification.userInfo, let setting = userInfo["setting"] as? CRDSettingsEntry, let value = userInfo["value"] as? NSNumber else { return }
            
            // Update the user default entry corresponding to the setting that changed value.
            UserDefaults.standard.set(value, forKey: setting.identifier)
            UserDefaults.standard.synchronize()
        })
        
        // Setup observer for when any setting value changes.
        observers.append(NotificationCenter.default.addObserver(forName: CRDSettings.NotificationSettingsChanged, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Whenever any setting value changes, update the table view so that current setting values are displyed.
            self.tableView.reloadData()
        })
        
        // Update the table view so that current setting values are displayed.
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)

        // Remove the observers for this view.
        for observer in observers {
            
            NotificationCenter.default.removeObserver(observer)
        }
        observers.removeAll()
    }
    
    // MARK: - Outlet handlers
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        
        // Dismiss this controller when you tap the Done button.
        dismiss(animated: true) {
            
            // Do nothing here.
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // For sections, use the total number of groups, so that settings are organized into groups by group title.
        guard let groups = settings?.groups else { return 0 }
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Use the setting entry count in each group for the number of rows in each section of the table.
        guard let items = itemsForSection(section: section) else { return 0 }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // Use the title of the group as the header in each section.
        guard let groups = settings?.groups, groups.count > section else { return "" }
        return groups[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the default cell for this index path.
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellDefault", for: indexPath)
        
        // Get the list of items for this section.
        if let items = itemsForSection(section: indexPath.section) {
            
            // Get the item for this row of this section.
            let item = items[indexPath.row]
            
            // Set the default cell text label to the title of the item.
            if let title = item.title {
            
                cell.textLabel?.text = title
            }
            
            // A flag indicating whether to display the right-hand accessory on the cell depending on the type of setting entry displayed.
            var enableAccessory = false
            
            // Switch on setting entry type...
            
            if item is CRDSettingsMultiValue {
                
                if let titleDetailCell = tableView.dequeueReusableCell(withIdentifier: "cellTitleDetail", for: indexPath) as? CRDSettingsTitleDetailTableViewCell {
                    
                    // Set the cell's reference to the setting entry to this setting entry (see CRDSettingsEntryTableViewCell)
                    titleDetailCell.settingEntry = item

                    // If we have a multi-value setting entry, then enable the right-hand accessory.
                    enableAccessory = true

                    // Use the special cell in the table.
                    cell = titleDetailCell
                }
                
            } else if item is CRDSettingsToggleSwitch {
                
                // If we have a switch type setting entry, use a special 'cellSwitch' instead of the default one.
                if let switchCell = tableView.dequeueReusableCell(withIdentifier: "cellSwitch", for: indexPath) as? CRDSettingsSwitchTableViewCell {
                    
                    // Set the cell's reference to the setting entry to this setting entry (see CRDSettingsEntryTableViewCell)
                    switchCell.settingEntry = item
                    
                    // Use the special cell in the table.
                    cell = switchCell
                }
                
            } else if item is CRDSettingsSlider {
                
                // If we have a slider type setting entry, use a special 'cellSlider' instead of the default one.
                if let sliderCell = tableView.dequeueReusableCell(withIdentifier: "cellSlider", for: indexPath) as? CRDSettingsSliderTableViewCell {
                    
                    // Set the cell's reference to the setting entry to this setting entry (see CRDSettingsEntryTableViewCell)
                    sliderCell.settingEntry = item
                    
                    // Use the special cell in the table.
                    cell = sliderCell
                }
                
            } else if item is CRDSettingsTextField {
                
                if let titleDetailCell = tableView.dequeueReusableCell(withIdentifier: "cellTitleDetail", for: indexPath) as? CRDSettingsTitleDetailTableViewCell {
                    
                    // Set the cell's reference to the setting entry to this setting entry (see CRDSettingsEntryTableViewCell)
                    titleDetailCell.settingEntry = item
                    
                    // If we have a multi-value setting entry, then enable the right-hand accessory.
                    enableAccessory = true
                    
                    // Use the special cell in the table.
                    cell = titleDetailCell
                }

            } else if item is CRDSettingsTitle {
                
                // If we have a title-only type setting entry, use a special 'cellTitle' instead of the default one.
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "cellTitle", for: indexPath)
                
                // Set the text label of the cell to the title of the setting entry.
                titleCell.textLabel?.text = (item as! CRDSettingsTitle).title
                
                // Use the special cell in the table.
                cell = titleCell
                
            } else if item is CRDSettingsActionButton {
                
                // If we have a button type setting entry, use a special 'cellButton' instead of the default one.
                if let buttonCell = tableView.dequeueReusableCell(withIdentifier: "cellButton", for: indexPath) as? CRDSettingsButtonTableViewCell {
                    
                    // Set the cell's reference to the setting entry to this setting entry (see CRDSettingsEntryTableViewCell)
                    buttonCell.settingEntry = item
                    
                    // Use the special cell in the table.
                    cell = buttonCell
                }
            }
            
            // Set the accessibility identifier of the cell to the identifier of the settings entry to make for easier testing.
            cell.accessibilityIdentifier = item.identifier
            
            // If we set the flag to enable the right-hand accessory on the cell, show it as a disclosure indicator to indicate there is a detail page for the setting entry.
            cell.accessoryType = enableAccessory ? .disclosureIndicator : .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        
        // Do not indent rows.
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        // No editing allowed in this table of setting entries!
        return .none
    }
    
    // MARK: - Segue navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We are going to segue to the detail view for a setting entry.
        if segue.identifier?.caseInsensitiveCompare("detailSegue") == .orderedSame {

            // Get the destination controller and the selected setting entry and set a reference in the detail view about to be opened.
            guard let selectedIndexPath = tableView.indexPathForSelectedRow, let items = itemsForSection(section: selectedIndexPath.section), items.count > selectedIndexPath.row, let destination = segue.destination as? CRDSettingsDetailViewController else { return }

            destination.selectedSettingsItem = items[selectedIndexPath.row]
        }
    }
    
    // MARK: - Private methods
    
    /**
     Returns an array of *CRDSettingsEntry* objects that are in the *CRDSettingsGroup* corresponding to the given section index.
     
     - parameter section: The index of the section that corresponds to a *CRDSettingsGroup* containing *CRDSettingsEntry* objects to be displayed in the section.
     
     - returns: An array of *CRDSettingsEntry* objects for the given section index, or nil if not found.
     */
    private func itemsForSection(section: Int) -> [CRDSettingsEntry]? {
        
        // Make sure we have a group with settings entries at the given section index.
        guard let groups = settings?.groups, groups.count > section else { return nil }
        
        // The actual entries to use in the table in the section, which may be a subset of the entries in the group for this section (some may have dependent settings which cause them to be excluded from the array presented).
        var entriesToUse: [CRDSettingsEntry] = []
        
        // Get all the entries for the group for this section.
        if let entries = groups[section].entries {
            
            // Loop through the entries...
            for entry in entries {
                
                // Assume the setting entry will be enabled and displayed in the group for this section.
                var enabled = true
                
                // If we have a dependency on this setting...
                if let dependency = entry.dependsOn {
                    
                    // Get the setting that this one is dependent on as well as the type.
                    if let dependencySetting = settings?.findSetting(identifier: dependency) {
                        
                        // TODO: Support more than just switch-type dependencies.
                        
                        // If the setting type of the setting that this one is dependent on is a switch, and the switch is on, then enable this setting, otherwise disable it.
                        if dependencySetting is CRDSettingsToggleSwitch, dependencySetting.currentValue is Bool {
                            
                            enabled = enabled && (dependencySetting.currentValue as! Bool)
                        }
                    }
                }
                
                // If this entry is disabled and the 'disableOnDepends' flag is off, then exclude this setting entry from the list of those displayed for this section of the table.
                if !entry.disableOnDepends && !enabled {
                    
                    continue
                }
                
                // Set the enabled flag for this setting entry.
                entry.enabled = enabled
                
                // Append it to the list of entries to display for this table section.
                entriesToUse.append(entry)
            }
        }
        
        return entriesToUse
    }
}
