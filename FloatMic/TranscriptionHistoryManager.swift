import Foundation
import SwiftUI

class TranscriptionHistoryManager: ObservableObject {
    @Published var transcriptions: [TranscriptionHistoryItem] = []
    
    private let userDefaults = UserDefaults.standard
    private let transcriptionsKey = "transcriptionHistory"
    
    init() {
        loadTranscriptions()
    }
    
    func addTranscription(_ item: TranscriptionHistoryItem) {
        transcriptions.insert(item, at: 0) // Add to beginning
        saveTranscriptions()
    }
    
    func deleteTranscription(_ item: TranscriptionHistoryItem) {
        transcriptions.removeAll { $0.id == item.id }
        saveTranscriptions()
    }
    
    func clearAllTranscriptions() {
        transcriptions.removeAll()
        saveTranscriptions()
    }
    
    func exportTranscriptions() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        var exportText = "FloatMic Transcription History\n"
        exportText += "Generated on \(formatter.string(from: Date()))\n\n"
        
        for (index, item) in transcriptions.enumerated() {
            exportText += "\(index + 1). \(formatter.string(from: item.timestamp))\n"
            exportText += "\(item.text)\n\n"
        }
        
        return exportText
    }
    
    private func loadTranscriptions() {
        if let data = userDefaults.data(forKey: transcriptionsKey),
           let decoded = try? JSONDecoder().decode([TranscriptionHistoryItem].self, from: data) {
            transcriptions = decoded
        }
    }
    
    private func saveTranscriptions() {
        if let encoded = try? JSONEncoder().encode(transcriptions) {
            userDefaults.set(encoded, forKey: transcriptionsKey)
        }
    }
}
