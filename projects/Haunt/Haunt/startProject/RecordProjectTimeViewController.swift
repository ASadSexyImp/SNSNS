//
//  RecordProjectTimeViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/03.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit

class RecordProjectTimeViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var pauseStartButton: UIButton!
    
    var project: Project!
    var me: User!
    var log: Log!
    var count: Int = 0
    var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectName.text = project.name
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseButton(_ sender: Any) {
        if timer.isValid {
            timer.invalidate()
        }else{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func finishButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toFinish", sender: me)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFinish" {
            let recordViewController = segue.destination as! FinishProjectRecordingViewController
            recordViewController.recordTime = count
            recordViewController.project = project
        }
    }
    
    @objc func up() {
        count = count + 1
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute,.hour,.second]
        let data = formatter.string(from: count)
    
        timeLabel.text = String(count)
    }
    
}
