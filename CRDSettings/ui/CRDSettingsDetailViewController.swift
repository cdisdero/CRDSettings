//
//  CRDSettingsDetailViewController
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
 Class representing the detail view controller for a given setting entry.
 */
internal class CRDSettingsDetailViewController: UITableViewController {

    // MARK: - Internal properties
    
    // The *CRDSettingsEntry* object representing the setting entry selected in the table of the *CRDSettingsViewController*.  This reference is set in the segue prepare routine in *CRDSettingsViewController*.
    internal var selectedSettingsItem: CRDSettingsEntry? = nil
    
    // MARK: - Private members

    /// The list of notification observers.
    private var observers: [NSObjectProtocol] = []

    // MARK: - Lifecycle methods

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Loop through the cells in the detail view.
        let totalCells = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalCells {
            
            // Get the cell.
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            
            // If the cell is an edit text field, then sync the current settings value (which is the text in the field) with user defaults.
            if let cell = cell as? CRDSettingsEditTextTableViewCell {
                
                if let key = cell.settingEntry?.identifier, let value = cell.settingEntry?.currentValue {
                
                    UserDefaults.standard.set(value, forKey: key)
                    UserDefaults.standard.synchronize()
                }
            }
        }
        
        // Remove the observers for this view.
        for observer in observers {
            
            NotificationCenter.default.removeObserver(observer)
        }
        observers.removeAll()
    }
    
    //MARK: - UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Make sure we have a valid settings entry.
        guard self.selectedSettingsItem != nil else { return 0 }
        
        // Just one section per settings entry in the detail view.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Make sure we have a valid settings entry and get it's type.
        guard let selectedSettingsItem = self.selectedSettingsItem else { return 0 }
        
        // Default to no rows.
        var rows = 0
        
        // If the setting entry type is a multi-value, then set the number of cells to the number of titles in the multi-value.
        if selectedSettingsItem is CRDSettingsMultiValue {
            
            if let titles = (selectedSettingsItem as! CRDSettingsMultiValue).titles {
                
                rows = titles.count
            }
        
        // If the setting entry is of type text field, then the number of rows is just one - one for the edit text field to present.
        } else if selectedSettingsItem is CRDSettingsTextField {
            
            rows = 1
        }

        return rows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        // Make sure we have a valid settings entry else set the section header to blank.
        guard let selectedSettingsItem = self.selectedSettingsItem else { return "" }
        
        // Set the section header to be the title of the setting entry.
        return selectedSettingsItem.title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the cell for this index path.
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellDefault", for: indexPath)
        
        // Set the cell to have no accessory by default.
        cell.accessoryType = .none
        
        // Get the selected setting entry and it's type.
        if let selectedSettingsItem = self.selectedSettingsItem {

            // Get the current value for the setting entry
            let currentValue = selectedSettingsItem.currentValue

            // If we have a multi-value entry, then set the cell's text label to the title of the multi-value for this row and enable the checkmark accessory on the row that represents a value which is equal to the current value of the setting entry.
            if selectedSettingsItem is CRDSettingsMultiValue {
                
                let selectedMultiValue = selectedSettingsItem as! CRDSettingsMultiValue
                
                if let titles = selectedMultiValue.titles, let values = selectedMultiValue.values {
                    
                    // Set cell text label to the title of the multi-value for this row.
                    cell.textLabel?.text = titles[indexPath.row]
                    
                    // If the current value is of number type...
                    if let currentValue = currentValue as? NSNumber, let rowValue = values[indexPath.row] as? NSNumber {
                        
                        cell.accessoryType = rowValue.isEqual(to: currentValue) ? .checkmark : .none
                    }
                    
                    // If the current value is of string type...
                    else if let currentValue = currentValue as? String, let rowValue = values[indexPath.row] as? String {
                        
                        cell.accessoryType = rowValue.caseInsensitiveCompare(currentValue) == .orderedSame ? .checkmark : .none
                    }
                }
            
            // If we have a text field type entry, use a special EditTextCell instead of the default one.
            } else if selectedSettingsItem is CRDSettingsTextField {
                
                if let editTextCell = tableView.dequeueReusableCell(withIdentifier: "cellEditText", for: indexPath) as? CRDSettingsEditTextTableViewCell {
                    
                    // Set the cell's reference to the setting entry to this setting entry (see CRDSettingsEntryTableViewCell)
                    editTextCell.settingEntry = selectedSettingsItem

                    // Use the special cell in the table.
                    cell = editTextCell
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        
        // No indenting!
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        // No editing of cells in the detail view!
        return .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Make sure we have a valid settings entry and get its type and identifier.
        guard let selectedSettingsItem = self.selectedSettingsItem else { return }
        
        // Get the identifier.
        let itemIdentifier = selectedSettingsItem.identifier
        
        // If the setting entry is a multi-value type...
        if selectedSettingsItem is CRDSettingsMultiValue {
            
            let selectedMultiValue = selectedSettingsItem as! CRDSettingsMultiValue
            
            // Get the values and make sure we have more than enough to cover the current row.
            if let values = selectedMultiValue.values, values.count > indexPath.row {
                
                // Set the current value of the settings entry to the value selected.
                selectedSettingsItem.currentValue = values[indexPath.row]
                
                // Sync the current settings value with user defaults.
                UserDefaults.standard.set(selectedSettingsItem.currentValue, forKey: itemIdentifier)
                UserDefaults.standard.synchronize()
                
                // Update the table entries so that the selected value is checked.
                tableView.reloadData()
            }
        }
    }
}
