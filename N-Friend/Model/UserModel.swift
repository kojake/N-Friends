//
//  UserModel.swift
//  N-Friend
//
//  Created by kaito on 2024/03/25.
//

import Foundation
import UIKit

struct UserModel: Identifiable {
    var id = UUID()
    var UID: String
    var UserImage: UIImage?
    var Username: String
    var EnrollmentCampus: String
    var Tastes: [String]
}
