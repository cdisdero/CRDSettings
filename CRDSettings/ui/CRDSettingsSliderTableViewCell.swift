//
//  CRDSettingsSliderTableViewCell
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
 Class representing a slider type *CRDSettingsEntry* in a table view cell.
 */
internal class CRDSettingsSliderTableViewCell: CRDSettingsEntryTableViewCell {

    // MARK: - Internal members

    /// Notification when the slider is changed.
    static let NotificationSettingsSliderChanged = "NotificationSettingsSliderChanged"

    /// Outlet for the slider.
    @IBOutlet weak var slider: UISlider!
    
    /// Outlet for the minimum value label.
    @IBOutlet weak var minLabel: UILabel!

    /// Outlet for the current value label.
    @IBOutlet weak var currentLabel: UILabel!
    
    /// Outlet for the maximum value label.
    @IBOutlet weak var maxLabel: UILabel!
    
    /// Outlet for the current edit field. (Hidden initially).
    @IBOutlet weak var currentEditField: UITextField!
    
    // MARK: - Lifecycle methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry as? CRDSettingsSlider else { return }
        
        // If the currentEditField is visible, that means we were in an editing session, so set the slider to this edited value before hiding the field.
        if !currentEditField.isHidden {
            
            if let newValueRaw = currentEditField.text, let newValue = Float(newValueRaw) {
                
                if let minValue = settingEntry.minValue, let maxValue = settingEntry.maxValue, newValue >= minValue && newValue <= maxValue {
                    
                    settingEntry.currentValue = NSNumber(floatLiteral: Double(newValue))
                }
            }
        }
        
        // Hide the current value edit field by default.  Unhidden only if user double-taps current value label.
        currentEditField.isHidden = true
        
        // Show the current value label by default.  Hidden only if user double-taps it.
        currentLabel.isHidden = false
        
        // Call the slider value changed handler when the slider is moved.
        slider.isContinuous = true
        
        // Hook up a double-tap handler to the current value label.
        let doubleTapGestureHandler = UITapGestureRecognizer(target: self, action: #selector(CRDSettingsSliderTableViewCell.handleDoubleTapOnCurrentLabel))
        doubleTapGestureHandler.numberOfTapsRequired = 2
        currentLabel.addGestureRecognizer(doubleTapGestureHandler)
        
        // Hook up an event handler for releasing the drag on the slider so that we know when to send a notification that the slider value has changed.
        slider.addTarget(self, action: #selector(self.sliderDidEndSliding), for: .touchUpInside)
        
        // Since this method gets called when the cell is presented, we take advantage of it and set the slider state from the settings entry properties.

        // If the setting entry specifies a minimum value, set the slider accordingly.
        if let minValue = settingEntry.minValue {
        
            slider.minimumValue = minValue
        }
        
        if let minValueImage = settingEntry.minValueImage {
            
            // Get the path for the main app settings bundle.
            if let settingsPath = Bundle.main.path(forResource: "Settings", ofType: "bundle") {
                
                slider.minimumValueImage = UIImage(named: minValueImage, in: Bundle(path: settingsPath), compatibleWith: nil)
            }
        }
        
        // If the setting entry specifies a maximum value, set the slider accordingly.
        if let maxValue = settingEntry.maxValue {
            
            slider.maximumValue = maxValue
        }
        
        if let maxValueImage = settingEntry.maxValueImage {
            
            // Get the path for the main app settings bundle.
            if let settingsPath = Bundle.main.path(forResource: "Settings", ofType: "bundle") {
                
                slider.maximumValueImage = UIImage(named: maxValueImage, in: Bundle(path: settingsPath), compatibleWith: nil)
            }
        }

        // If the setting entry specifies a valid numeric current value, set the slider accordingly.
        if let defaultValue = settingEntry.currentValue as? NSNumber {
            
            slider.setValue(defaultValue.floatValue, animated: true)
        }
        
        // Snap the current value to multiples of the increment for this settings entry, if any.
        if let incrementValue = settingEntry.incrementValue {
            
            let roundedValue = roundf(slider.value / incrementValue) * incrementValue;
            slider.value = roundedValue
        }
        
        // Format the number according to the current locale settings for decimal formatting.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current

        // Set the labels below the slider to the current state of the slider.
        minLabel.text = formatter.string(from: NSNumber(value: slider.minimumValue))
        currentLabel.text = formatter.string(from: NSNumber(value: slider.value))
        maxLabel.text = formatter.string(from: NSNumber(value: slider.maximumValue))

        // Set whether the slider is enabled based on the enabled property of the setting entry.
        slider.isEnabled = settingEntry.enabled
        minLabel.isEnabled = settingEntry.enabled
        currentLabel.isEnabled = settingEntry.enabled
        maxLabel.isEnabled = settingEntry.enabled
    }
    
    // MARK: - UI handlers

    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        
        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry as? CRDSettingsSlider else { return }

        // Snap the value change to multiples of the increment for this settings entry, if any.
        if let incrementValue = settingEntry.incrementValue {
        
            let roundedValue = roundf(sender.value / incrementValue) * incrementValue;
            sender.value = roundedValue
        }
        
        // Format the number according to the current locale settings for decimal formatting.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current

        // Update the current value label based on the slider value.
        currentLabel.text = formatter.string(from: NSNumber(value: sender.value))
    }
    
    @objc func sliderDidEndSliding() {

        // Make sure we have a valid settings entry.
        guard let settingEntry = settingEntry as? CRDSettingsSlider else { return }

        // Notfiy observers that the slider has changed.
        NotificationCenter.default.post(name: Notification.Name(CRDSettingsSliderTableViewCell.NotificationSettingsSliderChanged), object: self, userInfo: [CRDSettings.NotificationSettingsChangedSettingKey: settingEntry, "value": NSNumber(value: slider.value)])
    }
    
    @objc func handleDoubleTapOnCurrentLabel(sender:UITapGestureRecognizer) {
        
        // Set the current edit field to the current label text.
        currentEditField.text = currentLabel.text
        
        // Show the current value edit field.
        currentEditField.isHidden = false
        
        // Hide the current value label.
        currentLabel.isHidden = true
        
        // Set the field to have focus.
        currentEditField.becomeFirstResponder()
    }    
}
