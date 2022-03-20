//
//  ContentView.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            mainView.frame(width: 360, height: 600, alignment: .center)
        default:
            mainView
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        VStack(spacing: 24) {
            iconView
            if viewModel.isExportingInProgress {
                ProgressView()
            }
            exportView
        }
        .background(Color(uiColor: .systemBackground))
        .padding()
        .animation(.default, value: viewModel.exportingPhase)
        .animation(.default, value: viewModel.selectedImage)
        .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker) {
            ImagePickerView(image: $viewModel.selectedImage)
        }
    }
    
    private var iconView: some View {
        Button {
            self.viewModel.importImage()
        } label: {
            RoundedRectangle(cornerRadius: 24, style: .circular)
                .foregroundColor(.gray.opacity(0.5))
                .overlay {
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .cornerRadius(24)
                            .clipped()
                        
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                            Text("Select 1024x1024 icon")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                }
        }
        .frame(width: 200, height: 200, alignment: .center)
        .disabled(viewModel.isExportingInProgress)
        .onDrop(of: ["public.image"], isTargeted: nil, perform: viewModel.handleOnDropProviders)
        
    }
    
    @ViewBuilder
    private var exportView: some View {
        Divider()
        VStack {
            Toggle("iPhone", isOn: $viewModel.isExportingToiPhone)
            Toggle("iPad", isOn: $viewModel.isExportingToiPad)
            Toggle("Mac", isOn: $viewModel.isExportingToMac)
            Toggle("Apple Watch", isOn: $viewModel.isExportingToWatch)
        }
        .disabled(viewModel.isToggleOptionsDisabled)
        
        Divider()
        
        Button {
            viewModel.export()
        } label: {
            Text("Export")
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .disabled(viewModel.isExportButtonDisabled)
        
        if case let .failure(error) = viewModel.exportingPhase {
            Text(error.localizedDescription)
                .foregroundColor(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
