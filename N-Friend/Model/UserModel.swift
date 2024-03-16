//
//  UserModel.swift
//  N-Friend
//
//  Created by kaito on 2024/02/25.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable{
    var id = UUID()
    //var UserImage: Image
    var Username: String
    var EnrollmentCampus: String
    var Tastes: [String]
    var Status: String
}
