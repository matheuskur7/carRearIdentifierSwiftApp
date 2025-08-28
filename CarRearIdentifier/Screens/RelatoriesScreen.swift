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
        VStack(spacing: 2) {
            
            Text("Entradas de Veículos p/ Modelo")
                .font(.system(.callout))
                .frame(maxWidth: .infinity, alignment: .leading)
                
            ChartComponent(inData: items)
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
        .background(.backgroundSecondary)
        .navigationTitle("Relatórios")
    }
    
}

#Preview {
    RelatoriesScreen()
}
