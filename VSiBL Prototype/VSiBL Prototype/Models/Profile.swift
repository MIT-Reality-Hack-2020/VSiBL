//
//  Profile.swift
//  VSiBL Prototype
//
//  Created by User239 on 1/18/20.
//  Copyright © 2020 VSiBL. All rights reserved.
//

import Foundation

enum UserRole {
    case designer
    case developer
    case storyteller
    case staff
    
    static var allRoles: [UserRole] = [.designer, .developer, .storyteller, .staff]
    
    var description: String {
        switch self {
        case .designer:
            return "Designer"
        case .developer:
            return "Developer"
        case .storyteller:
            return "Storyteller"
        case .staff:
            return "Staff"
        }
    }
}
