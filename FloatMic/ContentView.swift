import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var transcriptionManager: TranscriptionManager
    @EnvironmentObject var apiManager: APIManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var lastTapTime = Date()
    
    var body: some View {
        ZStack {
            // Floating microphone button
            ZStack {
                Circle()
                    .fill(audioRecorder.isRecording ? Color.red : Color(hex: settingsManager.buttonColor))
                    .frame(width: settingsManager.buttonSize.size, height: settingsManager.buttonSize.size)
                    .shadow(radius: 8)
                
                if audioRecorder.isRecording {
                    // Pulsing animation when recording
                    Circle()
                        .stroke(Color.red, lineWidth: 3)
                        .frame(width: settingsManager.buttonSize.size, height: settingsManager.buttonSize.size)
                        .scaleEffect(audioRecorder.isRecording ? 1.2 : 1.0)
                        .opacity(audioRecorder.isRecording ? 0.6 : 0.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: audioRecorder.isRecording)
                }
                
                Image(systemName: audioRecorder.isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: settingsManager.buttonSize.iconSize))
                    .foregroundColor(.white)
            }
            .scaleEffect(audioRecorder.isRecording ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: audioRecorder.isRecording)
            .onTapGesture {
                // Only toggle recording if it's a quick tap (not a drag)
                let now = Date()
                if now.timeIntervalSince(lastTapTime) < 0.3 {
                    audioRecorder.toggleRecording()
                }
                lastTapTime = now
            }
            
            // Toast overlay
            if transcriptionManager.showToast {
                ToastView(
                    message: transcriptionManager.toastMessage,
                    isShowing: $transcriptionManager.showToast
                )
            }
            
            // Status banner
            if transcriptionManager.showStatusBanner {
                VStack {
                    Text(transcriptionManager.statusMessage)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 6)
            }
        }
        .frame(width: settingsManager.buttonSize.size, height: settingsManager.buttonSize.size)
        .background(Color.clear)
        .onChange(of: audioRecorder.isRecording) { isRecording in
            if !isRecording, let recordingURL = audioRecorder.getRecordingURL() {
                transcriptionManager.transcribeAudio(url: recordingURL)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AudioRecorder())
            .environmentObject(TranscriptionManager(apiManager: APIManager(), historyManager: TranscriptionHistoryManager()))
            .environmentObject(APIManager())
    }
}
