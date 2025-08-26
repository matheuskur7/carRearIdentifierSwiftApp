//
//  AddCar.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 26/08/25.
//

import SwiftUI
import PhotosUI
import Vision

struct AddCar: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var model: String = ""
    @State var plate: String = ""
    @State var initialKm: String = ""
    @State var showAlert: Bool = false
    @State var pickerItemImage: PhotosPickerItem?
    @State var itemImageData: Data?
    
    var nowDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false){
                PhotosPicker(selection: $pickerItemImage, matching: .images) {
                    HStack{
                        if let itemImageData, let uiImage = UIImage(data: itemImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 143, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            Image(systemName: "camera")
                                .font(.system(.title2))
                                .foregroundStyle(.appGray)
                                .frame(width: 200, height: 143, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.gray5)
                                )
                        }
                        
                        HStack(spacing: 4) {
                            Text("Adicionar Imagem")
                                .fontWeight(.semibold)
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .frame(height: 163)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                VStack(spacing: 16){
                    VStack(spacing: 8) {
                        Text("Modelo")
                            .font(.system(.callout, weight: .semibold))
                            .kerning(-0.31)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Modelo do veículo aqui", text: $model)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.backgroundTertiary)
                            )
                        Text("Placa")
                            .font(.system(.callout, weight: .semibold))
                            .kerning(-0.31)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("AAA 0A00...", text: $plate)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.backgroundTertiary)
                            )
                        Text("Km Inicial")
                            .font(.system(.callout, weight: .semibold))
                            .kerning(-0.31)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("101.198...", text: $initialKm)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.backgroundTertiary)
                            )
                    }
                    .padding()
                    Text("\(nowDate.formatted())")
                        .font(.system(.title3, weight: .regular))
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.blue)
                                .opacity(0.6)
                        )
                        .foregroundStyle(.white)
                    
                }
            }
            .background(.backgroundSecondary)
            .frame(maxWidth: .infinity)
            .navigationTitle("Entrada de Veículo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveItem()
                        }
                    }
                }
            }
            .alert("Informações Faltando!", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
        .onChange(of: itemImageData) { _, newValue in
            if let data = newValue {
                classifyImage(data: data)
            }
        }
        .onChange(of: pickerItemImage) {
            Task {
                itemImageData = try? await pickerItemImage?.loadTransferable(type: Data.self)
            }
        }
    }
    
    func saveItem() async {
        guard let itemImageData else {
            showAlert = true
            return
        }
        
        guard !initialKm.isEmpty, !model.isEmpty, !plate.isEmpty else {
            showAlert = true
            return
        }
        
        try? modelContext.save()
        dismiss()
    }
    
    func classifyImage(data: Data) {
        guard let uiImage = UIImage(data: data),
              let cgImage = uiImage.cgImage else { return }
        
        do {
            let mlModel = try CarModelIdentifierV8(configuration: MLModelConfiguration()).model
            let vnModel = try VNCoreMLModel(for: mlModel)
            
            let request = VNCoreMLRequest(model: vnModel) { request, _ in
                if let results = request.results as? [VNClassificationObservation],
                   let best = results.first {
                    DispatchQueue.main.async {
                        self.model = best.identifier // aqui joga direto no campo model
                    }
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
            
        } catch {
            print("Erro ao rodar modelo: \(error)")
        }
    }
}



#Preview {
    AddCar()
}
