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
    
//    @IBOutlet weak var logCollectionView: UICollectionView!
//    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    var cellCount: Int!
//    var db:Firestore!
//    var f = DateFormatter()
//    let saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.logCollectionView.delegate = self
//        self.logCollectionView.dataSource = self
//        self.projectCollectionView.delegate = self
//        self.projectCollectionView.dataSource = self
        
//        db = Firestore.firestore()
//        nameLabel.text = saveData.object(forKey: "userName") as! String?
//        linkLabel.text = saveData.object(forKey: "userLink") as! String?

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        logCollectionView.reloadData()
        
        rearrangeDate()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        cell.backgroundColor = me.color
//
//        if maxCommit! == 0 {
//            cell.backgroundColor = UIColor(me.color, alpha: 1)
//        }
        return cell
    }
//    
    func rearrangeDate() {
//        commitArray = []
//        let component = Calendar.Component.weekday
//        let weekday = NSCalendar.current.component(component, from: NSDate() as Date)
//        print(weekday) //日曜日が1で土曜日が7
//        cellCount = 126 + weekday
//        for i in 0 ..< cellCount {
//            let f = DateFormatter()
//            f.dateFormat = "yyyyMMdd"
//            var date = Date()
//            let calender = Calendar.current
//            date = calender.date(byAdding: .day, value: -i, to: date)!
//            let item = realm.objects(Item.self).filter("dateString == %@", f.string(from: date))
//            commitArray.insert(item.count, at: 0)
//        }
//        print("honyamorake\(commitArray)")
    }

}
