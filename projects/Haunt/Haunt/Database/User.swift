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
    let uid: String!
    let name: String!
    let link: String!
    let color: String!
    let imagePath: String!
    let haunts: [Haunt]!
    let projects: [Project]!

}
