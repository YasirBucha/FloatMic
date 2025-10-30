import Foundation

enum NetworkHelper {
    static func dataWithRetry(for request: URLRequest, retries: Int = 2, initialDelay: Double = 0.5) async throws -> (Data, URLResponse) {
        var attempt = 0
        var delay = initialDelay
        var lastError: Error?
        while attempt <= retries {
            do {
                let config = URLSessionConfiguration.ephemeral
                config.timeoutIntervalForRequest = 30
                config.timeoutIntervalForResource = 60
                let session = URLSession(configuration: config)
                return try await session.data(for: request)
            } catch {
                lastError = error
                attempt += 1
                if attempt > retries { break }
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                delay *= 2
            }
        }
        throw lastError ?? URLError(.unknown)
    }
}


