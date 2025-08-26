//
//  TabBar.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 25/08/25.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            Tab("Veículos", systemImage: "car.fill") {
                NavigationStack {
                    VehiclesScreen()
                        .padding(.bottom, -48)
                }
            }
            Tab("Relatórios", systemImage: "chart.bar.xaxis.ascending") {
                
            }
        }
    }
}

#Preview {
    TabBar()
}
