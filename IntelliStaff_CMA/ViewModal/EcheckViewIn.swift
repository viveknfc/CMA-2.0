import SwiftUI
import Foundation

@MainActor
@Observable
class ECheckVM {
    var echeckallData: [ECheckInAllResponse] = []
    var ratingData: [RatingResponse] = []
    var reasonData: [ReasonResponse] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var noDataMessage: String?
    var alertMessage: String?
    var showAlert: Bool = false
    var alertType: AlertType = .error
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
                ratingData = result
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
                    "CandId": "\(responseData.candID)",
                    "CheckIn": "\(responseData.checkIn)",
                    "CheckOut": "\(responseData.checkOut)",
                    "ClientId": ClientId,
                    "ContactId": ContactId,
                    "EndTime": "\(responseData.endTime)",
                    "Id": "\(responseData.id)",
                    "OrderId": "\(responseData.orderID)",
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
                    "latitude": coordinate.latitude,
                    "longitude": coordinate.longitude,
                    "timeIn": "1900-01-01T00:48:00",
                    "timeOut": "1900-01-01T08:46:00",
                    "totlaHours": 0
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
            do {
                let params: [String: Any] = ["CandId":responseData.candID, "OrderId":responseData.orderID, "WeekEnd":responseData.weekEnd, "BillDate":responseData.billDate, "StartTime":responseData.startTime, "EndTime": responseData.endTime, "CheckIn":responseData.checkIn, "CheckOut":responseData.checkOut, "Type":0, "RouteName":"iOS", "ClientId":clientId, "ContactId":contactId, "timeOut":"1900-01-01 00:00:00", "timeIn":"1900-01-01 00:00:00", "breakMinutes":responseData.breakMinutes, "totlaHours":responseData.totalHours, "RecCode":responseData.recCode, "PayforBreak":0, "Id":responseData.id, "longitude":coordinate.longitude, "latitude": coordinate.latitude, "Address":address, "IPAddress":getIPv4Address() ?? "Not Found"]
                print("Calling API ------> delete api")
                let (result, noDataMsg) = try await APIFunction.deleteCalling(params: params)
                ratingData = result
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
    
    func overallSubmit(params: [[String:Any]], errorHandler: GlobalErrorHandler){
        Task {
            isLoading = true
            do {
                print("Calling API ------> overall Submit")
                    let (result, noDataMsg) = try await APIFunction.overallSubmitCalling(params: params)
                    ratingData = result
                  //  print(ratingData)
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
    
    
    func saveRecordDetails(response:ECheckInAllResponse,contactId: String,clientId: String, checkin:String, checkout: String,  note: String, errorHandler: GlobalErrorHandler){
     
        Task {
            isLoading = true
            do {
                let locationManager = SimpleLocationManager()
                 
                let coordinate = try await locationManager.getLocation()
                print("✅ Got location: \(coordinate.latitude), \(coordinate.longitude)")
                let address = try await locationManager.getAddress()
                       print("Full address: \(address)")
                let params: [String: Any] = [
                   
                        "CandId": response.candID,
                        "OrderId": response.orderID,
                        "WeekEnd": response.weekEnd,  // ✅ keep only one
                        "BillDate": response.billDate,
                        "StartTime": response.startTime,
                        "EndTime": response.endTime,
                        "CheckIn": checkin ?? response.checkIn,
                        "CheckOut": checkout ??  response.checkOut,
                        "Type": 2,
                        "RouteName": response.routeName,
                        "ClientId": clientId,
                        "ContactId": contactId,
                        "timeOut": "1900-01-01 00:00:00",
                        "timeIn": "1900-01-01 00:00:00",
                        "breakMinutes": response.breakMinutes,
                        "totlaHours": response.totalHours,
                        "RecCode": response.recCode,
                        "PayforBreak": 0,
                        "Id": response.id,
                        "longitude": coordinate.longitude,
                        "latitude": coordinate.latitude,
                        "Address": address ?? "Not Found",
                        "ReasonForTimeChange": note ?? "",
                        "IPAddress": getIPv4Address() ?? "",
                        "Retry": 0
                    

                ]
                
                let (result, noDataMsg) = try await APIFunction.saveCalling(params: params)
                print("Calling API ------> save")
                self.ratingData = result
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
                self.alertType = .error
                self.showAlert = true
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
    }
    

}
