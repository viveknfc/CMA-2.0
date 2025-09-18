//
//  Candidate_Modal.swift
//  IntelliStaff_EMA
//
//  Created by NFC Solutions on 28/07/25.
//

//struct CandidateIdModel: Codable {
//    let candidateID: Int?
//    let name: String?
//    let lastName: String?
//    let firstName: String?
//    let middleName: String?
//    let address: String?
//    let city: String?
//    let state: String?
//    let zip: String?
//    let homePhone: String?
//    let cellPhone: String?
//    let eMail: String?
//    let minimumPay: Double?
//    let ssn: String?
//    let createdOn: String?
//    let dob: String?
//    let perRep: String?
//    let appSubmitDate: String?
//    let emergencyContactPhone: String?
//    let emergencyContactName: String?
//    let directDep: Bool?
//    let independentContractor: Bool?
//    let sendTextMsgs: Bool?
//    let needUpdated: Bool?
//    let netProfit: Double?
//    let i9Dob: String?
//    let paymentType: String?
//    let user: String?
//    let crime: String?
//    let divisionId: Int?
//    let applicantResumeId: Int?
//    let noPaystub: Bool?
//    let isPhotoUploaded: Bool?
//    let pushnotifications: Bool?
//    let locationtracking: Bool?
//    let i9DocumentsUploaded: Bool?
//    let overAllReferencePosition: Int?
//    let applicantId: Int?
//    let numberofOrders: Int?
//    let appType: String?
//    let isOnboardEmail: Bool?
//    let source: String?
//    let clientId: Int?
//    enum CodingKeys: String, CodingKey {
//        case candidateID = "CandidateID"
//        case name = "Name"
//        case lastName = "LastName"
//        case firstName = "FirstName"
//        case middleName = "MiddleName"
//        case address = "Address"
//        case city = "City"
//        case state = "State"
//        case zip = "Zip"
//        case homePhone = "HomePhone"
//        case cellPhone = "CellPhone"
//        case eMail = "EMail"
//        case minimumPay = "MinimumPay"
//        case ssn = "SSN"
//        case createdOn = "CreatedOn"
//        case dob = "Dob"
//        case perRep = "PerRep"
//        case appSubmitDate = "AppSubmitDate"
//        case emergencyContactPhone = "EmergencyContactPhone"
//        case emergencyContactName = "EmergencyContactName"
//        case directDep = "DirectDep"
//        case independentContractor = "IndependentContractor"
//        case sendTextMsgs = "SendTextMsgs"
//        case needUpdated = "NeedUpdated"
//        case netProfit = "NetProfit"
//        case i9Dob = "I9Dob"
//        case paymentType = "PaymentType"
//        case user = "User"
//        case crime = "Crime"
//        case divisionId = "DivisionId"
//        case applicantResumeId = "ApplicantResumeId"
//        case noPaystub = "NoPaystub"
//        case isPhotoUploaded = "IsPhotoUploaded"
//        case pushnotifications = "Pushnotifications"
//        case locationtracking = "Locationtracking"
//        case i9DocumentsUploaded = "I9DocumentsUploaded"
//        case overAllReferencePosition = "OverAllReferencePosition"
//        case applicantId = "ApplicantId"
//        case numberofOrders = "NumberofOrders"
//        case appType = "AppType"
//        case isOnboardEmail = "IsOnboardEmail"
//        case source = "source"
//        case clientId = "ClientId"
//    }
//}

@propertyWrapper
struct BoolOrInt: Codable {
    var wrappedValue: Bool?

    init(wrappedValue: Bool?) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            wrappedValue = boolValue
        } else if let intValue = try? container.decode(Int.self) {
            wrappedValue = (intValue != 0)
        } else if let stringValue = try? container.decode(String.self) {
            wrappedValue = (stringValue == "1" || stringValue.lowercased() == "true")
        } else {
            wrappedValue = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

@propertyWrapper
struct StringOrInt: Codable {
    var wrappedValue: String?

    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) {
            wrappedValue = str
        } else if let intVal = try? container.decode(Int.self) {
            wrappedValue = String(intVal)
        } else {
            wrappedValue = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}



struct CandidateIdModel: Codable {
    let name, companyName, repName, repPhone: String
       let repEmail, title, phone, ext: String
       let fax, addETo: String
       let master: Int
       let contactAddress: String
       let fl: JSONNull?
       let city, state, codeZip: String
       let noTsApproveConf, rosAuthorized, cwaTs, cwaInvoice: Int
       let cwaRpt, cwaEditBilling, division: Int
       let children: JSONNull?
       let office: Int
       let compName, companyAddress, companyCity, mainTelPhone: String
       let clientRepID: Int
       let suite: JSONNull?
       let companyState, companyCodeZip: String
       let consolidateMaster, hideIbInvoice, eTimeClock, noIbClient: Int
       let customType, billContactID, invFileType, invoiceType: Int
       let doNotServ, invoiceSendType, payByCompany: Int

       enum CodingKeys: String, CodingKey {
           case name = "Name"
           case companyName = "CompanyName"
           case repName = "RepName"
           case repPhone = "RepPhone"
           case repEmail = "RepEmail"
           case title = "Title"
           case phone = "Phone"
           case ext = "Ext"
           case fax = "Fax"
           case addETo = "AddETo"
           case master = "Master"
           case contactAddress = "ContactAddress"
           case fl = "Fl"
           case city = "City"
           case state = "State"
           case codeZip = "CodeZip"
           case noTsApproveConf = "NoTsApproveConf"
           case rosAuthorized = "RosAuthorized"
           case cwaTs = "CwaTs"
           case cwaInvoice = "CwaInvoice"
           case cwaRpt = "CwaRpt"
           case cwaEditBilling = "CwaEditBilling"
           case division = "Division"
           case children = "Children"
           case office = "Office"
           case compName = "CompName"
           case companyAddress = "CompanyAddress"
           case companyCity = "CompanyCity"
           case mainTelPhone = "MainTelPhone"
           case clientRepID = "ClientRepId"
           case suite = "Suite"
           case companyState = "CompanyState"
           case companyCodeZip = "CompanyCodeZip"
           case consolidateMaster = "ConsolidateMaster"
           case hideIbInvoice = "HideIbInvoice"
           case eTimeClock = "ETimeClock"
           case noIbClient = "NoIbClient"
           case customType = "CustomType"
           case billContactID = "BillContactId"
           case invFileType = "InvFileType"
           case invoiceType = "InvoiceType"
           case doNotServ = "DoNotServ"
           case invoiceSendType = "InvoiceSendType"
           case payByCompany = "PayByCompany"
       }
   }

  


struct CandidateInfo: Codable {
    let candidateId: Int
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let apartmentNumber: String?
    let city: String?
    let state: String?
    let zipCode: String?
    let email: String?
    let ssn: String?
    let dob: String?
    let permanentHomeAddress: String?
    let divisionId: Int?
    let skills: [Int]?
    let divisionName: String?
    let companyEmail: String?
    let empSince: String?
    let userdetails: UserDetails?
    let candidateType: Int?
    let maskedDOB: String?

    enum CodingKeys: String, CodingKey {
        case candidateId, firstName, middleName, lastName,
             apartmentNumber, city, state, zipCode, email, ssn,
             dob, permanentHomeAddress, divisionId, skills,
             divisionName, companyEmail, empSince, userdetails,
             candidateType, maskedDOB
    }
}

struct UserDetails: Codable {
    let name: String?
    let phone: String?
}

struct LoggedInInfo: Codable {
    let candidateId: Int
    let accessToken: String
    let applicantId: Int
    let companyEmail: String
    let division: Int
    let divisionName: String
    let email: String
    let firstName: String
    let id: Int
    let lastName: String
    let skills: [Int]
}

