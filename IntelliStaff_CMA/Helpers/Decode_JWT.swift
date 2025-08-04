//
//  Decode_JWT.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 20/07/25.
//

import SwiftUI

func decodeUserIdFromJWT(_ token: String) -> Int? {
    let segments = token.split(separator: ".")
    guard segments.count > 1 else { return nil }

    let payloadSegment = segments[1]
    var base64 = String(payloadSegment)

    // Pad base64 string
    let requiredLength = 4 * ((base64.count + 3) / 4)
    let paddingLength = requiredLength - base64.count
    if paddingLength > 0 {
        base64 += String(repeating: "=", count: paddingLength)
    }

    guard let data = Data(base64Encoded: base64),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        return nil
    }

    if let userIdString = json["userId"] as? String,
       let userId = Int(userIdString) {
        return userId
    }
    
    return nil
}

