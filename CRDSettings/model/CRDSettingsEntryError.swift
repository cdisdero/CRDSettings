//
//  CRDSettingsEntryError.swift
//  CRDSettings
//
//  Created by Christopher Disdero on 3/20/18.
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
 Error enum representing errors that can occur in the *CRDSettingsEntry* class.
 */
public enum CRDSettingsEntryError: Error, LocalizedError {

    /// The identifier is missing from the entry.
    case missingIdentifier
    
    // MARK: - Localized Error methods
    
    public var errorDescription: String? {
        
        switch self {
        case .missingIdentifier:
            return NSLocalizedString("No identifier could be found for the setting entry.", comment: "missingIdentifier error")
        }
    }
}
