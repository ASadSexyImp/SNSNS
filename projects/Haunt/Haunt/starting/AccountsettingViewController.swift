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

class AccountsettingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageButton: UIButton!
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
    let saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsernameTextField.layer.borderColor = UIColor.purple.cgColor
        UsernameTextField.layer.borderWidth = 2.0
        UsernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        
        LinkTextField.layer.borderColor = UIColor.purple.cgColor
        LinkTextField.layer.borderWidth = 2.0
        LinkTextField.attributedPlaceholder = NSAttributedString(string: "link", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        
        hauntCollectionView.dataSource = self
        hauntCollectionView.register(UINib(nibName: "HauntCollectionViewCell", bundle: nil),forCellWithReuseIdentifier:"customCell")
        //        startButton.backgroundColor = userColor
        if Auth.auth().currentUser == nil {
            dismiss(animated: true, completion: nil)
        }
        
        me = User()
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
                let hauntName = value["name"] as? String
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
//        me.haunts.append(hauntName!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray!.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! HauntCollectionViewCell
        cell.ToolNameLabel.text = collectionArray[indexPath.row].name
        // ネットにある画像はダウンロードに時間がかかるのでこのように非同期画像表示ライブラリを使うと楽だしUX的にもよくなる
        if collectionArray[indexPath.row].imagePath !=  nil  {
            
            cell.hauntImage.kf.setImage(with: collectionArray[indexPath.row].imagePath)
        }
        
        //        cell.hauntImage.kf.setImage(with: collectionArray[indexPath.row].imagePath)
        print("final name is\(collectionArray[indexPath.row].name)")
        return cell
    }
    
    // open camera library
    @IBAction func touchUoInsideImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func touchUpInsideStartButton(_ sender: Any) {
//        let uid = (Auth.auth().currentUser?.uid)!
        let name = UsernameTextField.text!
        let link = LinkTextField.text!
        //        let color = userColor
        
        // define my information
        saveData.set(name, forKey: "userName")
        saveData.set(link, forKey: "userLink")
//        
        // create document in firestore
        let saveDocument = db.collection("users").document()
        saveDocument.setData([
//            "uid": String(uid),
            "name": name,
            "link": link
//            "haunts": collectionArray as Any
        ]) { error in
            if error != nil {
                self.dismiss(animated: true, completion: nil)
                print("send error!")
            }
        }
        performSegue(withIdentifier: "toProject", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey :Any]) {
        imageButton.setImage(info[.editedImage] as? UIImage, for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
}
