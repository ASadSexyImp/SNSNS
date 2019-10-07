//
//  HauntCollectionViewCell.swift
//  Haunt
//
//  Created by Masakazu N1shimura on 2019/10/04.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import UIKit
import Firebase

class HauntCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageButton: UIButton!
    @IBOutlet weak var ToolNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction override func select(_ sender: Any?) {
        
    }
    
    func setUpContents(image: UIImage, textName: String) {
        ImageButton.setImage(image, for: .normal)
        ToolNameLabel.text = textName
    }
    


}
