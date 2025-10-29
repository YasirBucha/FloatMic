import SwiftUI

struct ExportHistoryView: View {
    @EnvironmentObject var historyManager: TranscriptionHistoryManager
    @Environment(\.dismiss) private var dismiss
    @State private var exportText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Export Transcription History")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            
            Text("Copy the text below to export your transcription history:")
                .foregroundColor(.secondary)
            
            ScrollView {
                Text(exportText)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack {
                Button("Copy to Clipboard") {
                    NSPasteboard.general.setString(exportText, forType: .string)
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
        }
        .padding()
        .frame(width: 600, height: 500)
        .onAppear {
            exportText = historyManager.exportTranscriptions()
        }
    }
}
