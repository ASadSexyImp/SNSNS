//
//  User.swift
//  Haunt
//
//  Created by Masakazu N1shimura on 2019/10/05.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import Foundation

struct User {
    var uid: String!
    var name: String!
    var link: String!
//    var color: UIColor!
    var imagePath: String!
    var haunts: [String]!
    var projects: [String]!
    var online: Bool!
    var log: [Log]!
}
