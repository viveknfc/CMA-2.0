//
//  Font.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 14/07/25.
//

import SwiftUI

extension Font {
    static func poppinsMedium(size: CGFloat) -> Font {
        return .custom("Poppins-Medium", size: size)
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return .custom("Poppins-Regular", size: size)
    }

    static let titleFont = Font.poppinsMedium(size: 16)
    static let bodyFont = Font.poppinsRegular(size: 12)
    static let buttonFont = Font.poppinsRegular(size: 14)
    static let size16RFont = Font.poppinsRegular(size: 16)
}


