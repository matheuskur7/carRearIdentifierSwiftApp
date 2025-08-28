//
//  CarSeeder.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 28/08/25.
//

import Foundation
import SwiftData

struct CarSeeder {
    static func seed(in context: ModelContext) {
        let calendar = Calendar.current
        let today = Date()
        
        // Lista de modelos baseada nas imagens
        let carModels = [
            "Peugeot 206", "Peugeot 207", "Peugeot 208 G1", "Peugeot 208 G2", "Peugeot 307", "Peugeot 308",
            "Peugeot 3008 G1", "Peugeot 3008:5008 G2", "Peugeot 408",
            "Renault Captur", "Renault Duster", "Renault Fluence", "Renault Kwid", "Renault Logan G2",
            "Renault Megane Grand Tour", "Renault Sandero G1", "Renault Sandero G2", "Renault Sandero G3",
            "Volkswagen Fox", "Volkswagen Gol G4", "Volkswagen Gol G5", "Volkswagen T-Cross", "Volkswagen Up",
            "Ford New Ecosport", "Ford New Fiesta", "Ford New Focus", "Ford New Ka", "Ford New Ka Sedan",
            "Nissan March", "Nissan Versa"
        ]
        
        for _ in 0..<50 { // quantidade de carros a inserir
            guard let model = carModels.randomElement() else { continue }
            
            // Data aleatória nos últimos 7 dias
            let randomDayOffset = Int.random(in: 0...6)
            let date = calendar.date(byAdding: .day, value: -randomDayOffset, to: today)!
            
            let car = CarItem(
                modelName: model,
                plate: "AAA \(Int.random(in: 1000...9999))",
                initialKm: Int.random(in: 5000...150000),
                dateTime: date
            )
            
            context.insert(car)
        }
        
        do {
            try context.save()
            print("Seeder finalizado")
        } catch {
            print("Erro ao salvar: \(error)")
        }
    }
}
