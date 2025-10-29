import SwiftUI

struct TranscriptionHistoryView: View {
    @EnvironmentObject var historyManager: TranscriptionHistoryManager
    @State private var showingExportSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Transcription History")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Export") {
                    showingExportSheet = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Clear All") {
                    historyManager.clearAllTranscriptions()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
            
            if historyManager.transcriptions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "mic.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No transcriptions yet")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("Start recording to see your transcription history here")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(historyManager.transcriptions) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.timestamp, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(item.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(item.text)
                                .font(.body)
                                .lineLimit(nil)
                        }
                        .padding(.vertical, 4)
                        .contextMenu {
                            Button("Copy") {
                                NSPasteboard.general.setString(item.text, forType: .string)
                            }
                            
                            Button("Delete", role: .destructive) {
                                historyManager.deleteTranscription(item)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(isPresented: $showingExportSheet) {
            ExportHistoryView()
                .environmentObject(historyManager)
        }
    }
}
