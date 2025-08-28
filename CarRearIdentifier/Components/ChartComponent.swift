//
//  ChartComponent.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 27/08/25.
//

import Charts
import SwiftUI

struct ChartComponent: View {
    var inData: [CarItem]
    
    var chartData: [String: Int] {
        Dictionary(grouping: inData, by: { $0.modelName })
            .mapValues { $0.count }
    }
    
    var body: some View {
        Chart {
            ForEach(chartData.sorted(by: { $0.value > $1.value }), id: \.key) { model, count in
                BarMark(
                    x: .value("Quantidade", count),
                    y: .value("Modelo", model)
                )
                .
            }
        }
        .padding()
        .background(.backgroundBlue) // sua cor custom
                .cornerRadius(12)
    }
}

#Preview {
    ChartComponent(inData: [
        CarItem(modelName: "Chevrolet Onix G1", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Chevrolet Onix G1", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 208 G2", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 208 G2", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G1", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G1", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G1", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G1", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G2", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G2", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G2", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Renault Sandero G3", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 207", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 206", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 206", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
        CarItem(modelName: "Peugeot 206", plate: "AAA 0000", initialKm: 80987, dateTime: Date()),
    ])
    
}
