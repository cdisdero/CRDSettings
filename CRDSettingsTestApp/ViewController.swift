//
//  ViewController.swift
//  CRDSettingsTestApp
//
//  Created by Christopher Disdero on 3/9/18.
//  Copyright © 2018 Christopher Disdero. All rights reserved.
//

import UIKit
import CRDSettings

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onSettings(_ sender: UIButton) {

        // Get the bundle corresponding to the CRDSettings framework.
        let storyboardBundle = Bundle(for: CRDSettings.self)
        
        // Get the storyboard from the framework labelled 'CRDSettings'.
        let storyboard = UIStoryboard(name: "CRDSettings", bundle: storyboardBundle)
        
        // Try to instantiate the settings view controller from the framework and present it as a slide-up form sheet.
        guard let settingsController = storyboard.instantiateInitialViewController() else { return }
        settingsController.modalTransitionStyle = .coverVertical
        settingsController.modalPresentationStyle = .formSheet
        present(settingsController, animated: true) {
            // Do nothing here.
        }
    }
}

