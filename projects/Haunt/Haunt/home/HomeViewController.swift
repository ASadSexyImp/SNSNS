//
//  HomeViewController.swift
//  Haunt
//
//  Created by Masakazu N1shimura on 2019/10/05.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    @IBOutlet weak var logCollectionView: UICollectionView!
//    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    var collectionArray: [Log]! = []
    var cellCount: Int!
    var db:Firestore!
    var f = DateFormatter()
    var commitArray: [Int]!
    
    let saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logCollectionView.delegate = self
        self.logCollectionView.dataSource = self
        
        nameLabel.text = saveData.object(forKey: "userName") as! String?
        linkLabel.text = saveData.object(forKey: "userLink") as! String?
        
        db = Firestore.firestore()
        db.collection("logs").addSnapshotListener { snaps, error in
            
            if let error = error {
                fatalError("\(error)")
            }
            guard let snaps = snaps else { return }
            
            self.collectionArray.removeAll()
            // ここで投稿のデータが取れる（databaseRootをobserveしているため）
            for content in snaps.documents {
                // 最後はvalueで取ってこれる
                let value = content.data()
                
                let logUser = value["user"] as! String
                let logDate = value["date"]
                let logTime = value["time"]
                
                
                if logUser != self.nameLabel.text! {
                    continue
                }
                
                let log = Log(
                    date: logDate as! String,
                    time: logTime as! Int,
                    user: logUser as! String)
                self.collectionArray.append(log)
                
            }
//            print(" \(self.collectionArray)")
            self.logCollectionView.reloadData()
        }
//        self.projectCollectionView.delegate = self
//        self.projectCollectionView.dataSource = self
        rearrangeDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        logCollectionView.reloadData()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.purple.cgColor
        
        if commitArray[indexPath.row] > 10*60*60 {
            cell.backgroundColor = UIColor.purple
        } else if commitArray[indexPath.row] > 7*60*60 {
            
        } else if commitArray[indexPath.row] > 5*60*60 {
            
        } else if commitArray[indexPath.row] > 0 {
            cell.backgroundColor = UIColor.purple
        } else {
            cell.backgroundColor = UIColor.green
        }

        return cell
    }
//    
    func rearrangeDate() {
        commitArray = []
        let component = Calendar.Component.weekday
        let weekday = NSCalendar.current.component(component, from: NSDate() as Date)
        cellCount = 126 + weekday
        for i in 0 ..< cellCount {
            let f = DateFormatter()
            f.dateFormat = "yyyyMMdd"
            var date = Date()
            let calender = Calendar.current
            date = calender.date(byAdding: .day, value: -i, to: date)!
            
            var sum: Int = 0
            print(" \(collectionArray)")
            for dat in collectionArray {
                print (" \(f.string(from: date)) \(dat.date!)")
                if f.string(from: date) == dat.date! {
                    
                    sum += dat.time
                }
            }
            commitArray.insert(sum, at: 0)
        }
    }

}
