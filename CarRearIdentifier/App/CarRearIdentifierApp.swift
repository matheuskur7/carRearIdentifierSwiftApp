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
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
        .modelContainer(for: CarItem.self)
    }
}
