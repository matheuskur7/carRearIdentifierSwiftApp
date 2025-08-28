//
//  VehiclesScreen.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 25/08/25.
//

import SwiftUI
import SwiftData

struct RelatoriesScreen: View {
    @State var addCar: Bool = false
    @Query var items: [CarItem]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                
                VStack {
                    Text("Entradas de Veículos p/ Modelo")
                        .font(.system(.callout))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ChartComponent(inData: items, type: "byModel")
                }
                VStack {
                    Text("Entradas de Veículos p/ Dia")
                        .font(.system(.callout))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ChartComponent(inData: items, type: "byDay")
                }
                
            }
            .padding(.top, 8)
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
            .background(.backgroundSecondary)
            .navigationTitle("Relatórios")
            
            Spacer()
        }
    }
    
}

#Preview {
    RelatoriesScreen()
}
