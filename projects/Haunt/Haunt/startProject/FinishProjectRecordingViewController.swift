//
//  FinishProjectRecordingViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/03.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase

class FinishProjectRecordingViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    
    var recordTime: Int!
    var me: User!
    var project: Project!
    var log: Log!
    var db:Firestore!
    var f = DateFormatter()
    let saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = String(recordTime)
        log = Log()
//        project = Project(haunts: <#String#>)
        db = Firestore.firestore()
    }
    
    @IBAction func finishButton(_ sender: Any) {
        f.dateFormat = "yyyyMMdd"
        log.date = f.string(from: Date())
        log.time = recordTime
        
        let saveDocument = db.collection("logs").document()
        saveDocument.setData([
            "date": log.date as Any,
            "time": recordTime as Any,
            "user": saveData.object(forKey: "userName") as! String?
        ]) { error in
            if error != nil {
                self.dismiss(animated: true, completion: nil)
                print("send error!")
            }
        }
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
}
