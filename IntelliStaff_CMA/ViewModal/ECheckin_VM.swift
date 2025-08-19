//
//  ECheckin_VM.swift
//  IntelliStaff_CMA
//
//  Created by ios on 14/08/25.
//

import SwiftUI

struct Employee: Identifiable {
    let id = UUID()  // <-- Required for Identifiable

    var isSelected: Bool = false
    var name: String
    var position: String
    var schedule: String
    var checkIn: String
    var checkOut: String
    var totalHours: String
    var breakMinutes: String
    var rating: Int  // If used with StarRatingView, consider changing to Int
}

class EmployeeViewModel: ObservableObject {
    @Published var employees: [Employee] = []

       init() {
           // Only for preview/demo
           self.employees = [
               Employee(
                   //id: UUID(),
                   name: "Charlie",
                   position: "Designer",
                   schedule: "11 AM - 7 PM",
                   checkIn: "11:00",
                   checkOut: "19:00",
                   totalHours: "8",
                   breakMinutes: "20",
                   rating: 3
               )
           ]
       }
//    func fetchEmployees() {
//        guard let url = URL(string: "https://your-api.com/employees") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else { return }
//            
//            do {
//                let decoded = try JSONDecoder().decode([Employee].self, from: data)
//                DispatchQueue.main.async {
//                    self.employees = decoded
//                }
//            } catch {
//                print("Decoding error: \(error)")
//            }
//        }.resume()
//    }
}
