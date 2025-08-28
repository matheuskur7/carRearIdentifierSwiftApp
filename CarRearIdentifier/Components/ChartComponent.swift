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
    var type: String
    
    var chartData: [String: Int] {
        Dictionary(grouping: inData, by: { $0.modelName })
            .mapValues { $0.count }
    }
    
    var last7DaysData: [CarItem] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today) else { return [] }
        
        return inData.filter { item in
            let day = calendar.startOfDay(for: item.dateTime)
            return day >= sevenDaysAgo && day <= today
        }
    }
    
    var chartDataByDay: [Date: Int] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: last7DaysData) { item in
            calendar.startOfDay(for: item.dateTime)
        }
        return grouped.mapValues { $0.count }
    }
    
    
    var body: some View {
        switch type {
        case "byModel": (
            Chart {
                ForEach(chartData.sorted(by: { $0.value > $1.value }), id: \.key) { model, count in
                    BarMark(
                        x: .value("Quantidade", count),
                        y: .value("Modelo", model),
                        width: .fixed(20)
                    )
                }
            }
                .chartYAxis {
                    AxisMarks()
                }
                .frame(height: CGFloat(chartData.count) * 40)
                .padding()
                .background(.appBlue.gradient)
                .cornerRadius(12)
            
        )
        case "byDay": (
            Chart {
                ForEach(chartDataByDay.keys.sorted(), id: \.self) { day in
                    if let count = chartDataByDay[day] {
                        BarMark(
                            x: .value("Data", day, unit: .day),
                            y: .value("Quantidade", count)
                        )
                    }
                }
            }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date, format: .dateTime.day())
                            }
                        }
                    }
                }
                .padding()
                .background(.appBlue.gradient)
                .cornerRadius(12)
            
        )
            
        default: Spacer()
        }
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
    ], type: "byModel")
    
}
