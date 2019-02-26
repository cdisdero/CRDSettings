//
//  CRDSettingsSlider.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/20/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit

/**
 Class represents PSSliderSpecifier type entries in the app settings bundle.
 */
public class CRDSettingsSlider: CRDSettingsEntry {

    // MARK: - Public properties
    
    /// The minimum value for this setting entry, if any.
    public var minValue: Float? { get { return self.minValueInternal } }
    
    /// The file name (without extension) of an image stored in the app's setting bundle to use for the minimum value on the slider, if any.
    public var minValueImage: String?  { get { return self.minValueImageFileNameInternal } }
    
    /// The maximum value for this setting entry, if any.
    public var maxValue: Float?  { get { return self.maxValueInternal } }
    
    /// The file name (without extension) of an image stored in the app's setting bundle to use for the maximum value on the slider, if any.
    public var maxValueImage: String?  { get { return self.maxValueImageFileNameInternal } }
    
    /// The increment value for this setting entry, if any.
    public var incrementValue: Float? = nil

    // MARK: - Private members
    
    private var minValueInternal: Float? = nil
    private var minValueImageFileNameInternal: String? = nil
    private var maxValueInternal: Float? = nil
    private var maxValueImageFileNameInternal: String? = nil

    // MARK: - Initializers
    
    /**
     Instantiates a new *CRDSettingsSlider* object with the given settings dictionary entry and action, if any.
     
     - parameter dictionary: The the settings bundle dictionary entry for the settings entry to create.
     */
    internal override init(dictionary: NSDictionary) throws {
        
        try super.init(dictionary: dictionary)
        
        // Set the minimum value from the settings bundle entry dictionary.
        if let minValue = dictionary.object(forKey: "MinimumValue") as? NSNumber {
            
            self.minValueInternal = minValue.floatValue
        }
        
        // If this entry has a minimum value image, set it in the slider.
        if let minValueImage = dictionary.object(forKey: "MinimumValueImage") as? String {
            
            self.minValueImageFileNameInternal = minValueImage
        }
        
        // Set the maximum value from the settings bundle entry dictionary.
        if let maxValue = dictionary.object(forKey: "MaximumValue") as? NSNumber {
            
            self.maxValueInternal = maxValue.floatValue
        }
        
        // If this entry has a maximum value image, set it in the slider.
        if let maxValueImage = dictionary.object(forKey: "MaximumValueImage") as? String {
            
            self.maxValueImageFileNameInternal = maxValueImage
        }
        
        // If a min value and max value is set, then set the default increment value which is the difference in the range divided by 10 so that there are 10 approximately equal increments.
        if let minValue = self.minValue, let maxValue = self.maxValue, maxValue - minValue > 0 {
            
            self.incrementValue = ((maxValue - minValue) + 1.0) / 10.0
        }
    }

    // MARK: - CustomStringConvertible extension
    
    public override var description: String {
        
        // Return the identifier and the current value formatted as expected for this settings entry.
        var formattedValue: String? = nil
        if let value = currentValue as? Double {
            
            // Format the number according to the current locale settings for decimal formatting.
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formattedValue = formatter.string(from: NSNumber(floatLiteral: value))
        }
        return "CRDSettingsSlider {id: \(identifier), value: \(formattedValue != nil ? formattedValue! : "nil")}"
    }
}
