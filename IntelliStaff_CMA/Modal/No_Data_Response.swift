//
//  No_Data_Response.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 19/08/25.
//

struct NoDataResponse: Codable {
    let message: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case statusCode = "StatusCode"
    }
}
