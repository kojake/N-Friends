//
//  UserModel.swift
//  N-Friend
//
//  Created by kaito on 2024/02/25.
//

import Foundation
import SwiftUI

struct CardUserModel: Identifiable{
    var id = UUID()
    var UserUID: String
    var UserImage: UIImage
    var Username: String
    var EnrollmentCampus: String
    var Tastes: [String]
    var Swipe: CGFloat
    var degrees: Double
}
