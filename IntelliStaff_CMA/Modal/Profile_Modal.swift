//
//  Untitled.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 12/08/25.
//

import Foundation

struct ProfileModel: Codable, Identifiable {
    var id = UUID()
    var title: String
    var imageName: String
}
