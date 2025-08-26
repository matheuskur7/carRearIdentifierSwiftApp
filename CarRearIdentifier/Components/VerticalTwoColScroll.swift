//
//  VerticalTwoColScroll.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 25/08/25.
//

import SwiftUI

struct VerticalTwoColScroll: View {
    
    let items: [CarItem] = [
        CarItem(modelName: "Peugeot 208", plate: "JBL 1B66", initialKm: 198128, dateTime: Date(timeIntervalSinceNow: -4120)),
        CarItem(modelName: "Peugeot 208", plate: "JBL 1B66", initialKm: 198128, dateTime: Date()),
        CarItem(modelName: "Peugeot 208", plate: "JBL 1B66", initialKm: 198128, dateTime: Date(timeIntervalSince1970: 128000000)),
        CarItem(modelName: "Peugeot 208", plate: "JBL 1B66", initialKm: 198128, dateTime: Date(timeIntervalSince1970: 12800000000)),
        CarItem(modelName: "Peugeot 208", plate: "JBL 1B66", initialKm: 198128, dateTime: Date())
    ]
    
    var body: some View {
        ScrollView (showsIndicators: false){
            LazyVGrid (
                columns: [
                    GridItem(.flexible()), GridItem(.flexible())
                ],
                alignment: .trailing,
                spacing: 8,
                pinnedViews: [],
                content: {
                    ForEach (items, id:\.self.id) { item in
                        VehicleCard(item: item)
                    }
                })
        }
    }
    
}

#Preview {
    VerticalTwoColScroll()
}
