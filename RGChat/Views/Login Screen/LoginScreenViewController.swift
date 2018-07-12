//
//  LoginScreenViewController.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import UIKit
import Firebase

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLoginButonAction(_ sender: UIButton) {
        
        guard let name = nameTextField.text else {return}
        guard let number = numberTextField.text else {return}
        
        if name.count > 0 && number.count > 0 {
            UserDefaults.standard.setValue(name, forKey: "displayname")
            UserDefaults.standard.setValue(number, forKey: "phoneNumber")
            UserDefaults.standard.synchronize()
            UserManager().markUserAsLoggedIn()
            self.showConversationViewController()
        }
    }
    
    func showConversationViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conversationsViewController = storyboard.instantiateViewController(withIdentifier: "ConversationsViewController") as! ConversationsViewController
        conversationsViewController.senderId = numberTextField.text
        conversationsViewController.senderDisplayName = nameTextField.text
        self.navigationController?.pushViewController(conversationsViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
