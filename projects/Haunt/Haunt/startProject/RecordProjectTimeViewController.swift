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
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet var label: UILabel!
    
    var count: Int = 0
    
    var timer: Timer = Timer()
    
    @IBAction func start() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func stop() {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    @objc func up() {
        count = count + 1
        label.text = String(format: "%.2f ", count)
    }

}
