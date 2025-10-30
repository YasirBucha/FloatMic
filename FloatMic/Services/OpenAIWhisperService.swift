import Foundation

struct OpenAIWhisperResponse: Decodable {
    let text: String
}

class OpenAIWhisperService {
    enum OpenAIError: LocalizedError {
        case missingApiKey
        case invalidResponse
        case server(String)
        
        var errorDescription: String? {
            switch self {
            case .missingApiKey: return "OpenAI API key is missing"
            case .invalidResponse: return "Invalid response from OpenAI"
            case .server(let msg): return msg
            }
        }
    }

    func transcribe(apiKey: String?, audioURL: URL) async throws -> String {
        guard let apiKey = apiKey, !apiKey.isEmpty else { throw OpenAIError.missingApiKey }

        let endpoint = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body = try createMultipartBody(boundary: boundary, fileURL: audioURL)
        request.httpBody = body

        let (data, response) = try await NetworkHelper.dataWithRetry(for: request)
        guard let http = response as? HTTPURLResponse else { throw OpenAIError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw OpenAIError.server(message)
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
        append("whisper-1\r\n")

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


