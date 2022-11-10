//
//  LoginViewController.swift
//  Chess
//
//  Created by Николай Щербаков on 10.11.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "chessBoardSegue", sender: nil)
    }
    
    
}
