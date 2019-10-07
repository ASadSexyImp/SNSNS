//
//  Project.swift
//  Haunt
//
//  Created by Masakazu N1shimura on 2019/10/05.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import Foundation
import Firebase

struct Project {
    var pid: String!
    var name: String!
    var time: NSDate!
    var secret: Bool!
    var haunts: [Haunt]!
}
