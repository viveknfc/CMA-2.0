import SwiftUI
import Foundation

@MainActor
@Observable
class OverallVM {
    var echeckallData: [ECheckInAllResponse] = []
    var ratingData = [RatingResponse]()
    var overAll:OverallSubmitResponse?
    var reasonData: [ReasonResponse] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var noDataMessage: String?
    var alertMessage: String?
    var showAlert: Bool = false
    var alertType: AlertType = .error
private var checkboxManager = CheckboxManager()
    // ✅ use shared instance
    func fetchOverallDetails(
        contactId: String,
        clientId: String,
        weekEnd: String,
        errorHandler: GlobalErrorHandler
    ) {
        Task {
            isLoading = true
            do {
                let params: [String: String] = [
                    "ClientId": clientId,
                    "ContactId": contactId,
                    "WeekEnd": weekEnd
                ]
                print("Calling API ------> overall api")
                let (result, noDataMsg) = try await APIFunction.overallUICalling(params: params)
                self.echeckallData.removeAll()
                self.echeckallData = result
                self.noDataMessage = noDataMsg
                self.isLoading = false
            } catch {
                self.alertType = .error
                self.showAlert = true
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
    }
    
    
    func fetchFeedbackDeatils(clientId: String,
                              weekEnd: String,
                              rating:String,
                              source:String,
                              CandId:String,
                              OrderId:String,
                              comments:String,
                              ClientContacts:String,
                              errorHandler: GlobalErrorHandler){
        Task {
            isLoading = true
            do {
                let params: [String: String] = [
                    "WorkDate": "\(weekEnd)", "ClientId": "\(clientId)", "RatingComments": "\(comments)", "ClientContacts": "\(ClientContacts)", "CandId": "\(CandId)", "Source": "\(source)", "WeekEnd": "\(weekEnd)", "Rating": "\(source)", "OrderId": "\(OrderId)"
                ]
                print("Calling API ------> submit rating api")
                let (result, noDataMsg) = try await APIFunction.submitRatingCalling(params: params)
                ratingData.removeAll()
                ratingData.append(result)
                print(ratingData)
                DispatchQueue.main.async {
                    self.alertMessage = self.ratingData[0].message
                    
                    if self.ratingData[0].statusCode == 1 {
                        // ✅ Success → Only one OK button
                        self.alertType = .success
                        self.showAlert = true
                        
                    } else if self.ratingData[0].statusCode == 0 {
                        // ❌ Error → Show Retry + Cancel buttons
                        self.alertType = .error
                        self.showAlert = true
                    }
                }
                self.noDataMessage = noDataMsg
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
    }
    
    
    func selectReasonDetails(
        responseData: ECheckInAllResponse,
        reasonID: Int,
        reasonType: String,
        reasonComment: String,
        ClientId: Int,
        ContactId: Int,
        errorHandler: GlobalErrorHandler
    ) {
        Task {
            isLoading = true
            
            // Ensure authorization first
            let locationManager = SimpleLocationManager()
             
            let coordinate = try await locationManager.getLocation()
            print("✅ Got location: \(coordinate.latitude), \(coordinate.longitude)")
            let address = try await locationManager.getAddress()
                   print("Full address: \(address)")
            do {
                let params: [String: Any] = [
                    "Address": "\(address)",
                    "BillDate": "\(responseData.billDate)",
                    "CandidateId": responseData.candID,
                    "CheckIn": "\(responseData.checkIn)",
                    "CheckOut": "\(responseData.checkOut)",
                    "ClientId": ClientId,
                    "ContactId": ContactId,
                    "EndTime": "\(responseData.endTime)",
                    "Id": responseData.id,
                    "OrderId": responseData.orderID,
                    "OtherReason": reasonComment,
                    "PayforBreak": 0,
                    "ReasonId": reasonID,
                    "RecCode": "S",
                    "Retry": 0,
                    "RouteName": "IOS",
                    "StartTime": "\(responseData.startTime)",
                    "StatusCode": 0,
                    "Type": 3,
                    "WeekEnd": "\(responseData.weekEnd)",
                    "BreakMinutes": 0,
                    "Latitude": "\(coordinate.latitude)",
                    "Longitude": "\(coordinate.longitude)",
                    "TimeIn": "1900-01-01T00:48:00",
                    "TimeOut": "1900-01-01T08:46:00",
                    "TotlaHours": 0
                ]
                
                print("Reason: \(params)")
                print("Calling API ------> reason api")
                let (result, noDataMsg) = try await APIFunction.reasonAPICalling(params: params)
                reasonData = result
                DispatchQueue.main.async {
                    self.alertMessage = self.reasonData[0].message
                    
                    if self.reasonData[0].statusCode == 1 {
                        // ✅ Success → Only one OK button
                        self.alertType = .success
                        self.showAlert = true
                        
                    } else if self.reasonData[0].statusCode == 0 {
                        // ❌ Error → Show Retry + Cancel buttons
                        self.alertType = .error
                        self.showAlert = true
                    }
                }
                self.noDataMessage = noDataMsg
            } catch {
                self.errorMessage = error.localizedDescription
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
            
            self.isLoading = false
        }
    }

    
    func deleteRecords(responseData: ECheckInAllResponse,contactId: String,
                       clientId: String,errorHandler: GlobalErrorHandler){
        Task {
            isLoading = true
            let locationManager = SimpleLocationManager()
             
            let coordinate = try await locationManager.getLocation()
            print("✅ Got location: \(coordinate.latitude), \(coordinate.longitude)")
            let address = try await locationManager.getAddress()
                   print("Full address: \(address)")
            let ipAddress = MobileNetworkInfo.getLocalIPAddress()
            do {
                let params: [String: Any] = ["CandidateId":responseData.candID, "OrderId":responseData.orderID, "WeekEnd":responseData.weekEnd, "BillDate":responseData.billDate, "StartTime":responseData.startTime, "EndTime": responseData.endTime, "CheckIn":responseData.checkIn, "CheckOut":responseData.checkOut, "Type":0, "RouteName":"iOS", "ClientId":clientId, "ContactId":contactId, "timeOut":responseData.checkOut, "timeIn":responseData.checkIn, "breakMinutes":responseData.breakMinutes, "totlaHours":responseData.totalHours, "RecCode":responseData.recCode, "PayforBreak":0, "Id":responseData.id, "longitude":"\(coordinate.longitude)", "latitude": "\(coordinate.latitude)", "Address":address, "IPAddress":ipAddress ?? "Not Found"]
                print("Calling API ------> delete api")
                let (result, noDataMsg) = try await APIFunction.deleteCalling(params: params)
                ratingData.removeAll()
                ratingData = result
                print(ratingData)
                DispatchQueue.main.async {
                    if !self.ratingData.isEmpty{
                        self.alertMessage = self.ratingData[0].message
                        
                        if self.ratingData[0].statusCode == 1 {
                            // ✅ Success → Only one OK button
                            self.alertType = .success
                            self.showAlert = true
                            
                        } else if self.ratingData[0].statusCode == 0 {
                            // ❌ Error → Show Retry + Cancel buttons
                            self.alertType = .error
                            self.showAlert = true
                        }
                    }
                }
                self.noDataMessage = noDataMsg
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
        
    }
    
    func overallSubmit(params: [[String:Any]], errorHandler: GlobalErrorHandler){
        
        Task {
            isLoading = true
            do {
                print("Calling API ------> overall Submit \(params)")
                    let (result, noDataMsg) = try await APIFunction.overallSubmitCalling(params: params)
               
                overAll = result
                  //  print(ratingData)
                    DispatchQueue.main.async {
                        self.alertMessage = self.overAll?.message
                        
                        if self.overAll?.statusCode == 1 {
                            // ✅ Success → Only one OK button
                            self.alertType = .success
                            self.showAlert = true
                            
                            // 🔄 Reset checkboxes after successful submit
                                              self.checkboxManager.clearAll()
                            // 🔄 Refresh the available list
//                               Task {
//                                   await self.fetchOverallDetails(contactId: "", clientId: "", weekEnd: "", errorHandler: errorHandler)
//                               }
                        } else if self.overAll?.statusCode == 0 {
                            // ❌ Error → Show Retry + Cancel buttons
                            self.alertType = .error
                            self.showAlert = true
                        }
                    }
                    self.noDataMessage = noDataMsg
                    self.isLoading = false
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
    }
    
    
    func saveRecordDetails(response:ECheckInAllResponse,contactId: String,clientId: String, checkin:String, checkout: String,  note: String, errorHandler: GlobalErrorHandler){
     
        Task {
            isLoading = true
            do {
                let locationManager = SimpleLocationManager()
                let ipAddress = MobileNetworkInfo.getLocalIPAddress()
                let coordinate = try await locationManager.getLocation()
                print("✅ Got location: \(coordinate.latitude), \(coordinate.longitude)")
                let address = try await locationManager.getAddress()
                       print("Full address: \(address)")
                
                
                let params = CheckInRequest(candId: response.candID, orderId: response.orderID, type: 0, weekEnd: response.weekEnd, clientId: Int(clientId) ?? 0, timeOut: "1900-01-01T09:00:00", totlaHours: Int(response.totalHours), recCode: "S", payForBreak: 0, latitude: "\(coordinate.latitude)", endTime: "\(response.endTime)", breakMinutes: response.breakMinutes, address: address, checkIn: "\(response.checkIn)", retry: 0, contactId: Int(contactId) ?? 0, longitude: "\(coordinate.longitude)", billDate: response.billDate, startTime: "\(response.startTime)", ipAddress: ipAddress ?? "", checkOut:"\(response.checkOut)", routeName: "iOS", timeIn: "1900-01-01T09:00:00", id: response.id, ReasonId: 0, OtherReason: "")
                
                
                
                if let dict = params.asDictionary() {
                    let additionalData: [String: Any] = [
                           "ReasonForTimeChange": "\(note)",
                       ]
                       
                       // Merge dictionaries
                       let mergedDict = dict.merging(additionalData) { (original, new) in
                           return new  // In case of key conflicts, use the new value
                       }
                    
                    // 🔎 Log request for debugging
                    if let jsonData = try? JSONSerialization.data(withJSONObject: mergedDict, options: .prettyPrinted),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("📤 Request JSON:\n\(jsonString)")
                    }
                    
                    
                    
                    
                    //                let params: [String: Any] = [
                    //
                    //                        "CandId": response.candID,
                    //                        "OrderId": response.orderID,
                    //                        "WeekEnd": response.weekEnd,  // ✅ keep only one
                    //                        "BillDate": response.billDate,
                    //                        "StartTime": response.startTime,
                    //                        "EndTime": response.endTime,
                    //                        "CheckIn": checkin ?? response.checkIn,
                    //                        "CheckOut": checkout ??  response.checkOut,
                    //                        "Type": 2,
                    //                        "RouteName": response.routeName,
                    //                        "ClientId": clientId,
                    //                        "ContactId": contactId,
                    //                        "TimeOut": "1900-01-01 00:00:00",
                    //                        "TimeIn": "1900-01-01 00:00:00",
                    //                        "BreakMinutes": response.breakMinutes,
                    //                        "TotlaHours": response.totalHours,
                    //                        "RecCode": response.recCode,
                    //                        "PayforBreak": 0,
                    //                        "Id": response.id,
                    //                        "Longitude": coordinate.longitude,
                    //                        "Latitude": coordinate.latitude,
                    //                        "Address": address ?? "Not Found",
                    //                        "ReasonForTimeChange": note ?? "",
                    //                        "IPAddress": ipAddress ?? "",
                    //                        "Retry": 0
                    //
                    //
                    //                ]
                    
                    let (result, noDataMsg) = try await APIFunction.saveCalling(params: dict)
                    print("Calling API ------> save")
                    self.ratingData.removeAll()
                    self.ratingData.append(result)
                    DispatchQueue.main.async {
                        self.alertMessage = self.ratingData[0].message
                        
                        if self.ratingData[0].statusCode == 1 {
                            // ✅ Success → Only one OK button
                            self.alertType = .success
                            self.showAlert = true
                           // self.fetchOverallDetails(contactId: contactId, clientId: clientId, weekEnd: <#T##String#>, errorHandler: GlobalErrorHandler())
                            
                        } else if self.ratingData[0].statusCode == 0 {
                            // ❌ Error → Show Retry + Cancel buttons
                            self.alertType = .error
                            self.showAlert = true
                        }
                    }
                    self.noDataMessage = noDataMsg
                    self.isLoading = false
                }
            } catch {
                self.alertType = .error
                self.showAlert = true
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
    }
    

}
