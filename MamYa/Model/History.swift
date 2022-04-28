//
//  History.swift
//  MamYa
//
//  Created by Evelin Evelin on 27/04/22.
//

import Foundation

class History: Codable{
    var name: String?
    var date: String?
    var category: String?
    
    init(name: String, date:String, category: String){
        self.name = name
        self.date = date
        self.category = category
    }
}
