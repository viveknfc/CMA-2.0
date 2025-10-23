
import SwiftUI
import SSDateTimePicker

// MARK: - Enums
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
    
    var reasonID: Int {
        switch self {
        case .leftEarly: return 1
        case .arriveLate: return 2
        case .replacement: return 3
        case .askToWorkAdditional: return 4
        case .sentHome: return 5
        case .other: return 6
        }
    }
}

// MARK: - Extensions
extension String {
    /// Converts "yyyy-MM-dd'T'HH:mm:ss" to time with AM/PM
    func toTimeAMPM(inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        
        return outputFormatter.string(from: date)
    }
    
    func convert12HourTo24Hour() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

// MARK: - Time Calculator Helper
struct TimeCalculator {
    static func addTimes(start: String, end: String, min: Bool) -> Int {
        var startArray = start.components(separatedBy: ":")
        var endArray = end.components(separatedBy: ":")
        
        // Clean AM/PM from components
        for (index, component) in startArray.enumerated() {
            startArray[index] = component.replacingOccurrences(of: "AM", with: "")
                .replacingOccurrences(of: "PM", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        for (index, component) in endArray.enumerated() {
            endArray[index] = component.replacingOccurrences(of: "AM", with: "")
                .replacingOccurrences(of: "PM", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        guard startArray.count >= 2, endArray.count >= 2,
              let startHour = Int(startArray[0]),
              let startMin = Int(startArray[1]),
              let endHour = Int(endArray[0]),
              let endMin = Int(endArray[1]) else {
            return 0
        }
        
        let startMinutes = startHour * 60 + startMin
        let endMinutes = endHour * 60 + endMin
        
        var timeDifference = min ? startMinutes - endMinutes : endMinutes - startMinutes
        let day = 24 * 60
        
        if timeDifference < 0 {
            timeDifference += day
        }
        
        return timeDifference
    }
    
    static func convertMinutesToHoursAndMinutes(minutes: Int) -> (hours: Int, minutes: Int) {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return (hours, remainingMinutes)
    }
    
    static func isIrregularHours(totalMinutes: Int) -> Bool {
        return totalMinutes < 330 || totalMinutes > 810 // < 5.5h or > 13.5h
    }
}
 

// MARK: - Enhanced Checkbox Manager
class CheckboxManager: ObservableObject {
    @Published var selectedRecords: Set<Int> = []
    @Published var submissionArray: [[String: Any]] = []
    @Published var validationErrors: [String] = []
    
    var extraFields: [String: Any] = [:]
    var clientid: Int = 0
    var contactid: Int = 0
    var selectedReasons: [Int: ReasonType] = [:]
    var selectedStartTimes: [String: String] = [:]
    var selectedEndTimes: [String: String] = [:]
    @State var startSelectedTime: String?
    @State var endSelectedTime: String?
    
    func configure(clientID: Int, contactID: Int, reasons: [Int: ReasonType],
                  startTimes: [String: String], endTimes: [String: String]) {
        self.clientid = clientID
        self.contactid = contactID
        self.selectedReasons = reasons
        self.selectedStartTimes = startTimes
        self.selectedEndTimes = endTimes
        
        self.extraFields = [
            "clientId": clientID,
            "contactId": contactID,
            "startTimes": startTimes,
            "endTimes": endTimes
        ]
    }
    
    func toggleRecord(_ record: ECheckInAllResponse) {
        if selectedRecords.contains(record.id) {
            removeRecord(record)
        } else {
            if record.canBeSelected && record.isSubmitted == 0 {
                addRecord(record)
            }
        }
    }
    
    func addRecord(_ record: ECheckInAllResponse) {
        selectedRecords.insert(record.id)
        
        let ipAddress = MobileNetworkInfo.getLocalIPAddress() ?? ""
        let checkIn = selectedStartTimes[record.checkIn] ?? record.checkIn
        let checkOut = selectedEndTimes[record.checkOut] ?? record.checkOut
        
        let recordDict: [String: Any] = [
            "CandId": record.candID,
            "OrderId": record.orderID,
            "WeekEnd": record.weekEnd,
            "BillDate": record.billDate,
            "StartTime": record.startTime,
            "EndTime": record.endTime,
            "CheckIn": checkIn,
            "CheckOut": checkOut,
            "Type": 3,
            "RouteName": "iOS",
            "ClientId": clientid,
            "ContactId": contactid,
            "timeOut": "1900-01-01 00:00:00",
            "timeIn": "1900-01-01 00:00:00",
            "breakMinutes": record.breakMinutes,
            "totlaHours": record.totalHours,
            "RecCode": record.recCode,
            "PayforBreak": record.payforBreak ? 1 : 0,
            "Id": record.id,
            "longitude": 0.0,
            "latitude": 0.0,
            "Address": "Not Found",
            "IPAddress": ipAddress,
            "ReasonId": selectedReasons[record.id]?.reasonID ?? 0,
            "OtherReason": record.otherReason ?? "",
            "Retry": 0
        ]
        
        submissionArray.append(recordDict)
        print("✅ Added record \(record.id) to submission array. Total: \(submissionArray.count)")
    }
    
    func removeRecord(_ record: ECheckInAllResponse) {
        selectedRecords.remove(record.id)
        submissionArray.removeAll { dict in
            if let dictId = dict["Id"] as? Int {
                return dictId == record.id
            }
            return false
        }
        print("❌ Removed record \(record.id). Total: \(submissionArray.count)")
    }
    
    func validateSelection(records: [ECheckInAllResponse]) -> [String] {
        var invalidRecords: [String] = []
        
        for id in selectedRecords {
            if let record = records.first(where: { $0.id == id }) {
                let totalMinutes = record.totalHours * 60
                
                if TimeCalculator.isIrregularHours(totalMinutes: Int(totalMinutes)) {
                    if selectedReasons[record.id] == nil {
                        invalidRecords.append(record.candidateName ?? "Unknown")
                    }
                }
            }
        }
        
        return invalidRecords
    }
    
    func clearAll() {
        selectedRecords.removeAll()
        submissionArray.removeAll()
        validationErrors.removeAll()
        print("🧹 Cleared all selections")
    }
    
    func isSelected(_ recordID: Int) -> Bool {
        return selectedRecords.contains(recordID)
    }
    
    var hasSelectedRecords: Bool {
        return !selectedRecords.isEmpty
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
    let showStarValue: Int?
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

// MARK: - Header Components
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

// MARK: - Enhanced Record Card Component
struct RecordCardView: View {
    let record: ECheckInAllResponse
    let index: Int
    let config: RecordCardConfig
    @ObservedObject var checkboxManager: CheckboxManager
    
    @State private var individualRating: Int
    @State private var showInfoAlert = false
    @State private var calculatedTotalHours: String
    @State private var showReasonAlert = false
    
    @Binding var selectedStartTimes: [String: Time]
    @Binding var selectedEndTimes: [String: Time]
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    @Binding var showTimePicker: Bool
    @Binding var activeTimeType: TimeType
    @Binding var activeRecordKey: String
    @Binding var activeTime: Time
    
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    let onSave: (ECheckInAllResponse) -> Void
    let onDelete: (ECheckInAllResponse) -> Void
    let onFeedback: (ECheckInAllResponse, Int) -> Void
    let onReasonSave: (ECheckInAllResponse, ReasonType, String) -> Void
    
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
        
        self._individualRating = State(initialValue: record.rating ?? 0)
        
        // Calculate initial total hours
        let checkIn = record.checkIn.toTimeAMPM() ?? ""
        let checkOut = record.checkOut.toTimeAMPM() ?? ""
        let totalMinutes = TimeCalculator.addTimes(
            start: checkOut.convert12HourTo24Hour() ?? "00:00",
            end: checkIn.convert12HourTo24Hour() ?? "00:00",
            min: true
        )
        let (hours, minutes) = TimeCalculator.convertMinutesToHoursAndMinutes(minutes: totalMinutes)
        self._calculatedTotalHours = State(initialValue: "\(hours) H : \(minutes) M")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if config.showCheckbox {
                RecordHeaderView(record: record, checkboxManager: checkboxManager)
            } else {
                BasicRecordHeader(record: record)
            }
            
            EnhancedRecordDetailsView(
                record: record,
                individualRating: $individualRating,
                calculatedTotalHours: $calculatedTotalHours,
                showStarRating: config.showStarRating,
                onFeedback: { rating in onFeedback(record, rating) },
                onInfoTap: { showInfoAlert = true }
            )
            
            if config.showTimePickers && config.isEditable && shouldShowTimePickers {
                EnhancedTimePickersView(
                    record: record,
                    selectedStartTimes: $selectedStartTimes,
                    selectedEndTimes: $selectedEndTimes,
                    onTimePickerTap: onTimePickerTap,
                    onTimeChanged: recalculateTotalHours
                )
            }
            
            if config.showReasonDropdown && config.isEditable && shouldShowReasonDropdown {
                EnhancedReasonDropdownView(
                    record: record,
                    showReasonDropdown: $showReasonDropdown,
                    selectedReasons: $selectedReasons,
                    reasonComments: $reasonComments,
                    showReasonAlert: $showReasonAlert,
                    onReasonSave: onReasonSave
                )
            }
            
            if config.showActions && config.isEditable {
                EnhancedRecordActionsView(
                    record: record,
                    isSaveEnabled: isSaveButtonEnabled,
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
            Button("OK") { showInfoAlert = false }
        } message: {
            Text(record.ratingComments ?? "No Rating Comments")
        }
        .alert("Enter Other Reason", isPresented: $showReasonAlert) {
            TextField("Other Reason", text: Binding(
                get: { reasonComments[record.id] ?? "" },
                set: { reasonComments[record.id] = $0 }
            ))
            Button("Save") {
                if let reason = selectedReasons[record.id] {
                    onReasonSave(record, reason, reasonComments[record.id] ?? "")
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        
        DottedLine()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 8]))
            .foregroundColor(.gray)
            .frame(height: 1)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
    }
    
    private var shouldShowTimePickers: Bool {
        return record.isSubmitted == 0
    }
    
    private var shouldShowReasonDropdown: Bool {
        let totalMinutes = record.totalHours * 60
        return TimeCalculator.isIrregularHours(totalMinutes: Int(totalMinutes)) && record.isSubmitted == 0
    }
    
    private var isSaveButtonEnabled: Bool {
        if record.isSubmitted == 1 { return false }
        
        let totalMinutes = record.totalHours * 60
        if TimeCalculator.isIrregularHours(totalMinutes: Int(totalMinutes)) {
            return selectedReasons[record.id] != nil
        }
        
        return true
    }
    
    private func recalculateTotalHours() {
        let checkInTime = selectedStartTimes[record.checkIn]
        let checkOutTime = selectedEndTimes[record.checkOut]
        
        let checkIn = checkInTime != nil ? Date_Time_Formatter.formatTime(checkInTime!) : record.checkIn.toTimeAMPM() ?? ""
        let checkOut = checkOutTime != nil ? Date_Time_Formatter.formatTime(checkOutTime!) : record.checkOut.toTimeAMPM() ?? ""
        
        guard let checkIn24 = checkIn.convert12HourTo24Hour(),
              let checkOut24 = checkOut.convert12HourTo24Hour() else {
            return
        }
        
        let totalMinutes = TimeCalculator.addTimes(start: checkOut24, end: checkIn24, min: true)
        let (hours, minutes) = TimeCalculator.convertMinutesToHoursAndMinutes(minutes: totalMinutes)
        calculatedTotalHours = "\(hours) H : \(minutes) M"
    }
}

// MARK: - Enhanced Record Details View
struct EnhancedRecordDetailsView: View {
    let record: ECheckInAllResponse
    @Binding var individualRating: Int
    @Binding var calculatedTotalHours: String
    let showStarRating: Bool
    let onFeedback: (Int) -> Void
    let onInfoTap: () -> Void
    
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
            
            HStack {
                Text("Total Hours:")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                
                Text(calculatedTotalHours)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.label))
                
                Spacer()
            }
            
            BreakMinutesView(record: record)
        }
    }
}

struct StarRatingSectionIndividual: View {
    @Binding var rating: Int
    let onFeedback: (Int) -> Void
    let onInfoTap: () -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            StarRatingView(rating: $rating) { newRating in
                onFeedback(newRating)
            }
            
            Button {
                onInfoTap()
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Record Header Components
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
            checkboxManager.toggleRecord(record)
        }) {
            Image(systemName: checkboxIcon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(checkboxColor)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
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
        return isSelected ? .theme : .gray
    }
}

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

struct StatusIndicator: View {
    let isSubmitted: Bool
    
    var body: some View {
        Circle()
            .fill(isSubmitted ? Color.green : Color.orange)
            .frame(width: 8, height: 8)
    }
}

// MARK: - Record Info Components
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

// MARK: - Enhanced Time Pickers View
struct EnhancedTimePickersView: View {
    let record: ECheckInAllResponse
    @Binding var selectedStartTimes: [String: Time]
    @Binding var selectedEndTimes: [String: Time]
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    let onTimeChanged: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TimePickerButton(
                record: record,
                timeType: .start,
                placeholder: record.checkIn.toTimeAMPM() ?? "1:22 AM",
                selectedTime: selectedStartTimes[record.checkIn],
                onTap: {
                    onTimePickerTap(record, .start)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onTimeChanged()
                    }
                }
            )
            
            TimePickerButton(
                record: record,
                timeType: .end,
                placeholder: record.checkOut.toTimeAMPM() ?? "1:27 AM",
                selectedTime: selectedEndTimes[record.checkOut],
                onTap: {
                    onTimePickerTap(record, .end)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onTimeChanged()
                    }
                }
            )
        }
    }
}

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

// MARK: - Enhanced Reason Dropdown View
struct EnhancedReasonDropdownView: View {
    let record: ECheckInAllResponse
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    @Binding var showReasonAlert: Bool
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
                    isEnabled: selectedReasons[record.id] != nil,
                    onSave: {
                        if let selectedReason = selectedReasons[record.id] {
                            onReasonSave(record, selectedReason, reasonComments[record.id] ?? "")
                        }
                    }
                )
            }
            
            if let otherReason = record.otherReason, !otherReason.isEmpty {
                HStack {
                    Text("Other Reason:")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(otherReason)
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(6)
            }
            
            if showReasonDropdown[record.id] == true && record.isSubmitted == 0 {
                EnhancedReasonOptionsView(
                    record: record,
                    selectedReasons: $selectedReasons,
                    showReasonDropdown: $showReasonDropdown,
                    showReasonAlert: $showReasonAlert
                )
            }
        }
    }
}

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

struct SaveReasonButton: View {
    let record: ECheckInAllResponse
    let isEnabled: Bool
    let onSave: () -> Void
    
    var body: some View {
        Button(action: {
            if record.isSubmitted == 0 {
                onSave()
            }
        }) {
            Image(systemName: record.isSubmitted == 1 ? "lock.fill" : "square.and.arrow.down")
                .foregroundColor(record.isSubmitted == 1 ? .gray : (isEnabled ? .green : .gray))
                .font(.system(size: 16))
                .frame(width: 32, height: 32)
                .background(
                    (record.isSubmitted == 1 ? Color.gray.opacity(0.2) : (isEnabled ? Color.green.opacity(0.1) : Color.gray.opacity(0.1)))
                )
                .cornerRadius(6)
        }
        .disabled(record.isSubmitted == 1 || !isEnabled)
    }
}

struct EnhancedReasonOptionsView: View {
    let record: ECheckInAllResponse
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var showReasonAlert: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(ReasonType.allCases, id: \.self) { reason in
                Button(action: {
                    selectedReasons[record.id] = reason
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showReasonDropdown[record.id] = false
                    }
                    
                    // Auto-trigger alert for "Other"
                    if reason == .other {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showReasonAlert = true
                        }
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

// MARK: - Enhanced Record Actions View
struct EnhancedRecordActionsView: View {
    let record: ECheckInAllResponse
    let isSaveEnabled: Bool
    let onSave: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            DeleteButton(
                isEnabled: record.isSubmitted == 0,
                onDelete: onDelete
            )
            
            Spacer()
            
            Button(action: onSave) {
                Text("Save")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(isSaveEnabled ? Color(hex: "#111184") : Color(.systemGray4))
                    .cornerRadius(8)
            }
            .disabled(!isSaveEnabled)
            .opacity(isSaveEnabled ? 1.0 : 0.5)
        }
        .padding(.top, 8)
    }
}

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

// MARK: - Main OverAllUI View
struct OverAllUI: View {
    private let config: ECheckinConfig
    private let recordConfig: RecordCardConfig
    @StateObject private var checkboxManager = CheckboxManager()
    
    @State private var showDeleteAlert = false
    @State private var activeRecordForDeletion: ECheckInAllResponse?
    @State private var deleteCandidateName: String = ""
    @State private var textFieldAlert: TextFieldAlert?
    @State private var activeRecordForSave: ECheckInAllResponse?
    @State private var recordRatings: [String: Int] = [:]
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    
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
    
    @State private var userRating = 0
    @State private var feedbackText = ""
    @State private var savedRemark: String = ""
    
    @State private var showReasonDropdown: [Int: Bool] = [:]
    @State private var selectedReasons: [Int: ReasonType] = [:]
    @State private var reasonComments: [Int: String] = [:]
    
    @State private var showAlert = false
    @State private var startSelectedTime: String? = ""
    @State private var endSelectedTime: String? = ""
    
    @State var viewModel = OverallVM()
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    
    @Environment(\.scenePhase) private var scenePhase
    
    var isSubmitEnabled: Bool {
        !checkboxManager.selectedRecords.isEmpty
    }
    
    init(clientID: Int?, contactID: Int?, config: ECheckinConfig? = nil, recordConfig: RecordCardConfig? = nil) {
        self.config = config ?? ECheckinConfig(clientID: clientID, contactID: contactID)
        self.recordConfig = recordConfig ?? RecordCardConfig()
    }
    
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
            
            VStack(spacing: 0) {
                ECheckinHeaderView(
                    selectedDate: $startDate,
                    showDatePicker: $showDatePicker,
                    onGoButtonTap: handleGoButtonTap,
                    onSubmitTap: handleSubmitTap,
                    onInfoTap: handleInfoTap,
                    isSubmitEnabled: isSubmitEnabled
                )
                
                recordsScrollView
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 90)
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                TriangleLoader()
            }
            
            if viewModel.echeckallData.isEmpty && !viewModel.isLoading {
                VStack {
                    Text(viewModel.noDataMessage ?? "No overall data available")
                        .foregroundColor(.gray)
                        .font(.buttonFont)
                        .padding(.top)
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
                            refreshData()
                        },
                        dismiss: {
                            viewModel.showAlert = false
                            refreshData()
                        },
                        alertType: .success
                    )
                } else {
                    AlertView(
                        title: "EMA 2.0",
                        message: message,
                        primaryButton: AlertButtonConfig(title: "Retry") {
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
            
            // Validation Alert
            if showValidationAlert {
                AlertView(
                    title: "Validation Error",
                    message: validationMessage,
                    primaryButton: AlertButtonConfig(title: "OK") {
                        showValidationAlert = false
                    },
                    dismiss: {
                        showValidationAlert = false
                    },
                    alertType: .error
                )
            }
            
            overlayViews
        }
        .onAppear(perform: handleViewAppear)
        .onChange(of: scenePhase) { oldPhase, newPhase in
                   handleScenePhaseChange(newPhase)
        }
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
            TextFieldWrapper(alert: $textFieldAlert)
                .frame(width: 0, height: 0)
                .opacity(0)
        )
    }
    
    // MARK: - Records ScrollView
    private var recordsScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.echeckallData.enumerated()), id: \.element.id) { index, record in
                    RecordCardView(
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
                        onFeedback: handleFeedback,
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
            checkboxManager.clearAll()
            selectedReasons.removeAll()
            selectedStartTimes.removeAll()
            selectedEndTimes.removeAll()
            
            viewModel.fetchOverallDetails(
                contactId: "\(contactID)",
                clientId: "\(clientID)",
                weekEnd: Date_Time_Formatter.APIformatDate(startDate),
                errorHandler: errorHandler
            )
        }
    }
    
    private func handleSubmitTap() {
        // Validate before submitting
        let invalidRecords = checkboxManager.validateSelection(records: viewModel.echeckallData)
        
        if !invalidRecords.isEmpty {
            validationMessage = "Enter Irregular Hours Reason for:\n\(invalidRecords.joined(separator: ",\n"))"
            showValidationAlert = true
            checkboxManager.clearAll()
            return
        }
        
        // Convert selected times to strings
        var startTimesString: [String: String] = [:]
        var endTimesString: [String: String] = [:]
        
        for (key, time) in selectedStartTimes {
            startTimesString[key] = Date_Time_Formatter.formatTime(time)
        }
        
        for (key, time) in selectedEndTimes {
            endTimesString[key] = Date_Time_Formatter.formatTime(time)
        }
        
        // Update checkbox manager configuration
        checkboxManager.configure(
            clientID: config.clientID ?? 0,
            contactID: config.contactID ?? 0,
            reasons: selectedReasons,
            startTimes: startTimesString,
            endTimes: endTimesString
        )
        
        // Rebuild submission array with latest data
        checkboxManager.submissionArray.removeAll()
        for id in checkboxManager.selectedRecords {
            if let record = viewModel.echeckallData.first(where: { $0.id == id }) {
                checkboxManager.addRecord(record)
            }
        }
        
        Task {
            do {
                try await viewModel.overallSubmit(
                    params: checkboxManager.submissionArray,
                    errorHandler: errorHandler
                )
                
                checkboxManager.clearAll()
                try await refreshDataAsync()
            } catch {
                errorHandler.showError(message: error.localizedDescription, mode: .toast)
            }
        }
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
    
    private func handleSaveRecord(_ record: ECheckInAllResponse) {
        activeRecordForSave = record
        
        textFieldAlert = TextFieldAlert(
            title: "Save Record",
            message: "Enter reason for changing time:",
            placeholder: "Enter note..."
        ) { note in
            let noteText = note ?? ""
            let checkIn = selectedStartTimes[record.checkIn] != nil ?
                Date_Time_Formatter.formatTime(selectedStartTimes[record.checkIn]!) : record.checkIn
            let checkOut = selectedEndTimes[record.checkOut] != nil ?
                Date_Time_Formatter.formatTime(selectedEndTimes[record.checkOut]!) : record.checkOut
            
            viewModel.saveRecordDetails(
                response: record,
                contactId: String(config.contactID ?? 0),
                clientId: String(config.clientID ?? 0),
                checkin: checkIn,
                checkout: checkOut,
                note: noteText,
                errorHandler: errorHandler
            )
            
            activeRecordForSave = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                refreshData()
            }
        }
    }
    
    private func handleFeedback(for record: ECheckInAllResponse, rating: Int) {
        recordRatings["\(record.id)"] = rating
        
        if rating <= 2 {
            textFieldAlert = TextFieldAlert(
                title: "Enter Feedback",
                message: "Please provide your feedback for rating \(rating) stars",
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
            source: "2",
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            refreshData()
        }
    }
    
    private func handleReasonSave(_ record: ECheckInAllResponse, _ reason: ReasonType, _ comment: String) {
        viewModel.selectReasonDetails(
            responseData: record,
            reasonID: reason.reasonID,
            reasonType: reason.rawValue,
            reasonComment: comment,
            ClientId: config.clientID ?? 0,
            ContactId: config.contactID ?? 0,
            errorHandler: errorHandler
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            refreshData()
        }
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
        
        checkboxManager.configure(
            clientID: clientID,
            contactID: contactID,
            reasons: selectedReasons,
            startTimes: [:],
            endTimes: [:]
        )
    }
    
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            print("📱 App became active - refreshing data")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                refreshData()
            }
            
        case .background:
            print("📱 App entered background")
            
        case .inactive:
            break
            
        @unknown default:
            break
        }
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
    
    private func refreshDataAsync() async throws {
        guard let clientID = config.clientID,
              let contactID = config.contactID else {
            throw NSError(domain: "ConfigError", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Missing clientID or contactID"])
        }
        
        try await viewModel.fetchOverallDetails(
            contactId: String(contactID),
            clientId: String(clientID),
            weekEnd: Date_Time_Formatter.APIformatDate(Date()),
            errorHandler: errorHandler
        )
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
                let timeString = Date_Time_Formatter.formatTime(time)
                
                switch activeTimeType {
                case .start:
                    selectedStartTimes[activeRecordKey] = time
                    startSelectedTime = timeString
                case .end:
                    selectedEndTimes[activeRecordKey] = time
                    endSelectedTime = timeString
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .zIndex(10)
    }
}


// MARK: - Preview
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
            startTime: "2025-09-22T09:00:00",
            endTime: "2025-09-22T17:00:00",
            checkIn: "2025-09-22T09:05:00",
            checkOut: "2025-09-22T16:55:00",
            txnType: 1,
            routeName: "Morning Route",
            totalHours: 8,
            roundedTotalHours: 8,
            breakMinutes: 30,
            recCode: "S",
            payforBreak: true,
            position: "Warehouse Associate",
            isAdminUser: 0,
            status: 1,
            id: 1,
            reasonID: 0,
            reasonForTimeChange: "",
            additionalComments: "",
            isSubmitted: 0,
            otherReason: "",
            positionLabelColor: "#4A90E2",
            reportTo: "Manager",
            rating: 0,
            ratingComments: ""
        )

        view.viewModel.echeckallData = [mockRecord]
    }

    var body: some View {
        view.environmentObject(GlobalErrorHandler())
    }
}
