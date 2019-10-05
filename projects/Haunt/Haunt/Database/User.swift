//
//  User.swift
//  Haunt
//
//  Created by Masakazu N1shimura on 2019/10/05.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var uid: String!
    var name: String!
    var link: String!
    var color: UIColor!
    var imagePath: String!
    var haunts: [Haunt]!
    var projects: [Project]!

}
