//
//  CreateNewProjectViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/03.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase

class CreateNewProjectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var keyButton: UIButton!
    @IBOutlet weak var hauntCollectionView: UICollectionView!
    
    var collectionArray: [Haunt]! = []
    var me: User!
    var db:Firestore!
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hauntCollectionView.dataSource = self
        hauntCollectionView.register(UINib(nibName: "HauntCollectionViewCell", bundle: nil),forCellWithReuseIdentifier:"customCell")
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! HauntCollectionViewCell
        cell.ToolNameLabel.text = collectionArray[indexPath.row].name
        // ネットにある画像はダウンロードに時間がかかるのでこのように非同期画像表示ライブラリを使うと楽だしUX的にもよくなる
        if collectionArray[indexPath.row].imagePath !=  nil  {
            cell.hauntImage.kf.setImage(with: collectionArray[indexPath.row].imagePath)
        }
        return cell
    }
    
    @IBAction func TouchUpInsideKey(_ sender: Any) {
        keyButton.backgroundColor = UIColor.black
        project.secret = true
    }
    
    @IBAction func TouchUpInsideStart(_ sender: Any) {
        let name = projectNameTextField.text!
        project = Project(pid: "", name: "", time: "", secret: false, haunts: "")
        project.name = name
        // create document in firestore
        let saveDocument = db.collection("projects").document()
        saveDocument.setData([
            "name": name,
            "time": 0
//            "user": me.name!
//            "haunts": collectionArray as Any
        ]) { error in
            if error != nil {
                self.dismiss(animated: true, completion: nil)
                print("send error!")
            }
        }
        print("Create \(me.name)")
        performSegue(withIdentifier: "toRecord", sender: me)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecord" {
            let recordViewController = segue.destination as! RecordProjectTimeViewController
            recordViewController.project = project
            recordViewController.me = me
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // close keyboard
        textField.resignFirstResponder()
        return true
    }
}
