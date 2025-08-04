//
//  Candidate_Modal.swift
//  IntelliStaff_EMA
//
//  Created by NFC Solutions on 28/07/25.
//

struct CandidateIdModel: Decodable {
    let candidateID: Int?
    let name: String?
    let lastName: String?
    let firstName: String?
    let middleName: String?
    let address: String?
    let city: String?
    let state: String?
    let zip: String?
    let homePhone: String?
    let cellPhone: String?
    let eMail: String?
    let minimumPay: Double?
    let ssn: String?
    let createdOn: String?
    let dob: String?
    let perRep: String?
    let appSubmitDate: String?
    let emergencyContactPhone: String?
    let emergencyContactName: String?
    let directDep: Bool?
    let independentContractor: Bool?
    let sendTextMsgs: Bool?
    let needUpdated: Bool?
    let netProfit: Double?
    let i9Dob: String?
    let paymentType: String?
    let user: String?
    let crime: String?
    let divisionId: Int?
    let applicantResumeId: Int?
    let noPaystub: Bool?
    let isPhotoUploaded: Bool?
    let pushnotifications: Bool?
    let locationtracking: Bool?
    let i9DocumentsUploaded: Bool?
    let overAllReferencePosition: Int?
    let applicantId: Int?
    let numberofOrders: Int?
    let appType: String?
    let isOnboardEmail: Bool?
    let source: String?
    
    enum CodingKeys: String, CodingKey {
        case candidateID = "CandidateID"
        case name = "Name"
        case lastName = "LastName"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case address = "Address"
        case city = "City"
        case state = "State"
        case zip = "Zip"
        case homePhone = "HomePhone"
        case cellPhone = "CellPhone"
        case eMail = "EMail"
        case minimumPay = "MinimumPay"
        case ssn = "SSN"
        case createdOn = "CreatedOn"
        case dob = "Dob"
        case perRep = "PerRep"
        case appSubmitDate = "AppSubmitDate"
        case emergencyContactPhone = "EmergencyContactPhone"
        case emergencyContactName = "EmergencyContactName"
        case directDep = "DirectDep"
        case independentContractor = "IndependentContractor"
        case sendTextMsgs = "SendTextMsgs"
        case needUpdated = "NeedUpdated"
        case netProfit = "NetProfit"
        case i9Dob = "I9Dob"
        case paymentType = "PaymentType"
        case user = "User"
        case crime = "Crime"
        case divisionId = "DivisionId"
        case applicantResumeId = "ApplicantResumeId"
        case noPaystub = "NoPaystub"
        case isPhotoUploaded = "IsPhotoUploaded"
        case pushnotifications = "Pushnotifications"
        case locationtracking = "Locationtracking"
        case i9DocumentsUploaded = "I9DocumentsUploaded"
        case overAllReferencePosition = "OverAllReferencePosition"
        case applicantId = "ApplicantId"
        case numberofOrders = "NumberofOrders"
        case appType = "AppType"
        case isOnboardEmail = "IsOnboardEmail"
        case source = "source"
    }
}

