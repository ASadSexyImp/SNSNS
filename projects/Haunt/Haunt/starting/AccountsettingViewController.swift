//
//  AccountsettingViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/03.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class AccountsettingViewController: UIViewController {
    
    @IBOutlet weak var AccountImageView: UIImageView!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var LinkTextField: UITextField!
    
//    @IBOutlet weak var ColorPinkButton: UIButton!
//    @IBOutlet weak var ColorGradButton: UIButton!
//    @IBOutlet weak var ColorBlueButton: UIButton!
    
    @IBOutlet weak var hauntCollectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    
    var collectionArray: [QueryDocumentSnapshot] = []
    var userColor:UIColor = UIColor.purple
    var me: User!
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            dismiss(animated: true, completion: nil)
        }
        
        // Points to the root reference
//        var storageRef = Storage.storage().reference(forURL: "gs://haunt-105fe.appspot.com/")
//        var storageRef = Storage.storage().reference()
//        storageRef.child("images").putData(metadata: nil) { metadata, error in
//
//            let downloadURL = metadata!.downloadURL()
//            let url = String(describing: downloadURL)
//            let post: Dictionary = ["postimage": url]
//            newPostRef.setValue(post)
//        }
        
        db = Firestore.firestore()
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
//        startButton.backgroundColor = userColor
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
        // ネットにある画像はダウンロードに時間がかかるのでこのように非同期画像表示ライブラリを使うと楽だしUX的にもよくなる
        cell.ImageButton.kf.setImage(with: collectionArray[indexPath.row].imagePath)
        
        return cell
    }
    
//    // pink button
//    @IBAction func pinkButton(_ sender: Any) {
//        // decide user color
//        userColor = ColorPinkButton.backgroundColor!
//        // change background
//        ColorPinkButton.backgroundColor = UIColor.black
//        // enable to push only other button
//        ColorPinkButton.isEnabled = false
//        ColorGradButton.isEnabled = true
//        ColorBlueButton.isEnabled = true
//    }
//    // grad button
//    @IBAction func gradButton(_ sender: Any) {
//        // decide user color
//        userColor = ColorGradButton.backgroundColor!
//        // change background
//        ColorGradButton.backgroundColor = UIColor.black
//        // enable to push only other button
//        ColorPinkButton.isEnabled = true
//        ColorGradButton.isEnabled = false
//        ColorBlueButton.isEnabled = true
//    }
//    // blue button
//    @IBAction func blueButton(_ sender: Any) {
//        // decide user color
//        userColor = ColorBlueButton.backgroundColor!
//        // change background
//        ColorBlueButton.backgroundColor = UIColor.black
//        // enable to push only other button
//        ColorPinkButton.isEnabled = true
//        ColorGradButton.isEnabled = true
//        ColorBlueButton.isEnabled = false
//    }
    
    @IBAction func touchUpInsideStartButton(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let name = UsernameTextField.text!
        let link = LinkTextField.text!
        let color = userColor
        //        let image =
        
        // define my information
        me.uid = uid
        me.name = name
        me.link = link
//        me.color = color
        
        // create document in firestore
        let saveDocument = db.collection("users").document()
        saveDocument.setData([
            "uid": uid,
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
