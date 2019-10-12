//
//  User.swift
//  Haunt
//
//  Created by Masakazu N1shimura on 2019/10/05.
//  Copyright © 2019 Masakazu Nishimura. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var uid: String!
    var name: String!
    var link: String!
    var color: String!
    var imagePath: String!
    var haunts: [Haunt]!
    var projects: [Project]!
    var online: Bool!
    var log: [Log]!
}
