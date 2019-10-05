//
//  AccountsettingViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/03.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase

class AccountsettingViewController: UIViewController {
    
    @IBOutlet weak var AccountImageView: UIImageView!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var LinkTextField: UITextField!
    
    @IBOutlet weak var ColorPinkButton: UIButton!
    @IBOutlet weak var ColorGradButton: UIButton!
    @IBOutlet weak var ColorBlueButton: UIButton!
    
    var userColor:UIColor!
    //firestore
    var db:Firestore!
    // my info
    var me: User!
    // current user
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        setGradientBackground();
        super.viewWillAppear(animated)
    }
    
    // pink button
    @IBAction func pinkButton(_ sender: Any) {
        // decide user color
        userColor = ColorPinkButton.backgroundColor
        // change background
        ColorPinkButton.backgroundColor = UIColor.black
        // enable to push only other button
        ColorPinkButton.isEnabled = false
        ColorGradButton.isEnabled = true
        ColorBlueButton.isEnabled = true
    }
    // grad button
    @IBAction func gradButton(_ sender: Any) {
        // decide user color
        userColor = ColorGradButton.backgroundColor
        // change background
        ColorGradButton.backgroundColor = UIColor.black
        // enable to push only other button
        ColorPinkButton.isEnabled = true
        ColorGradButton.isEnabled = false
        ColorBlueButton.isEnabled = true
    }
    // blue button
    @IBAction func blueButton(_ sender: Any) {
        // decide user color
        userColor = ColorBlueButton.backgroundColor
        // change background
        ColorBlueButton.backgroundColor = UIColor.black
        // enable to push only other button
        ColorPinkButton.isEnabled = true
        ColorGradButton.isEnabled = true
        ColorBlueButton.isEnabled = false
    }
    
    
    
    @IBAction func touchUpInsideStartButton(_ sender: Any) {
        let uid = currentUser?.uid
        
        let name = UsernameTextField.text!
        let link = LinkTextField.text!
        let color = userColor!
        var haunts: [String]!
        for haunt in me.haunts {
            haunts.append(haunt.hid)
        }
//        let image =
        
        // define my information
        me.name = name
        me.link = link
        me.color = color
        me.haunts = []
        
        // create document in firestore
        let saveDocument = db.collection("users").document((uid as? String)!)
        saveDocument.setData([
            "name": name,
            "link": link,
            "color": color,
            "haunts": haunts
        ]) { error in
            if error != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
        performSegue(withIdentifier: "toHome", sender: me)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close keyboard
        textField.resignFirstResponder()
        return true
    }
}
