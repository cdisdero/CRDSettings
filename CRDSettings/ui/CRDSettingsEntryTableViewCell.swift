//
//  CRDSettingsEntryTableViewCell
//  CRDSettings
//
//  Created by Christopher Disdero on 2/22/18.
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
 Base class of all special table cells used to present the current value of a *CRDSettingsEntry* in a table view.
 */
internal class CRDSettingsEntryTableViewCell: UITableViewCell {

    /// A reference to the *CRDSettingsEntry* associated with this cell, if any.
    var settingEntry: CRDSettingsEntry? = nil
}
