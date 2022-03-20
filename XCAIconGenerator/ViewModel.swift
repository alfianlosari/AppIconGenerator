//
//  ViewModel.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import SwiftUI

enum ExportingPhase: Equatable {
    
    case `none`
    case inProgress
    case completed
    case failure(NSError)
}

class ViewModel: NSObject, ObservableObject {
    
    @Published var selectedImage: UIImage?
    @Published var exportingPhase: ExportingPhase = .none
    @Published var isPresentingImagePicker = false
    
    @Published var isExportingToiPhone = true
    @Published var isExportingToiPad = false
    @Published var isExportingToMac = false
    @Published var isExportingToWatch = false

    private let iconGeneratorService = IconFileGeneratorService(fileService: FileIconService(), resizeService: IconResizerService())
    
    
    private var isAllExportOptonsDisabled: Bool {
        !isExportingToiPhone && !isExportingToiPad && !isExportingToMac && !isExportingToWatch
    }
    
    var isToggleOptionsDisabled: Bool {
        selectedImage == nil
    }
    
    var isExportingInProgress: Bool {
        exportingPhase == .inProgress
    }
    
    var isExportButtonDisabled: Bool {
        isAllExportOptonsDisabled || isToggleOptionsDisabled || isAllExportOptonsDisabled
    }
    
    
    var selectedExportAppIconTypes: [AppIconType] {
        var appTypes = [AppIconType]()

        if isExportingToiPhone && isExportingToiPad {
            appTypes.append(.iPhoneAndiPad)
        } else if isExportingToiPhone {
            appTypes.append(.iphone)
        } else if isExportingToiPad {
            appTypes.append(.ipad)
        }
        
        if isExportingToMac {
            appTypes.append(.mac)
        }
        
        if isExportingToWatch {
            appTypes.append(.appleWatch)
        }
        return appTypes
    }
    
    func importImage() {
        #if targetEnvironment(macCatalyst)
        let documentPickerVC = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        documentPickerVC.delegate = self
        viewController?.present(documentPickerVC, animated: true)
        #else
        self.viewModel.isPresentingImagePicker = true
        #endif
    }
    
    func handleOnDropProviders(_ providers: [NSItemProvider]) -> Bool {
        providers.first?.loadDataRepresentation(forTypeIdentifier: "public.image") { (data, error) in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            Task { @MainActor in
                self.selectedImage = image
            }
        }
        return true
    }
    
    func export() {
        guard let selectedImage = selectedImage else {
            return
        }
        let appIconTypes = self.selectedExportAppIconTypes
        guard appIconTypes.count > 0 else { return }
        
        exportingPhase = .inProgress
        
        Task.detached { [weak self] in
            guard let self = self else { return }
            do {
                let url = try await self.iconGeneratorService.generateIconsURL(for: appIconTypes, with: selectedImage)
                Task { @MainActor in
                    #if targetEnvironment(macCatalyst)
                    self.presentDocumentPickerController(url: url)
                    #else
                    self.presentActivityPickerController(url: url)
                    #endif
                    
                    self.exportingPhase = .completed
                }
            } catch let error as NSError {
                Task { @MainActor in
                    self.exportingPhase = .failure(error)
                }
            }
        }
    }
    
    func presentActivityPickerController(url: URL) {
        guard let viewController = self.viewController else { return }
        let shareActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareActivity.popoverPresentationController?.sourceView = viewController.view
        shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        shareActivity.popoverPresentationController?.permittedArrowDirections = .down
        viewController.present(shareActivity, animated: true)
        
    }
    
    func presentDocumentPickerController(url: URL) {
        let documentPickerVC = UIDocumentPickerViewController(forExporting: [url])
        viewController?.present(documentPickerVC, animated: true)
    }
    
    private var viewController: UIViewController? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
    }
}

extension ViewModel: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return
        }
        Task { @MainActor in
            self.selectedImage = image
        }
    }
    
}
