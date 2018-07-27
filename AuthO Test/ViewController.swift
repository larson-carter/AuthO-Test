//
//  ViewController.swift
//  AuthO Test
//
//  Created by Larson Carter on 7/21/18.
//  Copyright © 2018 Larson Carter. All rights reserved.
//

import UIKit

import Auth0

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func showLoginController(_ sender: UIButton) {
        
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://" + clientInfo.domain + "/userinfo")
            .start {
                
                switch $0 {
                    
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken else { return }
                    self.showSuccessAlert(accessToken)
                    
                }
                
        }
        
    }
    
    // MARK: - Private
    fileprivate func showSuccessAlert(_ accessToken: String) {
        
        let alert = UIAlertController(title: "Success", message: "accessToken: \(accessToken)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
            
    }
    
    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
            
    }
    
    return (clientId: clientId, domain: domain)
    
}
