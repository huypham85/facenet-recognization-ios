//
//  DatePicker.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 22/10/2023.
//

import Foundation
import UIKit

class DateTimePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    // Reference from https://stackoverflow.com/questions/40878547/is-it-possible-to-have-uidatepicker-work-with-start-and-end-time
  
    var didSelectDates: ((_ start: Date, _ end: Date) -> Void)?
  
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    var selectedStartDate = Date()
    var selectedEndDate = Date()
    
    private var days = [Date]()
    private var startTimes = [Date]() {
        didSet {
            if startTimes.count > 0 {
                selectedStartDate = startTimes[0]
            }
        }
    }
    private var endTimes = [Date]() {
        didSet {
            if endTimes.count > 0 {
                selectedEndDate = endTimes[0]
            }
        }
    }
      
    let dayFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
  
    var inputView: UIView {
        return pickerView
    }
  
    func setup() {
        dayFormatter.dateFormat = "EE d MMM"
        timeFormatter.timeStyle = .short
        days = setDays()
        startTimes = setStartTimes()
        endTimes = setEndTimes()
        pickerView.tintColor = .white
    }
  
    // MARK: - UIPickerViewDelegate & DateSource
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return startTimes.count
        case 2:
            return endTimes.count
        default:
            return 0
        }
    }
  
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
    
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
    
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
    
        var text = ""
    
        switch component {
        case 0:
            text = getDayString(from: days[row])
        case 1:
            text = getTimeString(from: startTimes[row])
        case 2:
            text = getTimeString(from: endTimes[row])
        default:
            break
        }
    
        label.text = text
    
        return label
    }
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dayIndex = pickerView.selectedRow(inComponent: 0)
        let startTimeIndex = pickerView.selectedRow(inComponent: 1)
        let endTimeIndex = pickerView.selectedRow(inComponent: 2)
    
        guard days.indices.contains(dayIndex),
              startTimes.indices.contains(startTimeIndex),
              endTimes.indices.contains(endTimeIndex) else { return }

        let startTime = startTimes[startTimeIndex]
        let endTime = endTimes[endTimeIndex]
        
        selectedStartDate = startTime
        selectedEndDate = endTime
        didSelectDates?(startTime, endTime)
    }
  
    // MARK: - Private helpers
  
    private func getDays(of date: Date) -> [Date] {
        var dates = [Date]()
    
        let calendar = Calendar.current
    
        // first date
        var currentDate = date
    
        // adding 30 days to current date
        let oneMonthFromNow = calendar.date(byAdding: .day, value: 30, to: currentDate)
    
        // last date
        let endDate = oneMonthFromNow
    
        while currentDate <= endDate! {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
    
        return dates
    }
  
    private func getTimes(of date: Date) -> [Date] {
        var times = [Date]()
        var currentDate = date
    
        currentDate = Calendar.current.date(bySetting: .hour, value: 6, of: currentDate)!
        currentDate = Calendar.current.date(bySetting: .minute, value: 00, of: currentDate)!
    
        let calendar = Calendar.current
    
        let interval = 15
        var nextDiff = interval - calendar.component(.minute, from: currentDate) % interval
        var nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: currentDate) ?? Date()
    
        var hour = Calendar.current.component(.hour, from: nextDate)
    
        while hour < 23 {
            times.append(nextDate)
      
            nextDiff = interval - calendar.component(.minute, from: nextDate) % interval
            nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: nextDate) ?? Date()
      
            hour = Calendar.current.component(.hour, from: nextDate)
        }
    
        return times
    }
  
    private func setDays() -> [Date] {
        let today = Date()
        return getDays(of: today)
    }
  
    private func setStartTimes() -> [Date] {
        let today = Date()
        return getTimes(of: today)
    }
  
    private func setEndTimes() -> [Date] {
        let today = Date()
        return getTimes(of: today)
    }
  
    private func getDayString(from: Date) -> String {
        return dayFormatter.string(from: from)
    }
  
    private func getTimeString(from: Date) -> String {
        return timeFormatter.string(from: from)
    }
}

extension Date {
    static func buildTimeRangeString(startDate: Date, endDate: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE, MMM d, yyyy"

        let startTimeFormatter = DateFormatter()
        startTimeFormatter.dateFormat = "h:mm a"
    
        let endTimeFormatter = DateFormatter()
        endTimeFormatter.dateFormat = "h:mm a"
    
        return String(format: "%@ (%@ - %@)",
                      dayFormatter.string(from: startDate),
                      startTimeFormatter.string(from: startDate),
                      endTimeFormatter.string(from: endDate))
    }
}
