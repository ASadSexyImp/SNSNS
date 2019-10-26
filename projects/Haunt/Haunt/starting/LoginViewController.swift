//
//  LoginViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/02.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController, UITextFieldDelegate, FUIAuthDelegate {
    // imagebutton
    @IBOutlet weak var AuthButton: UIButton!
    // auth page
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // provider auth
    let providers: [FUIAuthProvider] = [ FUIGoogleAuth(), FUIFacebookAuth()]
    // firestore connect
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // authUI setting
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
    
    @objc func AuthButtonTapped(sender : AnyObject) {
        // authUI view
        let authViewController = self.authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    //　auth success func
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            self.performSegue(withIdentifier: "toTutorial", sender: self)
        }
        print("error")
    }
    
    @IBAction func touchUpInsideSignupButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignup", sender: nil)
    }

}




