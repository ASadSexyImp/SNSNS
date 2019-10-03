//
//  LoginViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/02.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func touchUpInsideLoginButton(_ sender: Any) {
        // check mail
        guard let mail = mailTextField.text, mail != "" else {
            // pop up message
            let alertController = UIAlertController(title: "register error", message: "enter your mail", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        // check password
        guard let password = passwordTextField.text, password != "" else {
            // pop up message
            let alertController = UIAlertController(title: "register error", message: "enter your password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }

        // log in phase
        Auth.auth().signIn(withEmail: mail, password: password, completion: { [weak self] user, error in
            // check it self exit
            guard let self = self else { return }
            
            // error
            if let error = error {
                // pop up message
                let alertController = UIAlertController(title: "login error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                // move to original
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func touchUpInsideSignupButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignup", sender: nil)
    }
    
    // key board setting
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
