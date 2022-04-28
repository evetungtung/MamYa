//
//  EatTimeController.swift
//  MamYa
//
//  Created by Evelin Evelin on 26/04/22.
//

import UIKit

class EatTimeController: UIViewController{
    
    
    @IBOutlet weak var menuView: UIView!
    
    let notificationCenter = UNUserNotificationCenter.current()
    var isSettedBF: Bool!
    var isSettedLunch: Bool!
    var isSettedDinner: Bool!
    
    var notifs = [NotifModel]()
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    @IBOutlet weak var datePicker: UIDatePicker!


    var viewIdentifier: String!
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var setTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //req authori buat kasih notif.
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in
            if !permissionGranted {
                print("Permission Denied")
            }
        }
        
//        menuView.dropShadow()
        getData()
        setContent()
    }
    
    func setContent(){
        if(viewIdentifier == "breakfast"){
            setContentBreakfast()
        }
        else if (viewIdentifier == "lunch"){
            setContentLunch()
        }
        else if (viewIdentifier == "dinner"){
            setContentDinner()
        }
        
        img.cornerRadius = img.frame.height / 2
    }
    
    func setContentBreakfast(){
        viewTitle.text = "Breakfast"
        img.image = #imageLiteral(resourceName: "breakfast-1")
        setTimeLabel.text = "🍞 Set Your Breakfast Time"
        
        funFactLabel.text = "The word “Breakfast” means breaking the fast"
    }
    
    func setContentLunch(){
        viewTitle.text = "Lunch"
        img.image = #imageLiteral(resourceName: "lunch")
        setTimeLabel.text = "🍔 Set Your Lunch Time"
        
        funFactLabel.text = "The average time taken to eat lunch is roughly 15 minutes, according to researchers at the University of Westminster."
    }
    
    func setContentDinner(){
        viewTitle.text = "Dinner"
        img.image = #imageLiteral(resourceName: "dinner")
        setTimeLabel.text = "🍖 Set Your Dinner Time"

        funFactLabel.text = "The word “dinner” comes from the Old French word “disnar”, which in fact means “breakfast”."
    }
    
    
    func getData(){
        if let notifsData = defaults.data(forKey: "notifs"){
            do{
                //array of trip
                let notif = try decoder.decode([NotifModel].self, from: notifsData)
                //assign
                notifs = notif
                print("NOTIF: \(notifs.count)")
                for notif in notifs {
                    print("Notif: Id \(notif.id!)")
                }
            }
            catch{
                print("ERROR")
            }
        }
    }
    
    //Notif
    @IBAction func savePressed(_ sender: Any) {
        notificationCenter.getNotificationSettings { (settings) in
            //harus async
            DispatchQueue.main.async {
                let date = self.datePicker.date
                print("DATE: \(date)")
                let content = UNMutableNotificationContent()
                var idName: String?
                var id: Int?
                
                if(self.viewIdentifier == "breakfast"){
                    id = 0
                    idName = "breakfast"
                    self.isSettedBF = true
                    content.title = "Breakfast"
                    content.body = "Good Morning! It's time for breakfast"
                }
                else if(self.viewIdentifier == "lunch"){
                    id = 1
                    idName = "lunch"
                    self.isSettedLunch = true
                    content.title = "Lunch"
                    content.body = "Fill up your energy with food"
                }
                else if(self.viewIdentifier == "dinner"){
                    id = 2
                    idName = "dinner"
                    self.isSettedDinner = true
                    content.title = "Dinner"
                    content.body = "Don't forget to take your dinner"
                }
                                
                //UTK INSERT UPDATE DATENYA
//                var newData: Bool!
//                print("Data: 1 \(newData)")
//                if(self.notifs.isEmpty){
                    self.notifs.insert(NotifModel(id: id!, idName: idName!, isSetted: true, date: date), at: 0)
//                }
//                else{
//                    for notif in self.notifs {
//                        //masih salah karena dia lanjut loop sampe akhir, jadinya nanti dia akhirnya ikutin data terakhir
//                        if notif.id == id{
//                            newData = false
//                            notif.date = date
//                            print("Data: \(notif.id!) == \(id!) \(newData)")
////                            return
//                        }
//                        else {
//                            newData = true
//                            print("Data: \(notif.id!) != \(id!) \(newData)")
//                        }
//                    }
//
//                    print("Data: Id == Id RETURNED")
                    
//                    if newData {
//                        self.notifs.insert(NotifModel(id: id!, idName: idName!, isSetted: true, date: date), at: 0)
//                        print("Notif: Inserting new data \(id!)")
//                    }
//                }
                
                if let encodedUser = try? self.encoder.encode(self.notifs) {
                    self.defaults.set(encodedUser, forKey: "notifs")
                }
                
                //
                if(settings.authorizationStatus == .authorized) {
                    let dateComp = Calendar.current.dateComponents([.hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                    
                    for notif in self.notifs {
                        if(notif.idName == idName){
                            //utk delete notif sblmnya, dan update ke yang baru
                            if(notif.isSetted == true){
                                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [idName!])
                            }
                            let request = UNNotificationRequest(identifier: idName!, content: content, trigger: trigger)
                            self.notificationCenter.add(request) { error in
                                if error != nil {
                                    print("Error " + error.debugDescription)
                                    return
                                }
                            }
                            print("LOG: SETTED, \(request)" )
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

    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
