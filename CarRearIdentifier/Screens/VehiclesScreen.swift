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
    
    // CORREÇÃO 1: Adicionado o tipo explícito [SortDescriptor<CarItem>]
    @Query(sort: [SortDescriptor<CarItem>(\.dateTime, order: .reverse)]) var items: [CarItem]
    
    // MARK: - Computed Properties for Columns
    // Itens para a coluna da esquerda (índices pares)
    var leftColumnItems: [CarItem] {
        return items.enumerated()
            .filter { $0.offset % 2 == 0 }
            .map { $0.element }
    }
    
    // Itens para a coluna da direita (índices ímpares)
    var rightColumnItems: [CarItem] {
        return items.enumerated()
            .filter { $0.offset % 2 != 0 }
            .map { $0.element }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if items.isEmpty {
                    VStack {
                        Spacer()
                        Text("Nenhum veículo cadastrado.")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.top, 100)
                } else {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(spacing: 16) {
                            ForEach(leftColumnItems) { item in
                                VehicleCard(item: item)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 16) {
                            ForEach(rightColumnItems) { item in
                                VehicleCard(item: item)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
            .background(.backgroundSecondary)
            .navigationTitle("Veículos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addCar = true;
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $addCar) {
                AddCar()
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    VehiclesScreen()
        .modelContainer(for: CarItem.self, inMemory: true)
}
