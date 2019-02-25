//
//  CRDSettingsTextFieldKeyboardType.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/19/18.
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
 An enum representing the types of soft-keyboards to present when editing a *CRDSettingsTextField* setting entry.
 */
public enum CRDSettingsTextFieldKeyboardType: String {
    
    /// Default ASCII keyboard
    case Alphabet
    
    /// Only numbers and punctuation keyboard
    case NumbersAndPunctuation
    
    /// Phone-like number pad
    case NumberPad
    
    /// Keyboard useful for entering URLs
    case URL
    
    /// Keyboard for entering email addresses
    case EmailAddress
}

/**
 Extension for *UIKeyboardType* to allow conversion from *CRDSettingsTextFieldKeyboardType* values.
 */
public extension UIKeyboardType {
    
    init(_ keyboardType: CRDSettingsTextFieldKeyboardType) {
        
        switch keyboardType {
        case .Alphabet:
            self = .alphabet
        case .EmailAddress:
            self = .emailAddress
        case .NumbersAndPunctuation:
            self = .numbersAndPunctuation
        case .NumberPad:
            self = .numberPad
        case .URL:
            self = .URL
        }
    }
}
