import Foundation

struct ChatGPTRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    
    struct ChatMessage: Identifiable, Codable, Equatable {
        var id = UUID() // Идентификатор создается локально, если не указан
        let role: String
        let content: String

        private enum CodingKeys: String, CodingKey {
            case role, content
        }
        
        init(role: String, content: String) {
            self.role = role
            self.content = content
        }
        
        // Декодирование инициализирует `id` автоматически, так как его нет в `CodingKeys`
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.role = try container.decode(String.self, forKey: .role)
            self.content = try container.decode(String.self, forKey: .content)
            self.id = UUID()
        }
    }
}

struct ChatGPTResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: ChatGPTRequest.ChatMessage
        let finish_reason: String
        let index: Int
    }
}

class ChatGPTAPI {
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    func sendRequest(messages: [ChatGPTRequest.ChatMessage]) async throws -> ChatGPTResponse {
        let request = ChatGPTRequest(model: "gpt-3.5-turbo", messages: messages)
        
        guard let url = URL(string: endpoint) else {
            throw NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(AppConfig.someApiKey)", forHTTPHeaderField: "Authorization")
        
        let jsonData = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NSError(domain: "HTTPError", code: 0, userInfo: nil)
        }
        
        let chatResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
        return chatResponse
    }
}
