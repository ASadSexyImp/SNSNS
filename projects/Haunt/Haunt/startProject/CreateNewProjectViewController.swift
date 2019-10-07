//
//  CreateNewProjectViewController.swift
//  Haunt
//
//  Created by Masakazu Nishimura on 2019/10/03.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit

class CreateNewProjectViewController: UIViewController {

    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var keyButton: UIButton!
    @IBOutlet weak var hauntCollectionView: UICollectionView!
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        project.name = projectNameTextField.text
        // Do any additional setup after loading the view.
    }

    @IBAction func TouchUpInsideKey(_ sender: Any) {
        keyButton.backgroundColor = UIColor.black
        project.secret = true
        performSegue(withIdentifier: "toResultView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecordProjectView" {
            let recordViewController = segue.destination as! RecordProjectTimeViewController
            recordViewController.project = project
        }
    }
    
}
