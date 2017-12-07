//
//  LoginViewController.swift
//  Chat ApplicationV2
//
//  Created by Mac on 12/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var passwordLabel:UILabel!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    //var manager:ChatApplicationManager = ChatApplicationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        aesthetics()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aesthetics(){
        self.view.backgroundColor = UIColor.black
        self.emailLabel.textColor = UIColor.cyan
        self.passwordLabel.textColor = UIColor.magenta
        self.emailTextField.textColor = UIColor.cyan
        self.emailTextField.layer.borderWidth = 1.0
        self.emailTextField.layer.borderColor = UIColor.cyan.cgColor
        self.emailTextField.backgroundColor = UIColor.darkGray
        self.passwordTextField.textColor = UIColor.magenta
        self.passwordTextField.layer.borderWidth = 1.0
        self.passwordTextField.layer.borderColor = UIColor.magenta.cgColor
        self.passwordTextField.backgroundColor = UIColor.darkGray
    }

}

typealias TFFunctions = LoginViewController
extension TFFunctions: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField === self.emailTextField){
            textField.resignFirstResponder()
            //textField.becomeFirstResponder()
            guard let text = textField.text else{return false}
            guard text.isValidEmail() else {
                
                let alert = UIAlertController(title: "Whoops", message: "Email is not in correct format", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default)
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                return false
            }
            passwordTextField.becomeFirstResponder()
            self.finalExecution()
        }else{
            textField.resignFirstResponder()
            //password.becomeFirstResponder()
            guard let text = textField.text else{return false}
            guard text.isValidPassword() else{
                let alert = UIAlertController(title: "No No No", message: "Password needs to contain at least 6 total character with one being a number", preferredStyle: .alert)
                let action = UIAlertAction(title: "Got it", style: .default)
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
                return false
            }
            //self.loginToFirebase()
            self.finalExecution()
            
        }
        return false
    }
    
    func finalExecution(){
        guard let email = self.emailTextField.text else{return}
        guard let password = self.passwordTextField.text else{return}
        ChatApplicationManager.shared.loginToFirebase(email, password)
        
        guard ChatApplicationManager.shared.isLoggedin() else{return}
        let appD = UIApplication.shared.delegate as! AppDelegate
        guard let vc = appD.slideMenuController else{return}
        //appD.window?.rootViewController = appD.slideMenuController
        //appD.window?.rootViewController?.show(appD.slideMenuController!, sender: self)
        appD.window?.rootViewController?.present(vc, animated: true)
        appD.window?.makeKeyAndVisible()
    }
    
    
}
