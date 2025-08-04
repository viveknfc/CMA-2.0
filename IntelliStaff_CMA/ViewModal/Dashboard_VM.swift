//
//  Dashboard_VM.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 21/07/25.
//

import Foundation

@MainActor
@Observable
class DashboardViewModel {

    var menuGroups: [MenuGroup] = []

    var isLoading = false
    var errorMessage: String?
    
    var dashboardMenuItems: [Dashboard_Menu_Items] {
        return menuGroups.map { group in
            Dashboard_Menu_Items(
                id: group.id,
                title: group.parent.linkText,
                imageName: imageName(for: group.parent.linkText),
                itemCount: group.children.count,
                children: group.children.map {
                    ChildItem(
                        name: $0.linkText,
                        apiKey: $0.apiKey ?? "",
//                        imageName: imageName(for: $0.linkText)
                    )
                }
            )
        }
    }

    func fetchDashboard(contactID: Int) {
        Task {
            isLoading = true
            do {
                
                let params: [String: Any] = [
                    "ContactId": contactID
                ]
                let result = try await APIFunction.dashboardAPICalling(params: params)

                self.menuGroups = groupMenus(from: result)
                
                print("the menu group is \(self.menuGroups)")

                self.isLoading = false
            } catch {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
            }
        }
    }
    
    // MARK: - Menu Grouping

    func groupMenus(from menuItems: [MenuItem]) -> [MenuGroup] {
        var groups: [MenuGroup] = []
        
        let parents = menuItems.filter { $0.parentMenuId == 0 }
        
        for parent in parents {
            let children = menuItems.filter { $0.parentMenuId == parent.id }
            let group = MenuGroup(id: parent.id, parent: parent, children: children)
            groups.append(group)
        }
        
        return groups
    }

    
    // MARK: - Static icon mapping (can customize)
    private func imageName(for title: String) -> String {
        switch title {
        case "Dashboard": return "house"
        case "Payroll": return "banknote"
        case "Employee Benefits": return "heart.text.square"
        case "Manage Profile": return "person.crop.circle"
        case "Site": return "building.2"
        case "Orders": return "cart"
        case "Manage Contacts": return "person.2"
        case "Time Slips": return "clock.arrow.circlepath"
        case "Reports": return "doc.plaintext"
        case "Credentials": return "key"
        default: return "square.grid.2x2"
        }
    }
}

