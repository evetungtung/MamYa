//
//  HistoryController.swift
//  MamYa
//
//  Created by Evelin Evelin on 27/04/22.
//

import UIKit

class HistoryController: UIViewController {
    @IBOutlet weak var img: UIImageView!
    
    var meals = [History]()
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
        
    @IBOutlet weak var categoryTextField: UITextField!
    var pickerView = UIPickerView()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setImage()
        setDatePicker()
        setCategoryPicker()
        
        //auto close pas tap screen
        let screenTapped = UITapGestureRecognizer(
            target: view,
            action: #selector(view.endEditing))

        //add gesturnya ke view
        view.addGestureRecognizer(screenTapped)
    }
    
    func setCategoryPicker(){
        pickerView.dataSource = self
        pickerView.delegate = self
        
        categoryTextField.text = Constant.categories[0].name
        categoryTextField.inputView = pickerView
    }
    
    func setImage(){
        img.image = #imageLiteral(resourceName: "burger-amico")
    }
    
    func getData(){
        if let mealListData = defaults.data(forKey: "mealHistory"){
            do{
                let meal = try decoder.decode([History].self, from: mealListData)
                meals = meal
                print("Meals In Insert \(meals.count)")
            }
            catch{
                print("ERROR")
            }
        }
    }
    
    func setDatePicker(){
        dateField.text = dateToString(date: Date())
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(updateDate(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        
        dateField.inputView = datePicker
    }
    
    func dateToString(date: Date) -> String{
        formatter.dateFormat = "E MMM dd, h:mm a"
        return formatter.string(from: date)
    }
    
    @objc func updateDate(datePicker: UIDatePicker){
        dateField.text = dateToString(date: datePicker.date)
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        meals.insert(History(name: nameField.text!, date: dateField.text!, category: categoryTextField.text!), at: 0)
        if let encodedUser = try? encoder.encode(meals) {
            defaults.set(encodedUser, forKey: "mealHistory")
        }
        
        self.dismiss(animated: true)

        print("Meals count \(meals.count)")
        NotificationCenter.default.post(name: Notification.Name("refreshTableViewData"), object: nil)
    }
    
}

extension HistoryController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Constant.categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = Constant.categories[row].name
    }
}
