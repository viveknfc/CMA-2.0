//
//  Echeckin_View.swift
//  IntelliStaff_CMA
//
//  Created by ios on 14/08/25.
//

import SwiftUI
import SSDateTimePicker

enum ActiveAlert {
    case feedback
    case info
}


enum ReasonType: String, CaseIterable {
    case leftEarly = "Left Early"
    case arriveLate = "Arrive Late"
    case replacement = "Replacement"
    case askToWorkAdditional = "Ask to work additional time"
    case sentHome = "Sent Home"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}
extension String {
    /// Converts "yyyy-MM-dd'T'HH:mm:ss" to time with AM/PM
    func toTimeAMPM(inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"   // Example: "8:00 AM"
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        
        return outputFormatter.string(from: date)
    }
}

// MARK: - Checkbox Manager
class CheckboxManager: ObservableObject {
    @Published var selectedRecords: Set<Int> = []
    @Published var submissionArray: [[String: Any]] = []
    var extraFields: [String: Any] = [:]
    private let locationDataManager = LocationDataManager()
    @State var startSelectedTime:String?
    @State var endSelectedTime:String?
    var clientid:Int = 0
    var contactid:Int = 0
    // let division: DivisionList
//    func toggleRecord(_ record: ECheckInAllResponse) {
//        if selectedRecords.contains(record.id) {
//            // Remove from selection and submission array
//            removeRecord(record)
//        } else {
//            // Add to selection and submission array
//            addRecord(record, extraFields: extraFields)
//        }
//    }
    
    private func addRecord(_ record: ECheckInAllResponse, extraFields: [String: Any])  {
        selectedRecords.insert(record.id)
        
        let ipAddress = MobileNetworkInfo.getLocalIPAddress()
        
        do{
            let checkReq = CheckInRequest(candId: record.candID, orderId: record.orderID, type: 3, weekEnd: record.weekEnd, clientId: clientid, timeOut: record.checkOut ?? "1900-01-01 00:00:00", totlaHours: Int(record.totalHours), recCode: "S", payForBreak: 0, latitude: String(locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0), endTime: record.endTime, breakMinutes: record.breakMinutes, address: "\(locationDataManager.currentAddress ?? "")", checkIn: startSelectedTime ?? record.checkIn, retry: 0, contactId: contactid, longitude: String(locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0), billDate: record.billDate, startTime: record.startTime, ipAddress: ipAddress ?? "", checkOut: endSelectedTime ?? record.checkOut, routeName: "iOS", timeIn:record.checkIn ?? "1900-01-01 00:00:00", id: record.id, ReasonId: record.reasonID, OtherReason: "\(String(record.otherReason ?? ""))")
            
            
            if let recordDict = checkReq.asDictionary() {
                // 🔎 Log request for debugging
                if let jsonData = try? JSONSerialization.data(withJSONObject: recordDict, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("📤 Request JSON:\n\(jsonString)")
                    if record.isSubmitted == 0 {
                        submissionArray.append(recordDict)
                    }
                    print("Added record \(record.id) to submission array. Total count: \(submissionArray.count)")
                }
            }
        }catch{
        }
    }
    
    func removeRecord(_ record: ECheckInAllResponse) {
        selectedRecords.remove(record.id)
        submissionArray.removeAll { dict in
            if let dictId = dict["Id"] as? Int {
                return dictId == record.id
            }
            return false
        }
        print("Removed record \(record.id) from selection. Total count: \(submissionArray.count)")
    }
    
//    func isSelected(_ recordId: Int) -> Bool {
//        return selectedRecords.contains(recordId)
//    }
    
    func clearAll() {
        selectedRecords.removeAll()
        submissionArray.removeAll()
        print("Cleared all selections")
    }
    
    func getSubmissionData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: submissionArray, options: .prettyPrinted)
            print("Generated JSON data for \(submissionArray.count) records")
            return jsonData
        } catch {
            print("Error creating JSON data: \(error)")
            return nil
        }
    }
    
    var hasSelectedRecords: Bool {
        return !selectedRecords.isEmpty
    }
    
    var selectedCount: Int {
        return selectedRecords.count
    }
}


// 6. Make sure your CheckboxManager handles individual records correctly
extension CheckboxManager {
    func toggleRecord(_ record: ECheckInAllResponse) {
        print("Toggling record: \(record.id)")
        
        if selectedRecords.contains(record.id) {
            // Remove from selection
            removeRecord(record)
            print("Removed record \(record.id) from selection")
        } else {
            // Add to selection
            if record.canBeSelected && record.isSubmitted == 0 {
                addRecord(record, extraFields: extraFields)
                print("Added record \(record.id) to selection")
            }
        }
        
        print("Current selected records: \(selectedRecords)")
        print("Submission array count: \(submissionArray.count)")
    }
    
    func isSelected(_ recordID: Int) -> Bool {
        let isSelected = selectedRecords.contains(recordID)
        print("Checking if record \(recordID) is selected: \(isSelected)")
        return isSelected
    }
}

// MARK: - Configuration Models
struct ECheckinConfig {
    let clientID: Int?
    let contactID: Int?
    let initialDate: Date
    let canSubmit: Bool
    let canDelete: Bool
    let canSave: Bool
    
    init(clientID: Int?, contactID: Int?, initialDate: Date = Date(), canSubmit: Bool = true, canDelete: Bool = true, canSave: Bool = true) {
        self.clientID = clientID
        self.contactID = contactID
        self.initialDate = initialDate
        self.canSubmit = canSubmit
        self.canDelete = canDelete
        self.canSave = canSave
    }
}
struct RecordCardConfig {
    let showStarValue:Int?
    let showStarRating: Bool
    let showCheckbox: Bool
    let showReasonDropdown: Bool
    let showTimePickers: Bool
    let showActions: Bool
    let isEditable: Bool
    
    init(showStarRating: Bool = true, showCheckbox: Bool = true, showReasonDropdown: Bool = true, showTimePickers: Bool = true, showActions: Bool = true, isEditable: Bool = true) {
        self.showStarRating = showStarRating
        self.showCheckbox = showCheckbox
        self.showReasonDropdown = showReasonDropdown
        self.showTimePickers = showTimePickers
        self.showActions = showActions
        self.isEditable = isEditable
        self.showStarValue = 0
    }
}

// MARK: - Reusable Components

// 1. Header Component
struct ECheckinHeaderView: View {
    @Binding var selectedDate: Date?
    @Binding var showDatePicker: Bool
    let onGoButtonTap: () -> Void
    let onSubmitTap: () -> Void
    let onInfoTap: () -> Void
    let isSubmitEnabled: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                DatePickerButton(
                    selectedDate: $selectedDate,
                    showDatePicker: $showDatePicker
                )
                
                ActionButton(
                    title: "Go",
                    backgroundColor: Color(hex: "#111184"),
                    action: onGoButtonTap
                )
            }
            
            HStack {
                Spacer()
                
                ActionButton(
                    title: "Submit",
                    backgroundColor: isSubmitEnabled ? Color(hex: "#111184") : Color(.systemGray5),
                    textColor: isSubmitEnabled ? .white : Color(.systemGray2),
                    isEnabled: isSubmitEnabled,
                    action: onSubmitTap
                )
                
                Spacer()
                
                InfoButton(action: onInfoTap)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color(.white))
    }
}

// 2. Date Picker Button Component
struct DatePickerButton: View {
    @Binding var selectedDate: Date?
    @Binding var showDatePicker: Bool
    
    var body: some View {
        Button(action: { showDatePicker = true }) {
            HStack(spacing: 6) {
                Text(dateText)
                    .foregroundColor(selectedDate == nil ? Color(.systemGray) : Color(.label))
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "calendar")
                    .foregroundColor(Color(.theme))
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(hex: "#778da9"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
    
    private var dateText: String {
        if let date = selectedDate {
            return Date_Time_Formatter.formattedDate(date)
        }
        return "Enter Date"
    }
}

// 3. Action Button Component
struct ActionButton: View {
    let title: String
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var isEnabled: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .disabled(!isEnabled)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(textColor)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

// 4. Info Button Component
struct InfoButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray3))
        }
    }
}

// 5. Record Card Component
struct RecordCardView: View {
    let record: ECheckInAllResponse
    let index: Int
    let config: RecordCardConfig
    @ObservedObject var checkboxManager: CheckboxManager
    
    // Individual state for this specific record
    @State private var individualRating: Int
    @State private var showInfoAlert = false
    
    // Other bindings remain the same...
    @Binding var selectedStartTimes: [String: Time]
    @Binding var selectedEndTimes: [String: Time]
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    @Binding var showTimePicker: Bool
    @Binding var activeTimeType: TimeType
    @Binding var activeRecordKey: String
    @Binding var activeTime: Time
    
    // Action callbacks
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    let onSave: (ECheckInAllResponse) -> Void
    let onDelete: (ECheckInAllResponse) -> Void
    let onFeedback: (ECheckInAllResponse, Int) -> Void
    let onReasonSave: (ECheckInAllResponse, ReasonType, String) -> Void
    
    // Initialize with record's rating
    init(
        record: ECheckInAllResponse,
        index: Int,
        config: RecordCardConfig,
        checkboxManager: CheckboxManager,
        selectedStartTimes: Binding<[String: Time]>,
        selectedEndTimes: Binding<[String: Time]>,
        showReasonDropdown: Binding<[Int: Bool]>,
        selectedReasons: Binding<[Int: ReasonType]>,
        reasonComments: Binding<[Int: String]>,
        showTimePicker: Binding<Bool>,
        activeTimeType: Binding<TimeType>,
        activeRecordKey: Binding<String>,
        activeTime: Binding<Time>,
        onTimePickerTap: @escaping (ECheckInAllResponse, TimeType) -> Void,
        onSave: @escaping (ECheckInAllResponse) -> Void,
        onDelete: @escaping (ECheckInAllResponse) -> Void,
        onFeedback: @escaping (ECheckInAllResponse, Int) -> Void,
        onReasonSave: @escaping (ECheckInAllResponse, ReasonType, String) -> Void
    ) {
        self.record = record
        self.index = index
        self.config = config
        self.checkboxManager = checkboxManager
        self._selectedStartTimes = selectedStartTimes
        self._selectedEndTimes = selectedEndTimes
        self._showReasonDropdown = showReasonDropdown
        self._selectedReasons = selectedReasons
        self._reasonComments = reasonComments
        self._showTimePicker = showTimePicker
        self._activeTimeType = activeTimeType
        self._activeRecordKey = activeRecordKey
        self._activeTime = activeTime
        self.onTimePickerTap = onTimePickerTap
        self.onSave = onSave
        self.onDelete = onDelete
        self.onFeedback = onFeedback
        self.onReasonSave = onReasonSave
        
        // Initialize individual rating from record
        self._individualRating = State(initialValue: record.rating ?? 0)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            if config.showCheckbox {
                RecordHeaderView(
                    record: record,
                    checkboxManager: checkboxManager
                )
            } else {
                BasicRecordHeader(record: record)
            }
            
            RecordDetailsViewIndividual(
                record: record,
                individualRating: $individualRating,
                showStarRating: config.showStarRating,
                onFeedback: { rating in
                    onFeedback(record, rating)
                },
                onInfoTap: {
                    showInfoAlert = true
                }
            )
            
            
            if config.showTimePickers && config.isEditable {
                TimePickersView(
                    record: record,
                    selectedStartTimes: selectedStartTimes,
                    selectedEndTimes: selectedEndTimes,
                    onTimePickerTap: onTimePickerTap
                )
            }
            
            if config.showReasonDropdown && config.isEditable {
                ReasonDropdownView(
                    record: record,
                    showReasonDropdown: $showReasonDropdown,
                    selectedReasons: $selectedReasons,
                    reasonComments: $reasonComments,
                    onReasonSave: onReasonSave
                )
            }
            
            if config.showActions && config.isEditable {
                RecordActionsView(
                    record: record,
                    onSave: { onSave(record) },
                    onDelete: { onDelete(record) }
                )
            }
        }
        .padding(16)
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(color: Color(.white).opacity(0.3), radius: 4, x: 0, y: 2)
        .alert("Remarks", isPresented: $showInfoAlert) {
            Button("OK") {
                showInfoAlert = false
            }
        } message: {
            Text("\(record.ratingComments ?? "No Rating Comments")")
        }
       
        DottedLine()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 8]))
            .foregroundColor(.gray)
            .frame(height: 1)
            .padding(.horizontal, 10)
            .padding(.bottom, 4)
            .padding(.top, 4)
    }
}


struct RecordDetailsViewIndividual: View {
    let record: ECheckInAllResponse
    @Binding var individualRating: Int
    let showStarRating: Bool
    let onFeedback: (Int) -> Void
    let onInfoTap: () -> Void // Add this parameter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if showStarRating {
                StarRatingSectionIndividual(
                    rating: $individualRating,
                    onFeedback: onFeedback,
                    onInfoTap: onInfoTap
                )
            }
            
            PositionView(record: record)
            ScheduleTimeView(record: record)
            TotalHoursView(record: record)
            BreakMinutesView(record: record)
        }
    }
}
//struct StarRatingSectionIndividual: View {
//    @Binding var rating: Int
//    let onFeedback: (Int) -> Void
//    
//    var body: some View {
//        HStack(spacing: 2) {
//            StarRatingView(rating: $rating) { newRating in
//                onFeedback(newRating)
//            }
//            
//            Button {
//                onFeedback(rating)
//            } label: {
//                Image(systemName: "info.circle")
//                    .foregroundColor(.gray)
//                    .padding(.leading, 4)
//            }
//        }
//        .padding(.vertical, 2)
//    }
//}
struct StarRatingSectionIndividual: View {
    @Binding var rating: Int
    let onFeedback: (Int) -> Void
    let onInfoTap: () -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            StarRatingView(rating: $rating) { newRating in
                onFeedback(newRating) // This will trigger feedback alert in parent
            }
            
            Button {
                onInfoTap() // This will trigger info alert in parent
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 2)
    }
}

// 6. Record Header with Checkbox
struct RecordHeaderView: View {
        let record: ECheckInAllResponse
        @ObservedObject var checkboxManager: CheckboxManager
        
        var body: some View {
            HStack {
                Text(record.candidateName ?? "Unknown")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                StatusIndicator(isSubmitted: record.isSubmitted == 1)
                
                Spacer()
                
                CheckboxView(
                    record: record,
                    checkboxManager: checkboxManager
                )
            }
        }
    
}

struct CheckboxView: View {
    let record: ECheckInAllResponse
    @ObservedObject var checkboxManager: CheckboxManager
    
    var body: some View {
        Button(action: {
            print("Checkbox tapped for record ID: \(record.id)")
            checkboxManager.toggleRecord(record)
        }) {
            HStack(spacing: 12) {
                Image(systemName: checkboxIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(checkboxColor)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .disabled(!record.canBeSelected)
        .opacity(record.canBeSelected ? 1.0 : 0.6)
    }
    
    private var isSelected: Bool {
        checkboxManager.isSelected(record.id)
    }
    
    private var checkboxIcon: String {
        if !record.canBeSelected {
            return "lock.fill"
        }
        return isSelected ? "checkmark.square.fill" : "square"
    }
    
    private var checkboxColor: Color {
        if !record.canBeSelected {
            return .gray
        }
        return isSelected ? .blue : .gray
    }
}


// 7. Basic Record Header (without checkbox)
struct BasicRecordHeader: View {
    let record: ECheckInAllResponse
    
    var body: some View {
        HStack {
            Text(record.candidateName ?? "Unknown")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            StatusIndicator(isSubmitted: record.isSubmitted == 1)
            
            Spacer()
        }
    }
}

// 8. Status Indicator Component
struct StatusIndicator: View {
    let isSubmitted: Bool
    
    var body: some View {
        Circle()
            .fill(isSubmitted ? Color.green : Color.orange)
            .frame(width: 8, height: 8)
    }
}

// 9. Checkbox Button Component
struct CheckboxButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .blue : Color(.systemGray3))
        }
    }
}

// 10. Record Details Component
struct RecordDetailsView: View {
    let record: ECheckInAllResponse
    @Binding var userRating: Int
    let showStarRating: Bool
    let onFeedback: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showStarRating {
                StarRatingSection(
                    rating: $userRating,
                    onFeedback: onFeedback
                )
            }
            
            PositionView(record: record)
            ScheduleTimeView(record: record)
            TotalHoursView(record: record)
            BreakMinutesView(record: record)
        }
    }
}

// 11. Star Rating Section
struct StarRatingSection: View {
    @Binding var rating: Int
    let onFeedback: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            StarRatingView(rating: $rating) { newRating in
                if newRating <= 2 {
                    onFeedback(newRating)
                }
            }
            
            Button {
                // onFeedback(rating)
                
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

// 12. Position View Component
struct PositionView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
        HStack(spacing: 8) {
            Text("Position:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text(record.position)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: record.positionLabelColor))
                .cornerRadius(4)
            
            Spacer()
        }
    }
}

// 13. Schedule Time View Component
struct ScheduleTimeView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
        HStack {
            Text("Schedule Time:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text("\(record.startTime.toTimeAMPM() ?? "") - \(record.endTime.toTimeAMPM() ?? "")")
                .font(.system(size: 14))
                .foregroundColor(Color(.label))
            
            Spacer()
        }
    }
}

// 14. Total Hours View Component
struct TotalHoursView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
        HStack {
            Text("Total Hours:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text("\(record.totalHours)")
                .font(.system(size: 14))
                .foregroundColor(Color(.label))
            
            Spacer()
        }
    }
}

// 15. Break Minutes View Component
struct BreakMinutesView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
        HStack {
            Text("Break Minutes:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text("\(record.breakMinutes)")
                .font(.system(size: 14))
                .foregroundColor(Color(.label))
            
            Spacer()
        }
    }
}

// 16. Time Pickers View Component
struct TimePickersView: View {
    let record: ECheckInAllResponse
    let selectedStartTimes: [String: Time]
    let selectedEndTimes: [String: Time]
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TimePickerButton(
                record: record,
                timeType: .start,
                placeholder: record.checkIn.toTimeAMPM() ?? "1:22 AM",
                selectedTime: selectedStartTimes[record.checkIn],
                onTap: { onTimePickerTap(record, .start) }
            )
            
            TimePickerButton(
                record: record,
                timeType: .end,
                placeholder: record.checkOut.toTimeAMPM() ?? "1:27 AM",
                selectedTime: selectedEndTimes[record.checkOut],
                onTap: { onTimePickerTap(record, .end) }
            )
        }
    }
}

// 17. Time Picker Button Component
struct TimePickerButton: View {
    let record: ECheckInAllResponse
    let timeType: TimeType
    let placeholder: String
    let selectedTime: Time?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(timeText)
                    .foregroundColor(selectedTime == nil ? Color(.black) : Color(.label))
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "clock.fill")
                    .foregroundColor(Color(.theme))
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: "#778da9"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemBlue), lineWidth: 1)
            )
        }
    }
    
    private var timeText: String {
        if let selectedTime = selectedTime {
            return Date_Time_Formatter.formatTime(selectedTime)
        }
        return placeholder
    }
}

// 18. Reason Dropdown Component
struct ReasonDropdownView: View {
    let record: ECheckInAllResponse
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    let onReasonSave: (ECheckInAllResponse, ReasonType, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                DropdownButton(
                    record: record,
                    showDropdown: showReasonDropdown[record.id] == true,
                    selectedReason: selectedReasons[record.id],
                    onTap: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showReasonDropdown[record.id] = !(showReasonDropdown[record.id] ?? false)
                        }
                    }
                )
                
                SaveReasonButton(
                    record: record,
                    onSave: {
                        if let selectedReason = selectedReasons[record.id] {
                            onReasonSave(record, selectedReason, reasonComments[record.id] ?? "")
                        }
                    }
                )
            }
            
            if showReasonDropdown[record.id] == true && record.isSubmitted == 0 {
                ReasonOptionsView(
                    record: record,
                    selectedReasons: $selectedReasons,
                    showReasonDropdown: $showReasonDropdown
                )
            }
        }
    }
}

// 19. Dropdown Button Component
struct DropdownButton: View {
    let record: ECheckInAllResponse
    let showDropdown: Bool
    let selectedReason: ReasonType?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(selectedReason?.displayName ?? "Reason For Irregular Hours")
                    .foregroundColor(selectedReason != nil ? Color(.label) : Color(.systemGray))
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                    .foregroundColor(Color(.systemGray2))
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .disabled(record.isSubmitted == 1)
        .opacity(record.isSubmitted == 1 ? 0.5 : 1)
    }
}

// 20. Save Reason Button Component
struct SaveReasonButton: View {
    let record: ECheckInAllResponse
    let onSave: () -> Void
    
    var body: some View {
        Button(action: {
            if record.isSubmitted == 0 {
                onSave()
            }
        }) {
            Image(systemName: record.isSubmitted == 1 ? "lock.fill" : "square.and.arrow.down")
                .foregroundColor(record.isSubmitted == 1 ? .gray : .green)
                .font(.system(size: 16))
                .frame(width: 32, height: 32)
                .background(
                    (record.isSubmitted == 1 ? Color.gray.opacity(0.2) : Color.green.opacity(0.1))
                )
                .cornerRadius(6)
        }
        .disabled(record.isSubmitted == 1)
    }
}

// 21. Reason Options View Component
struct ReasonOptionsView: View {
    let record: ECheckInAllResponse
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var showReasonDropdown: [Int: Bool]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(ReasonType.allCases, id: \.self) { reason in
                Button(action: {
                    selectedReasons[record.id] = reason
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showReasonDropdown[record.id] = false
                    }
                }) {
                    HStack {
                        Text(reason.displayName)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.label))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if selectedReasons[record.id] == reason {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .font(.system(size: 12, weight: .medium))
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                }
                .background(Color.white)
                
                if reason != ReasonType.allCases.last {
                    Divider().padding(.leading, 12)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 3, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

// 22. Record Actions View Component
struct RecordActionsView: View {
    let record: ECheckInAllResponse
    let onSave: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            DeleteButton(
                isEnabled: record.isSubmitted == 0,
                onDelete: onDelete
            )
            
            Spacer()
            
            SaveButton(
                isEnabled: record.isSubmitted == 0,
                onSave: onSave
            )
        }
        .padding(.top, 8)
    }
}

// 23. Delete Button Component
struct DeleteButton: View {
    let isEnabled: Bool
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onDelete) {
            Image(systemName: "trash.fill")
                .font(.system(size: 16))
                .foregroundColor(.red)
                .frame(width: 32, height: 32)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// 24. Save Button Component
struct SaveButton: View {
    let isEnabled: Bool
    let onSave: () -> Void
    
    var body: some View {
        Button(action: onSave) {
            Text("Save")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(isEnabled ? Color(hex: "#111184") : Color(.systemGray4))
                .cornerRadius(8)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}


// MARK: - Fixed OverAllUI Implementation
struct OverAllUI: View {
    // Configuration
    private let config: ECheckinConfig
    private let recordConfig: RecordCardConfig
    @StateObject private var checkboxManager = CheckboxManager()
    // Alert States - Properly organized
    @State private var showDeleteAlert = false
    @State private var activeRecordForDeletion: ECheckInAllResponse? = nil
    @State private var deleteCandidateName: String = ""
    @State private var textFieldAlert: TextFieldAlert? = nil
    @State private var activeRecordForSave: ECheckInAllResponse? = nil
    @State private var recordRatings: [String: Int] = [:] // recordID -> rating
   
    // Time and Date States
    @State private var showTimePicker = false
    @State private var selectedDate: Date = Date()
    @State private var startDate: Date? = Date()
    @State private var tappedDate: Date? = Date()
    @State private var showDatePicker = false
    @State private var activeTime: Time = Time()
    @State private var activeTimeType: TimeType = .start
    @State private var activeRecordKey: String = ""
    @State private var selectedStartTimes: [String: Time] = [:]
    @State private var selectedEndTimes: [String: Time] = [:]
    
    // Rating and Feedback States
    @State private var userRating = 0
    @State private var feedbackText = ""
    @State private var savedRemark: String = ""
    
    // Reason States
    @State private var showReasonDropdown: [Int: Bool] = [:]
    @State private var selectedReasons: [Int: ReasonType] = [:]
    @State private var reasonComments: [Int: String] = [:]
    
    // UI States
    @State private var showAlert = false
    @State private var startSelectedTime: String? = ""
    @State private var endSelectedTime: String? = ""
    
    @State var viewModel = OverallVM()
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    
    // Computed properties
    var isSubmitEnabled: Bool {
        !checkboxManager.selectedRecords.isEmpty
    }
    
    // Initializer
    init(clientID: Int?, contactID: Int?, config: ECheckinConfig? = nil, recordConfig: RecordCardConfig? = nil) {
        self.config = config ?? ECheckinConfig(clientID: clientID, contactID: contactID)
        self.recordConfig = recordConfig ?? RecordCardConfig()
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
                
            VStack(spacing: 0) {
                // Header
                ECheckinHeaderView(
                    selectedDate: $startDate,
                    showDatePicker: $showDatePicker,
                    onGoButtonTap: handleGoButtonTap,
                    onSubmitTap: handleSubmitTap,
                    onInfoTap: handleInfoTap,
                    isSubmitEnabled: isSubmitEnabled
                )
                
                // Records list
                recordsScrollView
                .frame(maxWidth: .infinity)
                .padding(.bottom, 90) // extra safe space for last element
            }
            
          
            
            // Loading indicator
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                TriangleLoader()
            }
            
            if viewModel.echeckallData.isEmpty {
                VStack {
                    Text(viewModel.noDataMessage ?? "No over all data available")
                        .foregroundColor(.gray)
                        .font(.buttonFont)
                        .padding(.top, 150)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // Alert handling
            if viewModel.showAlert, let message = viewModel.alertMessage {
                if viewModel.alertType == .success {
                    AlertView(
                        title: "EMA 2.0",
                        message: message,
                        primaryButton: AlertButtonConfig(title: "OK") {
                            viewModel.showAlert = false
                        },
                        dismiss: {
                            viewModel.showAlert = false
                        },
                        alertType: .success
                    )
                }else {
                    AlertView(
                        title: "EMA 2.0",
                        message: message,
                        primaryButton: AlertButtonConfig(title: "Retry") {
                            //                           if let firstItem = viewModel.echeckallData.first,
                            //                              let clientID = clientID,
                            //                              let contactID = contactID {
                            //                           }
                            viewModel.showAlert = false
                        },
                        secondaryButton: AlertButtonConfig(title: "Cancel") {
                            viewModel.showAlert = false
                        },
                        dismiss: {
                            viewModel.showAlert = false
                        },
                        alertType: .error
                    )
                }
            }
            // Overlays
            overlayViews
        }
        .onAppear(perform: handleViewAppear)
        // Alert modifiers
        .alert("Delete Record", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let record = activeRecordForDeletion {
                    performDelete(record)
                }
            }
            Button("Cancel", role: .cancel) {
                activeRecordForDeletion = nil
            }
        } message: {
            Text("Are you sure you want to delete this record for \(deleteCandidateName)?")
        }
        .background(
            // TextFieldAlert handling
            TextFieldWrapper(alert: $textFieldAlert)
                .frame(width: 0, height: 0)
                .opacity(0)
        )
        // ViewModel alerts
        .onChange(of: viewModel.showAlert) { showAlert in
            if showAlert {
                handleViewModelAlert()
            }
        }
        
        
    }
    
    // MARK: - Records ScrollView
    // 7. Update your main ScrollView in OverAllUI to use the fixed components
    private var recordsScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.echeckallData.enumerated()), id: \.element.id) { index, record in
                    RecordCardView( // Use the fixed version with individual rating
                        record: record,
                        index: index,
                        config: recordConfig,
                        checkboxManager: checkboxManager,
                        selectedStartTimes: $selectedStartTimes,
                        selectedEndTimes: $selectedEndTimes,
                        showReasonDropdown: $showReasonDropdown,
                        selectedReasons: $selectedReasons,
                        reasonComments: $reasonComments,
                        showTimePicker: $showTimePicker,
                        activeTimeType: $activeTimeType,
                        activeRecordKey: $activeRecordKey,
                        activeTime: $activeTime,
                        onTimePickerTap: handleTimePickerTap,
                        onSave: handleSaveRecord,
                        onDelete: handleDeleteRecord,
                        onFeedback: { record, rating in
                            handleFeedback(for: record, rating: rating)
                        },
                        onReasonSave: handleReasonSave
                    )
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
        }
    }
    
    // MARK: - Overlay Views
    private var overlayViews: some View {
        ZStack {
            if showDatePicker {
                datePickerOverlay
            }
            
            if showTimePicker {
                timePickerOverlay
            }
            
            if showAlert {
                CustomAlertView(show: $showAlert)
            }
        }
    }
    
    // MARK: - Action Handlers
    private func handleGoButtonTap() {
        guard let clientID = config.clientID,
              let contactID = config.contactID else {
            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
            return
        }
        
        if let startDate = tappedDate {
            viewModel.echeckallData.removeAll()
            viewModel.fetchOverallDetails(
                contactId: "\(contactID)",
                clientId: "\(clientID)",
                weekEnd: Date_Time_Formatter.APIformatDate(startDate),
                errorHandler: errorHandler
            )
        }
    }
    
    private func handleSubmitTap() {
        Task {
            do {
                try await viewModel.overallSubmit(
                    params: checkboxManager.submissionArray,
                    errorHandler: errorHandler
                )

                // After submit, refresh data
                try await refreshData()
            } catch {
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
    }

    private func refreshData() async throws {
        guard let clientID = config.clientID,
              let contactID = config.contactID else {
            throw NSError(domain: "ConfigError", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing clientID or contactID"])
        }

        try await viewModel.fetchOverallDetails(contactId: String(contactID), clientId: String(clientID), weekEnd: Date_Time_Formatter.APIformatDate(Date()), errorHandler: errorHandler)
    }


    
    private func handleInfoTap() {
        withAnimation {
            showAlert.toggle()
        }
    }
    
    private func handleTimePickerTap(_ record: ECheckInAllResponse, _ timeType: TimeType) {
        switch timeType {
        case .start:
            activeRecordKey = record.checkIn
        case .end:
            activeRecordKey = record.checkOut
        }
        activeTimeType = timeType
        showTimePicker = true
    }
    
    // MARK: - Fixed Save Handler
    private func handleSaveRecord(_ record: ECheckInAllResponse) {
        print("Save button tapped for record: \(record.candidateName ?? "Unknown")")
        
        activeRecordForSave = record
        
        textFieldAlert = TextFieldAlert(
            title: "Save Record",
            message: "Enter reason for changing time:",
            placeholder: "Enter note..."
        ) { note in
            let noteText = note ?? ""
            
            viewModel.saveRecordDetails(
                response: record,
                contactId: String(config.contactID ?? 0),
                clientId: String(config.clientID ?? 0),
                checkin: record.checkIn,
                checkout: record.checkOut,
                note: noteText,
                errorHandler: errorHandler
            )
            
            refreshData()
            activeRecordForSave = nil
        }
    }
    

    private func handleFeedback(for record: ECheckInAllResponse, rating: Int) {
        recordRatings["\(record.id)"] = rating
        
        if rating <= 2 {
            textFieldAlert = TextFieldAlert(
                title: "Enter Feedback",
                message: "",
                placeholder: "Enter your feedback..."
            ) { feedback in
                let feedbackText = feedback ?? ""
                savedRemark = feedbackText
                submitFeedback(record: record, rating: rating, feedback: feedbackText)
            }
        } else {
            submitFeedback(record: record, rating: rating, feedback: "Good rating: \(rating)/5")
        }
    }

    
    private func submitFeedback(record: ECheckInAllResponse, rating: Int, feedback: String) {
        viewModel.fetchFeedbackDeatils(
            clientId: "\(config.clientID ?? 0)",
            weekEnd: record.weekEnd,
            rating: String(rating),
            source: String(rating),
            CandId: "\(record.candID)",
            OrderId: "\(record.orderID)",
            comments: feedback,
            ClientContacts: String(config.contactID ?? 0),
            errorHandler: errorHandler
        )
    }

    
    private func handleDeleteRecord(_ record: ECheckInAllResponse) {
        activeRecordForDeletion = record
        deleteCandidateName = record.candidateName ?? "this candidate"
        showDeleteAlert = true
    }
    
    private func performDelete(_ record: ECheckInAllResponse) {
        viewModel.deleteRecords(
            responseData: record,
            contactId: String(config.contactID ?? 0),
            clientId: String(config.clientID ?? 0),
            errorHandler: errorHandler
        )
        
        checkboxManager.removeRecord(record)
        activeRecordForDeletion = nil
        refreshData()
    }
    
    private func handleReasonSave(_ record: ECheckInAllResponse, _ reason: ReasonType, _ comment: String) {
        viewModel.selectReasonDetails(
            responseData: record,
            reasonID: record.id,
            reasonType: reason.rawValue,
            reasonComment: comment,
            ClientId: config.clientID ?? 0,
            ContactId: config.contactID ?? 0,
            errorHandler: errorHandler
        )
    }
    
    private func handleViewAppear() {
        guard let clientID = config.clientID,
              let contactID = config.contactID else {
            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
            return
        }
        
        viewModel.fetchOverallDetails(
            contactId: "\(contactID)",
            clientId: "\(clientID)",
            weekEnd: Date_Time_Formatter.APIformatDate(Date()),
            errorHandler: errorHandler
        )
        
        
        
        
        // Configure checkbox manager
        checkboxManager.configure(
            clientID: clientID,
            contactID: contactID,
            startTime: startSelectedTime,
            endTime: endSelectedTime
        )
    }
    
    private func refreshData() {
        guard let clientID = config.clientID,
              let contactID = config.contactID else { return }
        
        viewModel.fetchOverallDetails(
            contactId: String(contactID),
            clientId: String(clientID),
            weekEnd: Date_Time_Formatter.APIformatDate(startDate ?? Date()),
            errorHandler: errorHandler
        )
    }
    
    private func handleViewModelAlert() {
        // Handle ViewModel alerts if needed
        if let message = viewModel.alertMessage {
            print("ViewModel Alert: \(message)")
        }
    }
    
    // MARK: - Overlay Implementations
    private var datePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { showDatePicker = false }
            
            VStack {
                Custom_Calander_View(
                    showDatePicker: $showDatePicker,
                    selectedDate: $selectedDate,
                    onDateSelection: { date in
                        selectedDate = date
                        startDate = date
                        tappedDate = date
                        showDatePicker = false
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
        }
        .zIndex(10)
    }
    
    private var timePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { showTimePicker = false }
            
            Custom_Timer(
                showTimePicker: $showTimePicker,
                selectedTime: $activeTime
            ) { time in
                switch activeTimeType {
                case .start:
                    selectedStartTimes[activeRecordKey] = time
                    startSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
                case .end:
                    selectedEndTimes[activeRecordKey] = time
                    endSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .zIndex(10)
    }
}

// MARK: - Fixed RecordCardView with Star Rating
struct RecordCardViewFixed: View {
    let record: ECheckInAllResponse
    let index: Int
    let config: RecordCardConfig
    @ObservedObject var checkboxManager: CheckboxManager
    
    // Bindings for interactive elements
    @Binding var selectedStartTimes: [String: Time]
    @Binding var selectedEndTimes: [String: Time]
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    @Binding var userRating: Int
    @Binding var showTimePicker: Bool
    @Binding var activeTimeType: TimeType
    @Binding var activeRecordKey: String
    @Binding var activeTime: Time
    
    // Action callbacks
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    let onSave: (ECheckInAllResponse) -> Void
    let onDelete: (ECheckInAllResponse) -> Void
    let onFeedback: (Int) -> Void
    let onReasonSave: (ECheckInAllResponse, ReasonType, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if config.showCheckbox {
                RecordHeaderView(
                    record: record,
                    checkboxManager: checkboxManager
                )
            } else {
                BasicRecordHeader(record: record)
            }
            
            // Fixed Record Details with Star Rating
            RecordDetailsViewFixed(
                record: record,
                userRating: $userRating,
                showStarRating: config.showStarRating,
                onFeedback: { rating in
                        onFeedback(rating)
                    }
            )
            
            if config.showTimePickers && config.isEditable {
                TimePickersView(
                    record: record,
                    selectedStartTimes: selectedStartTimes,
                    selectedEndTimes: selectedEndTimes,
                    onTimePickerTap: onTimePickerTap
                )
            }
            
            if config.showReasonDropdown && config.isEditable {
                ReasonDropdownView(
                    record: record,
                    showReasonDropdown: $showReasonDropdown,
                    selectedReasons: $selectedReasons,
                    reasonComments: $reasonComments,
                    onReasonSave: onReasonSave
                )
            }
            
            if config.showActions && config.isEditable {
                RecordActionsView(
                    record: record,
                    onSave: { onSave(record) },
                    onDelete: { onDelete(record) }
                )
            }
        }
        .padding(16)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Fixed Record Details with Star Rating
struct RecordDetailsViewFixed: View {
    let record: ECheckInAllResponse
    @Binding var userRating: Int
    let showStarRating: Bool
    let onFeedback: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showStarRating {
                StarRatingSectionFixed(
                    rating: $userRating,
                    onFeedback: onFeedback
                )
            }
            
            PositionView(record: record)
            ScheduleTimeView(record: record)
            TotalHoursView(record: record)
            BreakMinutesView(record: record)
        }
    }
}

// MARK: - Fixed Star Rating Section
struct StarRatingSectionFixed: View {
    @Binding var rating: Int
    let onFeedback: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            StarRatingView(rating: $rating) { newRating in
                onFeedback(newRating)
            }
            
            Button {
                onFeedback(rating)
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Enhanced CheckboxManager Configuration
extension CheckboxManager {
    func configure(clientID: Int, contactID: Int, startTime: String?, endTime: String?) {
        self.clientid = clientID
        self.contactid = contactID
        self.startSelectedTime = startTime
        self.endSelectedTime = endTime
        self.extraFields = [
            "clientId": clientID,
            "contactId": contactID,
            "startSelectedTime": startTime ?? "",
            "endSelectedTime": endTime ?? ""
        ]
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var view = OverAllUI(
        clientID: 12345,
        contactID: 67890,
        config: ECheckinConfig(clientID: 12345, contactID: 67890),
        recordConfig: RecordCardConfig()
    )

    init() {
        let mockRecord = ECheckInAllResponse(
            candID: 1,
            candidateName: "John Doe",
            orderID: 101,
            weekEnd: "09/22/2025",
            billDate: "09/22/2025",
            startTime: "09:00 AM",
            endTime: "05:00 PM",
            checkIn: "09:05 AM",
            checkOut: "04:55 PM",
            txnType: 1,
            routeName: "Morning Route",
            totalHours: 8,
            roundedTotalHours: 8,
            breakMinutes: 0,
            recCode: "4",
            payforBreak: true,
            position: "",
            isAdminUser: 0,
            status: 1,
            id: 0,
            reasonID: 0,
            reasonForTimeChange: "",
            additionalComments: "",
            isSubmitted: 0,
            otherReason: "",
            positionLabelColor: "",
            reportTo: "",
            rating: 0,
            ratingComments: ""
        )

        // ✅ Inject mock data into the VM
        view.viewModel.echeckallData = [mockRecord]
    }

    var body: some View {
        view.environmentObject(GlobalErrorHandler())
    }
}
