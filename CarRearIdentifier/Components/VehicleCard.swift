//
//  SwiftUIView.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 25/08/25.
//

import SwiftUI

struct VehicleCard: View {
    var item: CarItem
    
    var body: some View {
        VStack (spacing: 0) {
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 166, height: 100)
                    .clipped(antialiased: true)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.backgroundBlue)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(8)
            } else {
                Image(systemName: "car.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.white)
                    .scaledToFit()
                    .frame(width: 166, height: 100)
                    .clipped(antialiased: true)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.backgroundBlue)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(8)
            }
            
            VStack() {
                VStack(spacing: 2) {
                    Text(item.modelName)
                        .font(.system(.title3, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 2)
                    
                    Text("Placa: \(item.plate)")
                        .font(.system(.caption2))
                        .foregroundStyle(.labelSecondary)
                    
                    Text("Km Inicial: \(item.initialKm)")
                        .font(.system(.caption2))
                        .foregroundStyle(.labelSecondary)
                }
                
                HStack (alignment: .center){
                    Text(item.dateTime.formatted())
                        .font(.system(.caption))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.blue)
                        .opacity(0.6)
                )
            }
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.appBlue.gradient)
        )
    }
}

#Preview {
    VehicleCard(
        item: CarItem(modelName: "Peugeot 208", plate: "JBL 1B66", initialKm: 198128, dateTime: Date(timeIntervalSince1970: 1280000000))
    )
}
