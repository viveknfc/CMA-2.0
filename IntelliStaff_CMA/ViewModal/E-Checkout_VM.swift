//
//  E-Checkout_VM.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 16/08/25.
//

import Foundation

@MainActor
@Observable
class ECheckout_VM {
    
    var eCheckOutData: [ECheckinModal_Nw] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var noDataMessage: String?
    
    var alertMessage: String?
    var showAlert: Bool = false
    var alertType: AlertType = .error
    
    func fetchCheckOutData(clientId: String,contactId: String,weekEnd : String,errorHandler: GlobalErrorHandler) {
        Task {
            isLoading = true
            do {
                let params :[String:String] = ["ClientId":clientId,
                                               "ContactId":contactId,
                                               "WeekEnd":weekEnd]
                
                let (result, noDataMsg) = try await APIFunction.eCheckOutAPICalling(params: params)
                print("the result of e-checkOut API call is: \(result)")
                
                self.eCheckOutData = result
                self.noDataMessage = noDataMsg
                self.isLoading = false
            } catch {
                print("🔥 API Failed for check out: \(error)")
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
    }
    
    func checkOutSubmit(item: ECheckinModal_Nw,
                       clientId: Int,
                       contactId: Int,
                       type: String,
                       errorHandler: GlobalErrorHandler,
                       isRetry: Bool = false) {

        let locationManager = SimpleLocationManager()

        
        Task {
            do {
                isLoading = true
                
                let coordinate = try await locationManager.getLocation()
                let address = try await SimpleLocationManager.reverseGeocodeLocation(coordinate: coordinate)
                let now = Date_Time_Formatter.nowForServer()
                let ipAddress = MobileNetworkInfo.getLocalIPAddress()
                
                // Build request
                let params = CheckInRequest(
                    candId: item.candId,
                    orderId: item.orderId,
                    type: 1,
                    weekEnd: item.weekEnd,
                    clientId: clientId, //95017,//
                    timeOut: type == "OUT" ? now : "1900-01-01T00:00:00",
                    totlaHours: 0,
                    recCode: item.recCode,
                    payForBreak: 0,
                    latitude: coordinate.latitude, //11.0066731, //40.7644176,//
                    endTime: item.endTime,
                    breakMinutes: 0,
                    address: address,
                    checkIn: type == "IN" ? now : "0001-01-01T00:00:00",
                    retry: 0,
                    contactId: contactId,
                    longitude: coordinate.longitude, //76.9456552, -73.9937463,//
                    billDate: item.billDate,
                    startTime: item.startTime,
                    ipAddress: ipAddress,
                    checkOut: type == "OUT" ? now : "",
                    routeName: "iOS",
                    timeIn: type == "IN" ? now : "",
                    id: 0
                )
                
                // Convert & Call API
                if let dict = params.asDictionary() {
                    // 🔎 Log request for debugging
                    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("📤 Request JSON for check out submit :\n\(jsonString)")
                    }

                    let response = try await APIFunction.eCheckOutSubmitAPICalling(params: dict)
                    print("✅ API Success for check out:", response)
                    
                    let apiResponse = response[0]
                    
                    // 🔹 Handle Retry automatically
                    if apiResponse.retry == 1 && !isRetry {
                        print("🔁 Retrying API once automatically...")
                        self.checkOutSubmit(item: item,
                                           clientId: clientId,
                                           contactId: contactId,
                                           type: type,
                                           errorHandler: errorHandler,
                                           isRetry: true)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.alertMessage = apiResponse.message
                        
                        if apiResponse.statusCode == 1 {
                            // ✅ Success → Only one OK button
                            self.alertType = .success
                            self.showAlert = true
                            
                        } else if apiResponse.statusCode == 0 {
                            // ❌ Error → Show Retry + Cancel buttons
                            self.alertType = .error
                            self.showAlert = true
                        }
                    }
                } else {
                    print("❌ Failed to encode params")
                }
                
                self.isLoading = false
            } catch {
                print("❌ Location error: \(error.localizedDescription)")
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
                self.isLoading = false
            }
        }
    }
}
