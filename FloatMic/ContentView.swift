import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var transcriptionManager: TranscriptionManager
    @EnvironmentObject var apiManager: APIManager
    
    var body: some View {
        ZStack {
            // Floating microphone button
            ZStack {
                Circle()
                    .fill(audioRecorder.isRecording ? Color.red : Color.blue)
                    .frame(width: 80, height: 80)
                    .shadow(radius: 8)
                
                if audioRecorder.isRecording {
                    // Pulsing animation when recording
                    Circle()
                        .stroke(Color.red, lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .scaleEffect(audioRecorder.isRecording ? 1.2 : 1.0)
                        .opacity(audioRecorder.isRecording ? 0.6 : 0.0)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: audioRecorder.isRecording)
                }
                
                Image(systemName: audioRecorder.isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
            .scaleEffect(audioRecorder.isRecording ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: audioRecorder.isRecording)
            .onTapGesture {
                // Handle tap for recording toggle
                audioRecorder.toggleRecording()
            }
            
            // Toast overlay
            if transcriptionManager.showToast {
                ToastView(
                    message: transcriptionManager.toastMessage,
                    isShowing: $transcriptionManager.showToast
                )
            }
        }
        .frame(width: 100, height: 100)
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
