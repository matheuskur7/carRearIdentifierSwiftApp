//
//  CarRearIdentifierApp.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 25/08/25.
//

import SwiftUI
import SwiftData

@main
struct CarRearIdentifierApp: App {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: CarItem.self)
            let fetchDescriptor = FetchDescriptor<CarItem>()
            
            let count = try container.mainContext.fetchCount(fetchDescriptor)
            if count == 0 {
                print("Banco de dados vazio. Iniciando o seeder...")
                CarSeeder.seed(in: container.mainContext)
            }
        } catch {
            fatalError("Falha ao criar o ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
        .modelContainer(container)
    }
}
