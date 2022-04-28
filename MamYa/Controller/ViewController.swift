//
//  ViewController.swift
//  MamYa
//
//  Created by Evelin Evelin on 25/04/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var tabBar: UITabBarItem!
    
    @IBOutlet weak var breakfastImg: UIImageView!
    @IBOutlet weak var lunchImg: UIImageView!
    @IBOutlet weak var dinnerImg: UIImageView!
    
    
    @IBOutlet weak var breakfastBtn: UIButton!
    @IBOutlet weak var lunchBtn: UIButton!
    @IBOutlet weak var dinnerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setTabBar()
        setImage()
        setBtn()
    }
    
//    func setTabBar(){
//        tabBar.title = "Home"
//        tabBar.image = UIImage(systemName: "house.fill")
//    }
    
    func setImage(){
        breakfastImg.image = #imageLiteral(resourceName: "breakfast-1")
        lunchImg.image = #imageLiteral(resourceName: "lunch")
        dinnerImg.image = #imageLiteral(resourceName: "dinner")
        
        breakfastImg.cornerRadius = breakfastImg.frame.height / 2
        lunchImg.cornerRadius = lunchImg.frame.height / 2
        dinnerImg.cornerRadius = dinnerImg.frame.height / 2
        
        breakfastImg.addoverlay()
        lunchImg.addoverlay()
        dinnerImg.addoverlay()
    }
    
    func setBtn(){
        breakfastBtn.setTitle("Breakfast", for: .normal)
        breakfastBtn.cornerRadius = breakfastBtn.frame.height / 2
        
        lunchBtn.setTitle("Lunch", for: .normal)
        lunchBtn.cornerRadius = lunchBtn.frame.height / 2
        
        dinnerBtn.setTitle("Dinner", for: .normal)
        dinnerBtn.cornerRadius = dinnerBtn.frame.height / 2
    }

    @IBAction func dinnerBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "dinnerSegue", sender: self)
    }

    @IBAction func lunchBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "lunchSegue", sender: self)
    }

    @IBAction func breakfastBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "breakfastSegue", sender: self)
    }
    
    //utk segue, supaya bisa kirim kirim data, tapi perlu perfoemSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination as! EatTimeController
        
        if(segue.identifier == "breakfastSegue"){
            view.viewIdentifier = "breakfast"
        }
        else if(segue.identifier == "lunchSegue"){
            view.viewIdentifier = "lunch"
        }
        else if(segue.identifier == "dinnerSegue"){
            view.viewIdentifier = "dinner"
        }
    }
    
}

