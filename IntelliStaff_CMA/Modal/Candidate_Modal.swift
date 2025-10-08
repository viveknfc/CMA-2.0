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



// MARK: - Root
struct DashboardResponse: Decodable {
    let objCandidatesModel: CandidateIdModel
    let objMenuInformationList: [MenuItem]
    let objCandidateAssignmentsWithDetails: [CandidateAssignment]?

    enum CodingKeys: String, CodingKey {
        case objCandidatesModel = "objCandidatesModel"
        case objMenuInformationList = "objMenuInformationList"
        case objCandidateAssignmentsWithDetails = "objCandidateAssignmentsWithDetails"
    }
}



struct CandidateIdModel: Codable {
    let name, companyName, repName, repPhone: String
    let repEmail, title, phone, ext: String
    let fax, addETo: String
    let master: Int
    let contactAddress: String
    let fl: String?
    let city, state, codeZip: String
    let noTsApproveConf, rosAuthorized, cwaTs, cwaInvoice: Int
    let cwaRpt, cwaEditBilling: Int
    let division: Int?   // can be null or empty string
    let children: String?
    let office: Int?
    let compName, companyAddress, companyCity, mainTelPhone: String
    let clientRepID: Int?
    let suite: String?
    let companyState, companyCodeZip: String
    let consolidateMaster, hideIbInvoice, eTimeClock, noIbClient: Int?
    let customType, billContactID, invFileType, invoiceType: Int?
    let doNotServ, invoiceSendType, payByCompany: Int?

    enum CodingKeys: String, CodingKey {
        case name = "Name", companyName = "CompanyName", repName = "RepName", repPhone = "RepPhone"
        case repEmail = "RepEmail", title = "Title", phone = "Phone", ext = "Ext"
        case fax = "Fax", addETo = "AddETo", master = "Master"
        case contactAddress = "ContactAddress", fl = "Fl", city = "City", state = "State", codeZip = "CodeZip"
        case noTsApproveConf = "NoTsApproveConf", rosAuthorized = "RosAuthorized", cwaTs = "CwaTs", cwaInvoice = "CwaInvoice"
        case cwaRpt = "CwaRpt", cwaEditBilling = "CwaEditBilling", division = "Division"
        case children = "Children", office = "Office", compName = "CompName", companyAddress = "CompanyAddress"
        case companyCity = "CompanyCity", mainTelPhone = "MainTelPhone", clientRepID = "ClientRepId", suite = "Suite"
        case companyState = "CompanyState", companyCodeZip = "CompanyCodeZip"
        case consolidateMaster = "ConsolidateMaster", hideIbInvoice = "HideIbInvoice", eTimeClock = "ETimeClock", noIbClient = "NoIbClient"
        case customType = "CustomType", billContactID = "BillContactId", invFileType = "InvFileType", invoiceType = "InvoiceType"
        case doNotServ = "DoNotServ", invoiceSendType = "InvoiceSendType", payByCompany = "PayByCompany"
    }

    // Custom decoder to safely handle null or ""
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.companyName = try container.decode(String.self, forKey: .companyName)
        self.repName = try container.decode(String.self, forKey: .repName)
        self.repPhone = try container.decode(String.self, forKey: .repPhone)
        self.repEmail = try container.decode(String.self, forKey: .repEmail)
        self.title = try container.decode(String.self, forKey: .title)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.ext = try container.decode(String.self, forKey: .ext)
        self.fax = try container.decode(String.self, forKey: .fax)
        self.addETo = try container.decode(String.self, forKey: .addETo)
        self.master = try container.decode(Int.self, forKey: .master)
        self.contactAddress = try container.decode(String.self, forKey: .contactAddress)
        self.fl = try container.decodeIfPresent(String.self, forKey: .fl)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.codeZip = try container.decode(String.self, forKey: .codeZip)
        self.noTsApproveConf = try container.decode(Int.self, forKey: .noTsApproveConf)
        self.rosAuthorized = try container.decode(Int.self, forKey: .rosAuthorized)
        self.cwaTs = try container.decode(Int.self, forKey: .cwaTs)
        self.cwaInvoice = try container.decode(Int.self, forKey: .cwaInvoice)
        self.cwaRpt = try container.decode(Int.self, forKey: .cwaRpt)
        self.cwaEditBilling = try container.decode(Int.self, forKey: .cwaEditBilling)

        // 👇 safe int decoding (handles null and "")
        self.division = CandidateIdModel.decodeSafeInt(container, forKey: .division)
        self.office = CandidateIdModel.decodeSafeInt(container, forKey: .office)
        self.clientRepID = CandidateIdModel.decodeSafeInt(container, forKey: .clientRepID)
        self.customType = CandidateIdModel.decodeSafeInt(container, forKey: .customType)
        self.billContactID = CandidateIdModel.decodeSafeInt(container, forKey: .billContactID)
        self.invFileType = CandidateIdModel.decodeSafeInt(container, forKey: .invFileType)
        self.invoiceType = CandidateIdModel.decodeSafeInt(container, forKey: .invoiceType)
        self.doNotServ = CandidateIdModel.decodeSafeInt(container, forKey: .doNotServ)
        self.invoiceSendType = CandidateIdModel.decodeSafeInt(container, forKey: .invoiceSendType)
        self.payByCompany = CandidateIdModel.decodeSafeInt(container, forKey: .payByCompany)

        self.children = try container.decodeIfPresent(String.self, forKey: .children)
        self.compName = try container.decode(String.self, forKey: .compName)
        self.companyAddress = try container.decode(String.self, forKey: .companyAddress)
        self.companyCity = try container.decode(String.self, forKey: .companyCity)
        self.mainTelPhone = try container.decode(String.self, forKey: .mainTelPhone)
        self.suite = try container.decodeIfPresent(String.self, forKey: .suite)
        self.companyState = try container.decode(String.self, forKey: .companyState)
        self.companyCodeZip = try container.decode(String.self, forKey: .companyCodeZip)
        self.consolidateMaster = try container.decode(Int.self, forKey: .consolidateMaster)
        self.hideIbInvoice = try container.decode(Int.self, forKey: .hideIbInvoice)
        self.eTimeClock = try container.decode(Int.self, forKey: .eTimeClock)
        self.noIbClient = try container.decode(Int.self, forKey: .noIbClient)
    }

    private static func decodeSafeInt(_ container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) -> Int? {
        if let intVal = try? container.decodeIfPresent(Int.self, forKey: key) {
            return intVal
        }
        if let strVal = try? container.decodeIfPresent(String.self, forKey: key), let intVal = Int(strVal) {
            return intVal
        }
        return nil
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
    let skills: [Int]?
}

// MARK: - CandidateAssignment

struct CandidateAssignment: Codable {
    let orderWeekdayDetails: String?
    let orderId: Int?
    let startDate: String?
    let endDate: String?
    let position: String?
    let minPay: Double?
    let minbill: Double?
    let shifts: Int?
    let compName: String?
    let poNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case orderWeekdayDetails = "OrderWeekdayDetails"
        case orderId = "orderId"
        case startDate = "startDate"
        case endDate = "endDate"
        case position = "position"
        case minPay = "minPay"
        case minbill = "minbill"
        case shifts = "shifts"
        case compName = "Comp_Name"
        case poNumber = "PO_Number"
    }
}
