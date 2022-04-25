//
//  ViewController.swift
//  MamYa
//
//  Created by Evelin Evelin on 25/04/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    
    let notificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var datePickerBreakfast: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in
            if !permissionGranted {
                print("Permission Denied")
            }
        }
//        saveTime()
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        notificationCenter.getNotificationSettings { (settings) in
            
            print("Submit pressed")
            
            DispatchQueue.main.async {
                let date = self.datePickerBreakfast.date
                
                if(settings.authorizationStatus == .authorized) {
                    let content = UNMutableNotificationContent()
                    content.title = "Breakfast"
                    content.body = "Notif for Breakfast"
                                    
                    let dateComp = Calendar.current.dateComponents([.hour, .minute], from: date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                    
                    self.notificationCenter.add(request) { error in
                        if error != nil {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                        let ac  = UIAlertController(title: "Scheduled", message: "At \(self.formattedDate(date: date))", preferredStyle: .alert)

                        ac.addAction(UIAlertAction(title: "OK", style: .default))

                        self.present(ac, animated: true)
                }
                else{
                    let ac  = UIAlertController(title: "Enable Notifications", message: "To use this, you must enable your notification!", preferredStyle: .alert)

                    let goToSettings = UIAlertAction(title: "Go To Settings", style: .default) { (_) in
                        guard let settingURL = URL(string: UIApplication.openSettingsURLString ) else{
                            return
                        }
                        if (UIApplication.shared.canOpenURL(settingURL)){
                            UIApplication.shared.open(settingURL)
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default))

                    self.present(ac, animated: true)
                }
            }
        }
    }
    
//
//    func saveTime(){
//        if datePickerBreakfast.endEditing(true) {
//
//        }
//    }
//
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

