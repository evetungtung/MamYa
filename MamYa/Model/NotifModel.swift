//
//  NotifModel.swift
//  MamYa
//
//  Created by Evelin Evelin on 26/04/22.
//

import Foundation

class NotifModel: Codable{
    var id: Int?
    var idName: String?
    var isSetted: Bool?
    var date: Date?

    init(id: Int, idName: String, isSetted:Bool, date:Date) {
        self.id = id
        self.idName = idName
        self.isSetted = isSetted
        self.date = date
    }
}
