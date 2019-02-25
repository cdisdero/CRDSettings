//
//  CRDSettingsAction
//  CRDSettings
//
//  Created by Christopher Disdero on 11/29/17.
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
 The type of a setting action, or block to execute, for a particular *CRDSettingsEntry* object that it may be associated with.
 
 - parameter settingEntry: The *CRDSettingsEntry* object that this action was called on.
 */
public typealias CRDSettingsAction = (_ settingEntry: CRDSettingsEntry?) -> Void

