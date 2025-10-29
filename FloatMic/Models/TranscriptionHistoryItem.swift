import Foundation

struct TranscriptionHistoryItem: Identifiable, Codable {
    let id: UUID
    let text: String
    let timestamp: Date
    let duration: TimeInterval
    
    init(id: UUID = UUID(), text: String, timestamp: Date, duration: TimeInterval) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.duration = duration
    }
}
