//
//  Dashboard_Modal.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 20/07/25.
//
import Foundation

struct MenuItem: Identifiable, Decodable {
    let id: Int           // Alias for MenuId
    let parentMenuId: Int
    let linkText: String
    let controller: String?
    let action: String?
    let menuOrder: Int
    let className: String?
    let target: String
    let queryStringData: String
    let apiKey: String?
    let url: String
    let reportGuid: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "MenuId"
        case parentMenuId = "ParentMenuId"
        case linkText = "LinkText"
        case controller = "Controller"
        case action = "Action"
        case menuOrder = "MenuOrder"
        case className = "ClassName"
        case target = "Target"
        case queryStringData = "QuerystingData"
        case apiKey = "APIKey"
        case url = "URL"
        case reportGuid = "ReportGuid"
    }
}

struct MenuGroup: Identifiable {
    let id: Int
    let parent: MenuItem
    let children: [MenuItem]
}

struct Dashboard_Menu_Items: Identifiable, Equatable {
    let id: Int
    let title: String
    let imageName: String
    let itemCount: Int
    let children: [ChildItem]?
}

struct ChildItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let apiKey: String
    let imageName: String = "notes"
}


