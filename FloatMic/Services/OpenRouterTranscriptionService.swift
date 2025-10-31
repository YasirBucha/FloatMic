import Foundation

struct OpenRouterResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

class OpenRouterTranscriptionService {
    enum OpenRouterError: LocalizedError {
        case missingApiKey
        case invalidResponse
        case server(String)
        
        var errorDescription: String? {
            switch self {
            case .missingApiKey: return "OpenRouter API key is missing"
            case .invalidResponse: return "Invalid response from OpenRouter"
            case .server(let msg): return msg
            }
        }
    }

    func transcribe(apiKey: String?, audioURL: URL) async throws -> String {
        guard let apiKey = apiKey, !apiKey.isEmpty else { throw OpenRouterError.missingApiKey }

        // OpenRouter uses OpenAI-compatible Whisper endpoint
        let endpoint = URL(string: "https://openrouter.ai/api/v1/audio/transcriptions")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("FloatMic/1.0", forHTTPHeaderField: "HTTP-Referer")
        request.setValue("https://github.com/yourusername/floatmic", forHTTPHeaderField: "X-Title")

        let body = try createMultipartBody(boundary: boundary, fileURL: audioURL)
        request.httpBody = body

        let (data, response) = try await NetworkHelper.dataWithRetry(for: request)
        guard let http = response as? HTTPURLResponse else { throw OpenRouterError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw OpenRouterError.server(message)
        }

        let decoded = try JSONDecoder().decode(OpenAIWhisperResponse.self, from: data)
        return decoded.text
    }

    private func createMultipartBody(boundary: String, fileURL: URL) throws -> Data {
        var body = Data()

        func append(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }

        // model field
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        append("openai/whisper-1\r\n")

        // file field
        let filename = fileURL.lastPathComponent
        let mime = "audio/m4a"
        let fileData = try Data(contentsOf: fileURL)

        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        append("Content-Type: \(mime)\r\n\r\n")
        body.append(fileData)
        append("\r\n")

        append("--\(boundary)--\r\n")
        return body
    }
}

