//
//  MatchCardUserModel.swift
//  N-Friend
//
//  Created by kaito on 2024/04/13.
//

import Foundation
import UIKit

struct MatchCardUserModel: Identifiable {
    var id = UUID()
    var UID: String
    var Username: String
    var UserImage: UIImage
}
