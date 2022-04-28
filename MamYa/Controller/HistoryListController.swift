//
//  HistoryController.swift
//  MamYa
//
//  Created by Evelin Evelin on 26/04/22.
//

import UIKit

class HistoryListController: UIViewController{
    @IBOutlet weak var tbl: UITableView!
    
    var meals = [History]()
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
        
    @IBOutlet weak var emptyImg: UIImageView!
    @IBOutlet weak var emptyLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        tbl.dataSource = self
        tbl.delegate = self

        configureTable()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableViewData), name: Notification.Name("refreshTableViewData"), object: nil)
    }

    func configureTable(){
        if meals.isEmpty {
            emptyLbl.text = "You haven't add any meal"
            emptyImg.image = #imageLiteral(resourceName: "Choice-pana")

            emptyLbl.isHidden = false
            emptyImg.isHidden = false
            tbl.isHidden = true
        }
        else{
            emptyLbl.isHidden = true
            emptyImg.isHidden = true
            tbl.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @objc func refreshTableViewData (notification: NSNotification){
        print("LOG: notification")
        getData()
        configureTable()
    }
    
    func getData(){
        if let mealListData = defaults.data(forKey: "mealHistory"){
            do{
                let meal = try decoder.decode([History].self, from: mealListData)
                meals = meal
                tbl.reloadData()
                print("Meals \(meals.count)")
            }
            catch{
                print("ERROR")
            }
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        print("TEST")
    }
}

extension HistoryListController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        
        if let nameLabel = meals[indexPath.row].name,
           let categoryLabel = meals[indexPath.row].category,
           let dateLabel = meals[indexPath.row].date{
            cell.nameLabel.text = nameLabel
            cell.categoryLabel.text = categoryLabel
            cell.dateLabel.text = dateLabel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteConfirmation = UIAlertController(title: "Delete Meal?",
                                                       message: "This action will permanently remove your meal from list",
                                                       preferredStyle: .alert)
            
            //buat btn dalam alert
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.meals.remove(at: indexPath.row)
                if let encodedUser = try? self.encoder.encode(self.meals) {
                    self.defaults.set(encodedUser, forKey: "mealHistory")
                }
                
                self.tbl.deleteRows(at: [indexPath], with: .left)
                
                self.configureTable()
//                self.tbl.reloadData()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            deleteConfirmation.addAction(deleteAction)
            deleteConfirmation.addAction(cancelAction)
            
            self.present(deleteConfirmation, animated: true)

        }
    }
}
