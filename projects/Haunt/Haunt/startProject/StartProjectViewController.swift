//
//  StartProjectViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/03.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit

class StartProjectViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var projectPickerView: UIPickerView!
//    var me: User!
    var pickerData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.projectPickerView.delegate = self
        self.projectPickerView.dataSource = self
        
        // Input the data into the array
        pickerData = ["No Project"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    @IBAction func TouchUpInsideStart(_ sender: Any) {
        if pickerData == ["No project"] {
            return
        }
        performSegue(withIdentifier: "toRecord", sender: nil)
    }
    
    @IBAction func TouchUpInsideNew(_ sender: Any) {
        performSegue(withIdentifier: "toCreateNewProject", sender: nil)
    }
    
}
