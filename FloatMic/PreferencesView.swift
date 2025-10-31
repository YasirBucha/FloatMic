import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var apiManager: APIManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedService: APIManager.ServiceType
    
    init() {
        _selectedService = State(initialValue: .appleIntelligence)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Preferences")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Transcription Service Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transcription Service")
                            .fontWeight(.medium)
                            .font(.headline)
                        
                        Picker("Service", selection: $selectedService) {
                            ForEach(APIManager.ServiceType.allCases, id: \.self) { service in
                                Text(service.rawValue).tag(service)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: selectedService) { _, newValue in
                            apiManager.setSelectedService(newValue)
                        }
                        
                        Text("Service Priority")
                            .fontWeight(.medium)
                            .padding(.top, 8)
                        
                        Text("The app will try services in this order:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(apiManager.getAvailableServices(), id: \.self) { service in
                                HStack {
                                    Text("\(apiManager.getAvailableServices().firstIndex(of: service)! + 1).")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(width: 20, alignment: .leading)
                                    
                                    Text(service.rawValue)
                                        .font(.caption)
                                    
                                    if service == .appleIntelligence {
                                        Text("RECOMMENDED")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 1)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(2)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 16)
                    }
                    
                    Divider()
                    
                    // Button Settings Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Button Settings")
                            .fontWeight(.medium)
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Size:")
                                    .frame(width: 80, alignment: .leading)
                                Picker("Button Size", selection: Binding(
                                    get: { settingsManager.buttonSize },
                                    set: { settingsManager.setButtonSize($0) }
                                )) {
                                    ForEach(SettingsManager.ButtonSize.allCases, id: \.self) { size in
                                        Text(size.rawValue).tag(size)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            HStack {
                                Text("Color:")
                                    .frame(width: 80, alignment: .leading)
                                TextField("Hex Color", text: Binding(
                                    get: { settingsManager.buttonColor },
                                    set: { settingsManager.setButtonColor($0) }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                
                                Circle()
                                    .fill(Color(hex: settingsManager.buttonColor))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            Toggle("Enable Edge Snapping", isOn: Binding(
                                get: { settingsManager.enableEdgeSnapping },
                                set: { settingsManager.setEdgeSnapping($0) }
                            ))
                            
                            if settingsManager.enableEdgeSnapping {
                                HStack {
                                    Text("Snap Distance:")
                                        .frame(width: 80, alignment: .leading)
                                    Slider(value: Binding(
                                        get: { settingsManager.snapThreshold },
                                        set: { settingsManager.setSnapThreshold($0) }
                                    ), in: 10...50)
                                    Text("\(Int(settingsManager.snapThreshold))px")
                                        .frame(width: 40)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Local Whisper Model Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Local Whisper Model")
                            .fontWeight(.medium)
                            .font(.headline)
                        
                        HStack {
                            Text("Model:")
                            Picker("Whisper Model", selection: Binding(
                                get: { settingsManager.whisperModelName },
                                set: { settingsManager.setWhisperModelName($0) }
                            )) {
                                Text("Tiny (English)").tag("ggml-tiny.en")
                                Text("Base").tag("ggml-base")
                                Text("Base (English)").tag("ggml-base.en")
                                Text("Small (English)").tag("ggml-small.en")
                                Text("Medium (English)").tag("ggml-medium.en")
                                Text("Large v3").tag("ggml-large-v3")
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        let path1 = Bundle.main.path(forResource: settingsManager.whisperModelName, ofType: "bin", inDirectory: "whisper/models")
                        let path2 = "whisper/models/\(settingsManager.whisperModelName).bin"
                        let exists = (path1 != nil) || FileManager.default.fileExists(atPath: path2)
                        if exists {
                            Text("Model found: \(path1 ?? path2)")
                                .font(.caption)
                                .foregroundColor(.green)
                        } else {
                            Text("Model missing: expected at whisper/models/\(settingsManager.whisperModelName).bin")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        HStack(spacing: 12) {
                            Button("Open Models Folder") {
                                #if canImport(AppKit)
                                let fm = FileManager.default
                                let folder = "whisper/models"
                                var isDir: ObjCBool = false
                                if fm.fileExists(atPath: folder, isDirectory: &isDir), isDir.boolValue {
                                    NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: folder)
                                } else {
                                    NSWorkspace.shared.openFile("whisper")
                                }
                                #endif
                            }
                            
                            Toggle("Local Whisper only (offline mode)", isOn: Binding(
                                get: { apiManager.forceLocalWhisperOnly },
                                set: { apiManager.setForceLocalWhisperOnly($0) }
                            ))
                        }
                    }
                    
                    Divider()
                    
                    // Multi-Display Settings Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Multi-Display Settings")
                            .fontWeight(.medium)
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Picker("Display Mode", selection: Binding(
                                get: { settingsManager.multiDisplayMode },
                                set: { settingsManager.setMultiDisplayMode($0) }
                            )) {
                                ForEach(SettingsManager.MultiDisplayMode.allCases, id: \.self) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Text(settingsManager.multiDisplayMode.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    Divider()
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About FloatMic")
                            .fontWeight(.medium)
                            .font(.headline)
                        
                        Text("FloatMic v1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("A floating microphone app for instant speech-to-text transcription")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            selectedService = apiManager.selectedService
        }
    }
}
