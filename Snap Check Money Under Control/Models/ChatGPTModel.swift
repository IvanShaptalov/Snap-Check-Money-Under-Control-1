import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatGPTRequest.ChatMessage] = []
    @Published var resultResponse: ChatGPTRequest.ChatMessage? = nil
    @Published var errorMessage: ErrorWrapper? // Use ErrorWrapper
    @Published var isLoading: Bool = false

    private let api: ChatGPTAPI

    init(apiKey: String) {
        self.api = ChatGPTAPI(apiKey: apiKey)
    }

    func addMessage(_ message: ChatGPTRequest.ChatMessage) {
        messages.append(message)
        fetchResponse(for: message)
    }

    private func fetchResponse(for message: ChatGPTRequest.ChatMessage) {
        isLoading = true
        Task {
            do {
                let response = try await api.sendRequest(messages: messages)
                handleResponse(response)
            } catch {
                print(error.localizedDescription)
                handleError(error)
            }
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
        }
    }

    private func handleResponse(_ response: ChatGPTResponse) {
        guard let choice = response.choices.first else { return }
        DispatchQueue.main.async { [weak self] in
            print("response from chatgpt ")
            print(choice.message)
            self?.resultResponse = choice.message
        }
        
    }

    private func handleError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            if error.localizedDescription.contains("error 0") {
                self?.errorMessage = ErrorWrapper(message: ChatGPTError.apiKeyError.localizedDescription)
            }
            else {
                self?.errorMessage = ErrorWrapper(message: error.localizedDescription)
            }
            
        }
        // Here you can customize the error handling
        
    }
}
