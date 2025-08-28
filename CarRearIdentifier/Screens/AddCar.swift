//
//  AddCar.swift
//  CarRearIdentifier
//
//  Created by aluno-06 on 26/08/25.
//

import SwiftUI
import PhotosUI

struct AddCar: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var model: String = ""
    @State var plate: String = ""
    @State var initialKm: String = ""
    
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    
    @State var showConfirmationAlert: Bool = false
    @State var pickerItemImage: PhotosPickerItem?
    @State var itemImageData: Data?
    
    @StateObject var carIdentifier = CarIdentifierModel()
    
    var nowDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false) {
                
                PhotosPicker(selection: $pickerItemImage, matching: .images) {
                    HStack {
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
                
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Modelo")
                            .font(.system(.callout, weight: .semibold))
                            .kerning(-0.31)
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("AAA 0A00...", text: $plate)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .autocapitalization(.allCharacters)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.backgroundTertiary)
                            )
                        
                        Text("Km Inicial")
                            .font(.system(.callout, weight: .semibold))
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
            .navigationTitle("Entrada de Veículo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        triggerSaveConfirmation()
                    }
                }
            }
            // Alerta de erro genérico
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            // Alerta de Confirmação
            .alert("Confirmar Dados", isPresented: $showConfirmationAlert) {
                Button("Confirmar") {
                    performSave()
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Por favor, confirme se os dados estão corretos:\n\nModelo: \(model)\nPlaca: \(plate)\nKm Inicial: \(initialKm)")
            }
        }
        .onChange(of: pickerItemImage) {
            Task {
                itemImageData = try? await pickerItemImage?.loadTransferable(type: Data.self)
            }
        }
        .onChange(of: itemImageData) { _, newValue in
            if let data = newValue, let uiImage = UIImage(data: data) {
                carIdentifier.classify(image: uiImage)
            }
        }
        .onReceive(carIdentifier.$identifiedModel) { identified in
            if let identified {
                model = identified
            }
        }
    }
    
    func isPlateValid(plate: String) -> Bool {
        // Regex: 3 letras, um espaço, 1 dígito, 1 letra OU dígito, 2 dígitos.
        let plateRegex = "^[A-Z]{3} \\d[A-Z0-9]\\d{2}$"
        let platePredicate = NSPredicate(format: "SELF MATCHES %@", plateRegex)
        return platePredicate.evaluate(with: plate)
    }
    
    func triggerSaveConfirmation() {
        guard itemImageData != nil else {
            alertTitle = "Imagem Faltando"
            alertMessage = "Por favor, adicione uma imagem do veículo."
            showAlert = true
            return
        }
        guard !model.isEmpty, !plate.isEmpty, !initialKm.isEmpty else {
            alertTitle = "Campos Vazios"
            alertMessage = "Por favor, preencha todos os campos antes de salvar."
            showAlert = true
            return
        }
        guard isPlateValid(plate: plate) else {
            alertTitle = "Placa Inválida"
            alertMessage = "O formato da placa deve ser 'AAA 0000' ou 'AAA 0A00'."
            showAlert = true
            return
        }
        
        showConfirmationAlert = true
    }
    
    func performSave() {
        guard let finalImageData = itemImageData else { return }
        
        let carItem = CarItem(imageData: finalImageData, modelName: model, plate: plate, initialKm: Int(initialKm) ?? 0, dateTime: nowDate)
        
        modelContext.insert(carItem)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Erro ao salvar os dados: \(error.localizedDescription)")
            alertTitle = "Erro ao Salvar"
            alertMessage = "Não foi possível salvar os dados. Tente novamente."
            showAlert = true
        }
    }
}

#Preview {
    AddCar()
}
