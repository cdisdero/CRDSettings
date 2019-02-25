//
//  CRDSettingsTextFieldAutoCorrectionType.swift
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
 An enum representing the types of auto-correction to enforce when editing a *CRDSettingsTextField* setting entry.
 */
public enum CRDSettingsTextFieldAutoCorrectionType: String {
    
    // The default auto-correction as set by the user
    case Default
    
    // No auto-correction
    case No
    
    // Full auto-correction
    case Yes
}

/**
 Extension for *UITextAutocorrectionType* to allow conversion from *CRDSettingsTextFieldAutoCorrectionType* values.
 */
public extension UITextAutocorrectionType {
    
    init(_ autocorrectionType: CRDSettingsTextFieldAutoCorrectionType) {
        
        switch autocorrectionType {
        case .Default:
            self = .default
        case .No:
            self = .no
        case .Yes:
            self = .yes
        }
    }
}
