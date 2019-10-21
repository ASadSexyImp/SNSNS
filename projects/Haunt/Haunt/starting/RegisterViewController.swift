//
//  ViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/01.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class RegisterViewController: UIViewController, UITextFieldDelegate, FUIAuthDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var AuthButton: UIButton!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth()
    ]
    
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        mailTextField.layer.borderColor=[[UIColor, colorWithRed,:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0], CGColor]
        mailTextField.layer.borderColor = UIColor.purple.cgColor
        mailTextField.layer.borderWidth = 2.0
        mailTextField.attributedPlaceholder = NSAttributedString(string: "mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        
        passwordTextField.layer.borderColor = UIColor.purple.cgColor
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        passwordConfirmTextField.isSecureTextEntry = true // disclose password
        
        passwordConfirmTextField.layer.borderColor = UIColor.purple.cgColor
        passwordConfirmTextField.layer.borderWidth = 2.0
        passwordConfirmTextField.attributedPlaceholder = NSAttributedString(string: "password confirm", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        passwordConfirmTextField.isSecureTextEntry = true // disclose password
        
        // authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
        AuthButton.addTarget(self,action: #selector(self.AuthButtonTapped(sender:)),for: .touchUpInside)
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
                        self.performSegue(withIdentifier: "toAccountSetting", sender: nil)
                    }
                })
            }
        })
    }
    
    @objc func AuthButtonTapped(sender : AnyObject) {
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
    }
    
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            self.performSegue(withIdentifier: "toAccountSetting", sender: self)
        }
        // エラー時の処理をここに書く
        print("error")
    }
    
    @IBAction func touchUpInsideLoginButton(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    // key board setting
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
