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

class AccountsettingViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var AccountImageView: UIImageView!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var LinkTextField: UITextField!
    
    //    @IBOutlet weak var ColorPinkButton: UIButton!
    //    @IBOutlet weak var ColorGradButton: UIButton!
    //    @IBOutlet weak var ColorBlueButton: UIButton!
    
    @IBOutlet weak var hauntCollectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    
    var collectionArray: [Haunt]! = []
    var userColor:UIColor = UIColor.purple
    var me: User!
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hauntCollectionView.dataSource = self
        hauntCollectionView.register(UINib(nibName: "HauntCollectionViewCell", bundle: nil),forCellWithReuseIdentifier:"customCell")
        //        startButton.backgroundColor = userColor
        if Auth.auth().currentUser == nil {
            dismiss(animated: true, completion: nil)
        }
        
        db = Firestore.firestore()
        
        db.collection("haunts").addSnapshotListener { snaps, error in
            
            if let error = error {
                fatalError("\(error)")
            }
            guard let snaps = snaps else { return }
            
            self.collectionArray?.removeAll()
            // ここで投稿のデータが取れる（databaseRootをobserveしているため）
            for content in snaps.documents {
                // 最後はvalueで取ってこれる
                let value = content.data()
                
                let hauntHid = value["hid"] as! String
                let hauntName = value["name"] as! String
                let hauntImagePath = value["imagePath"] as! String
                let hauntUser = value["user"] as! [String]?
                
                let haunt = Haunt(
                    hid: hauntHid,
                    name: hauntName,
                    imagePath: hauntImagePath == "" ? nil : URL(string: hauntImagePath),
                    users: hauntUser)
                self.collectionArray?.append(haunt)
            }
            self.hauntCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // when push collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hauntName = collectionArray[indexPath.row].name
        me.haunts.append(hauntName!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! HauntCollectionViewCell
        cell.ToolNameLabel.text = collectionArray[indexPath.row].name
        // ネットにある画像はダウンロードに時間がかかるのでこのように非同期画像表示ライブラリを使うと楽だしUX的にもよくなる
        if collectionArray[indexPath.row].imagePath !=  nil  {
            
            cell.hauntImage.kf.setImage(with: collectionArray[indexPath.row].imagePath)
        }
        
        //        cell.hauntImage.kf.setImage(with: collectionArray[indexPath.row].imagePath)
        print("final url is\(collectionArray[indexPath.row].imagePath)")
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
        //        let color = userColor
        
        // define my information
        me.uid = uid
        me.name = name
        me.link = link
        //        me.color = color
        
        // create document in firestore
        let saveDocument = db.collection("users").document()
        saveDocument.setData([
            "uid": uid as Any,
            "name": name,
            "link": link,
            //            "color": color,
            "haunts": collectionArray as Any
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
