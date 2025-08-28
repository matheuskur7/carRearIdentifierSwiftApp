//
//  VehiclesScreen.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 25/08/25.
//

import SwiftUI
import SwiftData

struct VehiclesScreen: View {
    @State var addCar: Bool = false
    @Query var items: [CarItem]
    
    var body: some View {
        VStack {
            VerticalTwoColScroll(items: items)
        }
        .padding(.top, 8)
        .background(.backgroundSecondary)
        .navigationTitle("Car Rear Identifier")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addCar = true;
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(16, for: .scrollContent)
        .sheet(isPresented: $addCar) {
            AddCar()
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    VehiclesScreen()
}
