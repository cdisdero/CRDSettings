//
//  CRDSettingsTextFieldAutoCapitalizationType.swift
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
 An enum representing the types of auto-capitalization to enforce when editing a *CRDSettingsTextField* setting entry.
 */
public enum CRDSettingsTextFieldAutoCapitalizationType: String {
    
    // No auto-capitalization
    case None
    
    // Auto-capitalize words
    case Words
    
    // Auto-capitalize sentences
    case Sentences
    
    // Auto-capitalize all characters entered
    case AllCharacters
}

/**
 Extension for *UITextAutocapitalizationType* to allow conversion from *CRDSettingsTextFieldAutoCapitalizationType* values.
 */
public extension UITextAutocapitalizationType {
    
    init(_ autocapitalizationType: CRDSettingsTextFieldAutoCapitalizationType) {
        
        switch autocapitalizationType {
        case .None:
            self = .none
        case .Words:
            self = .words
        case .Sentences:
            self = .sentences
        case .AllCharacters:
            self = .allCharacters
        }
    }
}
