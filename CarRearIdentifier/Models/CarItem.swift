//
//  cardItem.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 25/08/25.
//

import Foundation
import SwiftData

@Model
final class CarItem: Identifiable {
    var id = UUID()
    var imageData: Data?
    var modelName: String
    var plate: String
    var initialKm: Int
    var dateTime: Date
    
    init(imageData: Data? = nil, modelName: String, plate: String, initialKm: Int, dateTime: Date) {
        self.imageData = imageData
        self.modelName = modelName
        self.plate = plate
        self.initialKm = initialKm
        self.dateTime = dateTime
    }
}
