//
//  ViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/01.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        passwordConfirmTextField.isSecureTextEntry = true // disclose password
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func touchUpInsideRegisterButton(_ sender: Any) {
        // mail check
        guard let mail = mailTextField.text, mail != "" else {
            // pop up message
            let alertController = UIAlertController(title: "register error", message: "enter your mail", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        // password check
        guard let password = passwordTextField.text, password != "" else {
            // pop up message
            let alertController = UIAlertController(title: "register error", message: "enter your password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        // password confirm check
        guard let repass = passwordConfirmTextField.text, repass == password else {
            // pop up message
            let alertController = UIAlertController(title: "register error", message: "password do not match", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }

        // Firebae auth
        Auth.auth().createUser(withEmail: mail, password: password, completion: { [weak self] user, error in
            // check it self exit
            guard let self = self else { return }
            
            // error
            if let error = error {
                // localizedDescription show error for local language
                let alertController = UIAlertController(title: "register error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                // sign in phase
                Auth.auth().signIn(withEmail: mail, password: password, completion: { user, error in
                    // error
                    if let error = error {
                        // pop up message
                        let alertController = UIAlertController(title: "log in error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: "toResultView", sender: nil)
                    }
                })
            }
        })
    }

    @IBAction func touchUpInsideLoginButton(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    // key board setting
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAccountSettingView" {
            let accountViewController = segue.destination as! AccountsettingViewController
            accountViewController.user = Auth.auth().currentUser
        }
    }


}

