import SwiftUI
import Vision

class TextRecognitionViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var errorMessage: ErrorWrapper? // Use ErrorWrapper
    
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            handleError(.imageConversionFailed)
            return
        }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            if let error = error {
                self?.handleError(.requestFailed(error))
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                self?.handleError(.noTextFound)
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            DispatchQueue.main.async {
                self?.recognizedText = recognizedStrings.joined(separator: "\n")
            }
        }
        
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            handleError(.requestFailed(error))
        }
    }
    
    private func handleError(_ error: TextRecognitionError) {
        DispatchQueue.main.async {
            self.errorMessage = ErrorWrapper(message: error.localizedDescription)
        }
    }
}
