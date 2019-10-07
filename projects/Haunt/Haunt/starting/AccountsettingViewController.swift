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
    
    @IBOutlet weak var hauntCollectionView: UICollectionView!
    
    var collectionArray: [QueryDocumentSnapshot] = []
    var userColor:UIColor!
    var me: User!
    var db:Firestore!
    let currentUser = Auth.auth().currentUser
    //    var HauntArray: [Haunt]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("haunts").addSnapshotListener { snaps, error in
            
            if let error = error {
                fatalError("\(error)")
            }
            guard let snaps = snaps else { return }
            
            // reload data
            self.collectionArray.removeAll()
            for document in snaps.documents {
                self.collectionArray.append(document)
            }
            self.hauntCollectionView.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // when push collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = collectionArray[indexPath.row].data() as! Dictionary<String, AnyObject>
        let hauntName = String(describing: content["name"]!)
        me.haunts.append(hauntName)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HauntCollectionViewCell
        let content = collectionArray[indexPath.row].data() as! Dictionary<String, AnyObject>
        cell.ToolNameLabel.text = String(describing: content["name"]!)
        
        return cell
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
        //        let image =
        
        // define my information
        me.uid = uid
        me.name = name
        me.link = link
//        me.color = color
        
        // create document in firestore
        let saveDocument = db.collection("users").document()
        saveDocument.setData([
            "uid": uid as String?,
            "name": name,
            "link": link,
            "color": color,
            "haunts": collectionArray
        ]) { error in
            if error != nil {
                self.dismiss(animated: true, completion: nil)
                print("send error!")
            }
        }
        performSegue(withIdentifier: "toHome", sender: me)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close keyboard
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeView" {
            let homeViewController = segue.destination as! HomeViewController
            homeViewController.me = me
        }
    }
}
