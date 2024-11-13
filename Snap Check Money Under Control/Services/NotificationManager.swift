import SwiftUI
import UserNotifications

class NotificationManager {
    
    
    static func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set! ⏰")
                scheduleCheckNotifications()
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - DELETING NOTIFICATION ⏰🧨
    static func cancelAllNotifications(){
        let notificationCenter = UNUserNotificationCenter.current()
        NSLog("🧼 clear all pending notifications")
        
        if #available(iOS 17.0, *) {
            notificationCenter.removeAllPendingNotificationRequests()
        } else {
            notificationCenter.getPendingNotificationRequests(completionHandler: {notifications in
                let ids = notifications.map({$0.identifier})
                NSLog("notifications: \(ids)")
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
            })
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }

    static func scheduleCheckNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print("Notifications authorized ✅")
                NSLog("⏰ Notifications start setup")
                // Remove all pending notifications
                cancelAllNotifications()
                // Iterate over the array and schedule notifications
                for dayAndTime in AppConfig.daysAndTimesStr {
                    self.scheduleNotification(for: dayAndTime)
                }
                NSLog("⏰ Notifications set ✅😋")
            } else {
                print("Notifications not authorized 🧐🤡")
            }
        }
    }

    static func scheduleNotification(for dayAndTime: String) {
        // Split the input string into day and time components
        let components = dayAndTime.split(separator: "-")
        guard components.count == 2 else { return }
        
        let day = String(components[0])
        let time = String(components[1])

        // Split the time into hour and minute
        let timeComponents = time.split(separator: ":")
        guard timeComponents.count == 2 else { return }
        
        let hour = Int(timeComponents[0]) ?? 0
        let minute = Int(timeComponents[1]) ?? 0

        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Snap Checks"
        content.body = "Remember to Snap Checks 😉"

        // Setup the date components for scheduling the notification
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        // Set the weekday for the notification
        switch day {
            case "Monday":
                dateComponents.weekday = 2 // Monday
            case "Tuesday":
                dateComponents.weekday = 3 // Tuesday
            case "Wednesday":
                dateComponents.weekday = 4 // Wednesday
            case "Thursday":
                dateComponents.weekday = 5 // Thursday
            case "Friday":
                dateComponents.weekday = 6 // Friday
            case "Saturday":
                dateComponents.weekday = 7 // Saturday
            case "Sunday":
                dateComponents.weekday = 1 // Sunday
            default:
                return
        }

        // Calculate the time interval until the next occurrence of the specified day and time
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Find the next occurrence date based on the day and time
        var nextNotificationDate = calendar.nextDate(after: currentDate, matching: dateComponents, matchingPolicy: .nextTime)

        // If the next occurrence is in the past, we want the next week
        if let nextDate = nextNotificationDate, nextDate < currentDate {
            nextNotificationDate = calendar.date(byAdding: .weekOfYear, value: 1, to: nextDate)
        }

        guard let finalDate = nextNotificationDate else { return }

        // Calculate the time interval until the next notification
        let timeInterval = finalDate.timeIntervalSince(currentDate)

        // NSLog the date and time interval when the notification is set
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        NSLog("⏰ Notification will be triggered on: \(formatter.string(from: finalDate)) (Time Interval: \(timeInterval.rounded()) seconds)")

        // Create the notification trigger based on the time interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let stringId = UUID().uuidString
        print(stringId)
        // Create the notification request with a unique identifier
        let request = UNNotificationRequest(identifier: stringId, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                NSLog("🤡 Error scheduling notification for \(day) at \(hour):\(minute): \(error)")
            }
        }
    }
}
