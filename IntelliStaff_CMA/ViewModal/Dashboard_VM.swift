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
    static var escapedCandidateJSONString: [String:Any]?
    static var escapedDemographicsJSONString: String?
    
    var candidateID: Int?
    var ssn: String?
    var clientId: Int?
    var lastName: String?
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

    func fetchDashboard(contactID: Int, clientID: Int) {
        Task {
            isLoading = true
            do {
                guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                    print("User ID not found or not an Int")
                    return
                }
                let params: [String: Any] = [
                    "ContactId": contactID
                ]
                let result = try await APIFunction.dashboardAPICalling(params: params)
                await candidateIDAPI(contactId: clientID, clientId: contactID)
              //  await demographicAPI(candidateId: userId)
                self.menuGroups = groupMenus(from: result)
                
//                print("the menu group is \(self.menuGroups)")

                self.isLoading = false
            } catch {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
            }
        }
    }
    
    func jsonStringToDictionary(_ jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            print("❌ Failed to convert string to Data")
            return nil
        }

        do {
            // First try parsing normally
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return jsonObject
            }

            // If it’s wrapped in quotes (double-encoded), decode inner string
            if let decodedString = try JSONSerialization.jsonObject(with: data, options: []) as? String,
               let innerData = decodedString.data(using: .utf8),
               let innerObject = try JSONSerialization.jsonObject(with: innerData, options: []) as? [String: Any] {
                return innerObject
            }

        } catch {
            print("❌ JSON parsing error: \(error)")
        }
        return nil
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
    
    //MARK: - Candidate ID API Calling
    
    func candidateIDAPI(contactId: Int, clientId:Int) async {
        let params: [String: Any] = [
            "ContactId": clientId,
            "clientId": contactId
        ]
        do {
            let result = try await APIFunction.candidateIdAPICalling(params: params)
            
//            print("the candidate id result is ", result)
            
//            self.candidateID = result.candidateID
//            self.ssn = result.ssn
//            self.clientId = result.clientId
//            self.lastName = result.lastName
            
            // ✅ Encode to JSON string
            let encoder = JSONEncoder()
           // let data = try encoder.encode(result)
            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                let doubleEncoded = "\"\(jsonString)\"" // 👈 wraps JSON string in quotes
//                let escapedCandidateJSON = escapeForJavaScript(doubleEncoded)
//                if let dict = jsonStringToDictionary(escapedCandidateJSON) {
//                  
//                    print(dict)  // ["name": John, "age": 30, "isEmployee": 1]
//                    
//
//                    DashboardViewModel.escapedCandidateJSONString = dict
//                    
//                }
//               
//            }
            
            if let dict = result.toDictionary() {
                print(dict) // ✅ Full dictionary representation
                DashboardViewModel.escapedCandidateJSONString = dict
            }
    } catch let decodingError as DecodingError {
        switch decodingError {
        case .keyNotFound(let key, let context):
            self.errorMessage = "Missing key: \(key.stringValue) in \(context.codingPath)"
        case .typeMismatch(let type, let context):
            self.errorMessage = "Type mismatch: \(type) at \(context.codingPath)"
        case .valueNotFound(let type, let context):
            self.errorMessage = "Value not found: \(type) at \(context.codingPath)"
        case .dataCorrupted(let context):
            self.errorMessage = "Corrupted data: \(context.debugDescription)"
        @unknown default:
            self.errorMessage = "Unknown decoding error"
        }
    } catch let urlError as URLError {
        self.errorMessage = "Network error: \(urlError.localizedDescription)"
    } catch {
        self.errorMessage = "Unexpected error: \(error)"
    }

    }
    
    func demographicAPI(candidateId: Int) async {
        let params: [String: Any] = [
            "candidateId": candidateId
        ]
        do {
            let result = try await APIFunction.demographicAPICalling(params: params)
            print("the result for demographic API is ", result)
            let accessToken = APIConstants.accessToken
            
            let subset = LoggedInInfo(
                candidateId: result.candidateId,
                accessToken: accessToken,
                applicantId: result.candidateId,
                companyEmail: result.companyEmail ?? "",
                division: result.divisionId ?? 0,
                divisionName: result.divisionName ?? "",
                email: result.email ?? "",
                firstName: result.firstName ?? "",
                id: result.candidateId,
                lastName: result.lastName ?? "",
                skills: result.skills ?? []
            )
            
            
            // ✅ Encode to JSON string
            let encoder = JSONEncoder()
            let data = try encoder.encode(subset)
            if let jsonString = String(data: data, encoding: .utf8) {
                let doubleEncoded = "\"\(jsonString)\"" // 👈 wraps JSON string in quotes
                let escaped = escapeForJavaScript(doubleEncoded)
                DashboardViewModel.escapedDemographicsJSONString = escaped

            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
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

extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("❌ Error converting to dictionary: \(error)")
            return nil
        }
    }
}
