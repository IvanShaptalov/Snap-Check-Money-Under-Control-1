import SwiftUI
import UIKit

class HomeScreenViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var showImagePicker: Bool = false
    @Published var inputImage: UIImage?
    @Published var showActionSheetFromCreating: Bool = false
    @Published var showActionSheetFromJson: Bool = false
    @Published var showCreateExpenceSheet: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var isShowYear: Bool = AppConfig.showYearFormat {
        didSet {
            AppConfig.toggleIsShowYearFormat() // format - Month or Year
        }
    }
    
    
    private let textRecognitionModel = TextRecognitionViewModel()

    init() {
        textRecognitionModel.$recognizedText
            .assign(to: &$recognizedText) // Observes changes in TextRecognitionModel's recognized text
    }
    
    func selectImage(sourceType: UIImagePickerController.SourceType) {
        self.sourceType = sourceType
        showImagePicker = true
    }
    
    func recognizeText() {
        guard let image = inputImage else { return }
        textRecognitionModel.recognizeText(from: image)
    }
}
