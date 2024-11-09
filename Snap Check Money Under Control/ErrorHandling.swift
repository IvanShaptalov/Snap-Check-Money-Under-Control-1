import Foundation

enum TextRecognitionError: LocalizedError {    
    case imageConversionFailed
    case textRecognitionFailed
    case noTextFound
    case requestFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "Failed to convert the image for text recognition."
        case .textRecognitionFailed:
            return "An error occurred while recognizing text."
        case .noTextFound:
            return "No text was detected in the image."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        }
    }
}


enum ChatGPTError: LocalizedError {
    case apiKeyError
    case requestFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .apiKeyError:
            return "Failed to connect to api server"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        }
    }
}


struct ErrorWrapper: Identifiable {
    let id = UUID() // Conforms to Identifiable
    let message: String
}
