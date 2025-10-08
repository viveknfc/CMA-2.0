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
    static var escapedCandidateJSONString: String?
    static var escapedDemographicsJSONString: String?
//    var escapedCandidateJSONString: String?
//    var escapedDemographicsJSONString: String?
    var divisionImage: String = ""
    var dashboardData: DashboardResponse?
   
    var assignmentItems: AssignmentResponse?

    var showAlert: Bool = false
    var alertMessage: String = ""
    var isLoading = false
    var errorMessage: String?
    
    var escapedCandidateJSONString: String?
    var escapedDemographicsJSONString: String?
   // var dashboardMenuItems: [Dashboard_Menu_Items] = []
    var candidateID: Int?
    var ssn: String?
    var clientId: Int?
    var lastName: String?
    
    var dashboardMenuItems: [Dashboard_Menu_Items] {
        return menuGroups.map { group in
            Dashboard_Menu_Items(
               // id: group.id,
                title: group.parent.linkText,
                imageName: imageName(for: group.parent.linkText),
                itemCount: group.children.count,
                children: group.children.map {
                    ChildItem(
                        name: $0.linkText,
                        //imageName: $0.url,
                        apiKey: $0.apiKey ?? "",
                       // imageName: imageName(for: $0.linkText)
                    )
                }
            )
        }
    }

    func fetchDashboard(contactID: Int, clientID: Int, divisionid: Int) {
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
//                getDiVisionTheme(divisionID: divisionid, clientID: clientID) { logo in
//                   print("division logo is \(logo)")
//                    self.divisionImage = logo
//               }
                self.menuGroups = groupMenus(from: result)
                await candidateIDAPI(contactId: clientID, clientId: contactID)
                await demographicAPI(candidateId: userId)
                await getScheduleDetails()
               
//                print("the menu group is \(self.menuGroups)")
                
                
                self.isLoading = false
            } catch {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
            }
        }
    }
    
    
    func getDiVisionTheme(
        divisionID: Int,
        clientID: Int,
        completion: @escaping (String) -> Void
    ) {
        isLoading = true
        Task {
            do {
                let params: [String: Any] = [
                    "clientId": clientID,
                    "DivisionID": divisionID
                ]
                let result = try await APIFunction.clientThemeAPICalling(params: params)
                print("the theme group is \(result)")
                completion(result.first?.divisionLogo ?? "")
            } catch {
                self.errorMessage = error.localizedDescription
                completion("")
            }
            self.isLoading = false
        }
    }
    
    private func groupMenuItems(_ items: [MenuItem]) -> [MenuGroup] {
        let parents = items.filter { $0.parentMenuId == nil }
        return parents.map { parent in
            let children = items.filter { $0.parentMenuId == parent.id }
            return MenuGroup( parent: parent, children: children)
        }
    }
    
    func fetchAssignmentDetails() async {
        
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("User ID not found or not an Int")
            return
        }
        
        let params: [String: Any] = [
            "candidateId": userId,
            "skip": 0,
            "LimitRows": 4,
            "jobType": 1
        ]
        do {
            let result = try await APIFunction.fetchAssignmentDetails(params: params)
            assignmentItems = result
            print("the assignment response details is", result)
        }
        catch {
            self.errorMessage = error.localizedDescription
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
            let group = MenuGroup( parent: parent, children: children)
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
            let data = try encoder.encode(result)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                let doubleEncoded = "\"\(jsonString)\"" // 👈 wraps JSON string in quotes
                DashboardViewModel.escapedCandidateJSONString = escapeForJavaScript(doubleEncoded)
//                if let dict = jsonStringToDictionary(escapedCandidateJSON) {
//                  
//                    print(dict)  // ["name": John, "age": 30, "isEmployee": 1]
//                    
//
//                   // DashboardViewModel.escapedCandidateJSONString = dict
//                    
//                }
               
            }
            
//            if let dict = result.toDictionary() {
//                print(dict) // ✅ Full dictionary representation
//               escapedCandidateJSONString = dict
//            }
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
               // DashboardViewModel.
                DashboardViewModel.escapedDemographicsJSONString = escaped

            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    
    func getScheduleDetails() async {
        let params: [String: Any] = [
            "ClientId":95108,
            "DivisionClientId":0,
            "DivisionId":6,
            "EndDate":"2025-10-05",
            "IsCwaShow":2,
            "IsDivisionSort":0,
            "IsNameSort":0,
            "IsOrderList":0,
            "IsShiftSort":0,
            "MasterClientId":0,
            "OrderId":0,
            "Position":"",
            "StartDate":Date_Time_Formatter.utcDateFormat(from: Date()),
            "Status":"All",
            "SubDivisionClientId":0,
            "VendorId":0 ]
        do {
            let (orders, message) = try await APIFunction.orderTrackingAPICalling(params: params)

            if let message = message {
                print("⚠️ API returned message: \(message)")
                return
            }

            for order in orders {
                let subset = LoggedInInfo(
                    candidateId: order.candidateId ?? 0,
                    accessToken: APIConstants.accessToken,
                    applicantId: order.candidateId ?? 0,
                    companyEmail: order.email ?? "",
                    division: order.divisionId ?? 0,
                    divisionName: order.divisionName ?? "",
                    email: order.email ?? "",
                    firstName: order.firstName ?? "",
                    id: order.candidateId ?? 0,
                    lastName: order.lastName ?? "", skills: [0]
                )

                // ✅ Encode to JSON string
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(subset)
                if let jsonString = String(data: data, encoding: .utf8) {
                    let doubleEncoded = "\"\(jsonString)\""
                    let escaped = escapeForJavaScript(doubleEncoded)
                    DashboardViewModel.escapedDemographicsJSONString = escaped
                }
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
extension DashboardViewModel {
    static func mock(with items: [Dashboard_Menu_Items]) -> DashboardViewModel {
        let vm = DashboardViewModel()
        
        // Convert Dashboard_Menu_Items back to MenuGroup format
        vm.menuGroups = items.map { item in
            let parent = MenuItem(
                id: 0,
                parentMenuId: 0, linkText: item.title,
                controller: "",
                action: nil,
                menuOrder: 0,
                className: "",
                target: "",
                queryStringData: "",
                apiKey: "",
                url: "",
                reportGuid: nil
            )
            
            let children = item.children?.map { child in
                MenuItem(
                   id: 0,
                   parentMenuId: 0, linkText: item.title,
                   controller: "",
                   action: nil,
                   menuOrder: 0,
                   className: "",
                   target: "",
                   queryStringData: "",
                   apiKey: "",
                   url: "",
                   reportGuid: nil
               )
            } ?? []
            
            return MenuGroup(parent: parent, children: children)
        }
        
        return vm
    }
}
