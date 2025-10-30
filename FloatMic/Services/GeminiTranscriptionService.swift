import Foundation

struct GeminiResponse: Decodable {
    struct Candidate: Decodable { let content: Content }
    struct Content: Decodable { let parts: [Part] }
    struct Part: Decodable { let text: String? }
    let candidates: [Candidate]?
}

class GeminiTranscriptionService {
    enum GeminiError: LocalizedError {
        case missingApiKey
        case invalidResponse
        case server(String)
        
        var errorDescription: String? {
            switch self {
            case .missingApiKey: return "Gemini API key is missing"
            case .invalidResponse: return "Invalid response from Gemini"
            case .server(let msg): return msg
            }
        }
    }

    // Minimal implementation using Gemini 1.5 generateContent with inline audio
    func transcribe(apiKey: String?, audioURL: URL) async throws -> String {
        guard let apiKey = apiKey, !apiKey.isEmpty else { throw GeminiError.missingApiKey }

        let endpoint = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let audioData = try Data(contentsOf: audioURL)
        let b64 = audioData.base64EncodedString()

        // Build a simple prompt asking to transcribe the audio
        let payload: [String: Any] = [
            "contents": [[
                "parts": [
                    ["text": "Transcribe the following audio to plain text."],
                    [
                        "inline_data": [
                            "mime_type": "audio/m4a",
                            "data": b64
                        ]
                    ]
                ]
            ]]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])

        let (data, response) = try await NetworkHelper.dataWithRetry(for: request)
        guard let http = response as? HTTPURLResponse else { throw GeminiError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw GeminiError.server(message)
        }

        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        if let text = decoded.candidates?.first?.content.parts.compactMap({ $0.text }).joined(separator: " "), !text.isEmpty {
            return text
        }
        throw GeminiError.invalidResponse
    }
}


