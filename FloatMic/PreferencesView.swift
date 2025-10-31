import SwiftUI

// MARK: - Reusable Components
struct PreferenceSection<Content: View>: View {
    let title: String
    let icon: String
    var showHeader: Bool = true
    var compact: Bool = false
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 12 : 16) {
            if showHeader {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    
                    Text(title)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)
                }
                .padding(.bottom, compact ? 4 : 8)
            }
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
        )
    }
}

struct PreferenceRow<Content: View>: View {
    let label: String
    let labelWidth: CGFloat
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(label)
                .font(.system(.body))
                .foregroundColor(.primary)
                .frame(width: labelWidth, alignment: .leading)
            
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

struct PreferencesView: View {
    @EnvironmentObject var apiManager: APIManager
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var historyManager: TranscriptionHistoryManager
    @State private var selectedTab: PreferenceTab = .general
    
    enum PreferenceTab: String, CaseIterable {
        case general = "General"
        case services = "Services"
        case apiKeys = "API Keys"
        case history = "History"
        
        var icon: String {
            switch self {
            case .general: return "gearshape"
            case .services: return "waveform"
            case .apiKeys: return "key"
            case .history: return "clock"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralPreferencesTab()
                .tabItem {
                    Label(PreferenceTab.general.rawValue, systemImage: PreferenceTab.general.icon)
                }
                .tag(PreferenceTab.general)
            
            ServicesPreferencesTab()
                .tabItem {
                    Label(PreferenceTab.services.rawValue, systemImage: PreferenceTab.services.icon)
                }
                .tag(PreferenceTab.services)
            
            APIKeysPreferencesTab()
                .tabItem {
                    Label(PreferenceTab.apiKeys.rawValue, systemImage: PreferenceTab.apiKeys.icon)
                }
                .tag(PreferenceTab.apiKeys)
            
            HistoryPreferencesTab()
                .tabItem {
                    Label(PreferenceTab.history.rawValue, systemImage: PreferenceTab.history.icon)
                }
                .tag(PreferenceTab.history)
        }
        .frame(width: 700, height: 600)
    }
}

// MARK: - General Tab
struct GeneralPreferencesTab: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var apiManager: APIManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Button Settings Section
                PreferenceSection(title: "Button Settings", icon: "circle.fill") {
                    VStack(spacing: 16) {
                        PreferenceRow(label: "Size", labelWidth: 120) {
                            Picker("Button Size", selection: Binding(
                                get: { settingsManager.buttonSize },
                                set: { settingsManager.setButtonSize($0) }
                            )) {
                                ForEach(SettingsManager.ButtonSize.allCases, id: \.self) { size in
                                    Text(size.rawValue).tag(size)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(maxWidth: 200)
                        }
                        
                        PreferenceRow(label: "Color", labelWidth: 120) {
                            HStack(spacing: 12) {
                                TextField("Hex Color", text: Binding(
                                    get: { settingsManager.buttonColor },
                                    set: { settingsManager.setButtonColor($0) }
                                ))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                                
                                Circle()
                                    .fill(Color(hex: settingsManager.buttonColor))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary.opacity(0.1), lineWidth: 1.5)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                        }
                        
                        PreferenceRow(label: "Edge Snapping", labelWidth: 120) {
                            Toggle("", isOn: Binding(
                                get: { settingsManager.enableEdgeSnapping },
                                set: { settingsManager.setEdgeSnapping($0) }
                            ))
                            .toggleStyle(.switch)
                        }
                        
                        if settingsManager.enableEdgeSnapping {
                            PreferenceRow(label: "Snap Distance", labelWidth: 120) {
                                HStack(spacing: 12) {
                                    Slider(value: Binding(
                                        get: { settingsManager.snapThreshold },
                                        set: { settingsManager.setSnapThreshold($0) }
                                    ), in: 10...50)
                                    Text("\(Int(settingsManager.snapThreshold))px")
                                        .font(.system(.body, design: .monospaced))
                                        .foregroundColor(.secondary)
                                        .frame(width: 50, alignment: .trailing)
                                }
                            }
                        }
                    }
                }
                
                // Local Whisper Model Section
                PreferenceSection(title: "Local Whisper Model", icon: "waveform") {
                    VStack(spacing: 16) {
                        PreferenceRow(label: "Model", labelWidth: 120) {
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
                            .pickerStyle(.menu)
                            .frame(maxWidth: 200)
                        }
                        
                        let path1 = Bundle.main.path(forResource: settingsManager.whisperModelName, ofType: "bin", inDirectory: "whisper/models")
                        let path2 = "whisper/models/\(settingsManager.whisperModelName).bin"
                        let exists = (path1 != nil) || FileManager.default.fileExists(atPath: path2)
                        
                        HStack(spacing: 8) {
                            Image(systemName: exists ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .foregroundColor(exists ? .green : .orange)
                                .font(.caption)
                            
                            Text(exists ? "Model found" : "Model missing")
                                .font(.caption)
                                .foregroundColor(exists ? .green : .orange)
                            
                            if !exists {
                                Text("• \(settingsManager.whisperModelName).bin")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 12) {
                            Button {
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
                            } label: {
                                Label("Open Models Folder", systemImage: "folder")
                                    .font(.system(.body))
                            }
                            .buttonStyle(.bordered)
                            
                            Spacer()
                            
                            Toggle("Offline Mode", isOn: Binding(
                                get: { apiManager.forceLocalWhisperOnly },
                                set: { apiManager.setForceLocalWhisperOnly($0) }
                            ))
                            .toggleStyle(.switch)
                        }
                    }
                }
                
                // Multi-Display Settings Section
                PreferenceSection(title: "Multi-Display Settings", icon: "display.2") {
                    VStack(spacing: 16) {
                        PreferenceRow(label: "Display Mode", labelWidth: 120) {
                            Picker("Display Mode", selection: Binding(
                                get: { settingsManager.multiDisplayMode },
                                set: { settingsManager.setMultiDisplayMode($0) }
                            )) {
                                ForEach(SettingsManager.MultiDisplayMode.allCases, id: \.self) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: 200)
                        }
                        
                        Text(settingsManager.multiDisplayMode.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                    }
                }
                
                // About Section
                PreferenceSection(title: "About FloatMic", icon: "info.circle") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                                .frame(width: 48, height: 48)
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FloatMic")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text("Version 1.0.0")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text("A floating microphone app for instant speech-to-text transcription")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Services Tab
struct ServicesPreferencesTab: View {
    @EnvironmentObject var apiManager: APIManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Service Selection
                PreferenceSection(title: "Transcription Service", icon: "waveform") {
                    Text("Select which service to use for speech-to-text transcription")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 8) {
                        ForEach(APIManager.ServiceType.allCases, id: \.self) { service in
                            ServiceSelectionButton(
                                service: service,
                                isSelected: apiManager.selectedService == service,
                                action: {
                                    DispatchQueue.main.async {
                                        apiManager.setSelectedService(service)
                                    }
                                }
                            )
                        }
                    }
                }
                
                // Service Priority
                PreferenceSection(title: "Service Priority", icon: "list.number") {
                    Text("The app will try services in this order:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 6) {
                        ForEach(Array(apiManager.getAvailableServices().enumerated()), id: \.element) { index, service in
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(service == .appleIntelligence ? Color.blue.opacity(0.15) : Color.secondary.opacity(0.1))
                                        .frame(width: 24, height: 24)
                                    
                                    Text("\(index + 1)")
                                        .font(.system(.caption, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(service == .appleIntelligence ? .blue : .secondary)
                                }
                                
                                Text(service.rawValue)
                                    .font(.system(.body))
                                
                                if service == .appleIntelligence {
                                    Text("RECOMMENDED")
                                        .font(.system(.caption2, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(
                                            Capsule()
                                                .fill(Color.blue.opacity(0.1))
                                        )
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.secondary.opacity(0.05))
                            )
                        }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
        }
    }
}

struct ServiceSelectionButton: View {
    let service: APIManager.ServiceType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.blue : Color.secondary.opacity(0.3), lineWidth: 2)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(service.rawValue)
                            .font(.system(.body, design: .default))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        if service == .appleIntelligence {
                            Text("RECOMMENDED")
                                .font(.system(.caption2, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(Color.blue.opacity(0.15))
                                )
                        }
                    }
                    
                    Text(service.description)
                        .font(.system(.caption))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.08) : Color.secondary.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - API Keys Tab
struct APIKeysPreferencesTab: View {
    @EnvironmentObject var apiManager: APIManager
    @State private var apiKeys: [APIManager.ServiceType: String] = [:]
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PreferenceSection(title: "API Keys", icon: "key") {
                    Text("Enter your API keys for different transcription services")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 12) {
                        ForEach(APIManager.ServiceType.allCases.filter { service in
                            service != .appleIntelligence && service != .whisperLocal
                        }, id: \.self) { service in
                            APIKeyRow(
                                service: service,
                                apiKey: Binding(
                                    get: { apiKeys[service] ?? "" },
                                    set: { apiKeys[service] = $0 }
                                ),
                                onSave: { saveAPIKey(for: service) }
                            )
                        }
                    }
                }
                
                PreferenceSection(title: "Services Not Requiring Keys", icon: "info.circle") {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(
                            icon: "sparkles",
                            title: "Apple Intelligence",
                            description: "No API key required - uses built-in AI"
                        )
                        
                        InfoRow(
                            icon: "cpu",
                            title: "Local Whisper",
                            description: "No API key required - runs offline on your device"
                        )
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            loadAPIKeys()
        }
        .alert("API Key", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadAPIKeys() {
        for service in APIManager.ServiceType.allCases.filter({ $0 != .appleIntelligence && $0 != .whisperLocal }) {
            if let key = apiManager.getAPIKey(for: service) {
                apiKeys[service] = key
            }
        }
    }
    
    private func saveAPIKey(for service: APIManager.ServiceType) {
        if let key = apiKeys[service], !key.isEmpty {
            apiManager.setAPIKey(for: service, key: key)
            alertMessage = "API key saved for \(service.rawValue)"
            showingAlert = true
        } else {
            alertMessage = "Please enter a valid API key"
            showingAlert = true
        }
    }
}

struct APIKeyRow: View {
    let service: APIManager.ServiceType
    @Binding var apiKey: String
    let onSave: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(service.rawValue)
                    .font(.system(.body, design: .default))
                    .fontWeight(.medium)
            }
            .frame(width: 120, alignment: .leading)
            
            SecureField("Enter API key", text: $apiKey)
                .textFieldStyle(.roundedBorder)
            
            Button {
                onSave()
            } label: {
                Text("Save")
                    .font(.system(.body))
                    .frame(minWidth: 80)
            }
            .buttonStyle(.borderedProminent)
            .disabled(apiKey.isEmpty)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.04))
        )
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.body))
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.system(.caption))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.05))
        )
    }
}

// MARK: - History Tab
struct HistoryPreferencesTab: View {
    @EnvironmentObject var historyManager: TranscriptionHistoryManager
    @State private var showingExportSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            
                            Text("Transcription History")
                                .font(.system(.headline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button {
                                showingExportSheet = true
                            } label: {
                                Label("Export", systemImage: "square.and.arrow.up")
                                    .font(.system(.body))
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(historyManager.transcriptions.isEmpty)
                            
                            Button {
                                historyManager.clearAllTranscriptions()
                            } label: {
                                Label("Clear All", systemImage: "trash")
                                    .font(.system(.body))
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                            .disabled(historyManager.transcriptions.isEmpty)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 16)
            }
            
            if historyManager.transcriptions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "mic.slash")
                        .font(.system(size: 56))
                        .foregroundColor(.secondary.opacity(0.5))
                    
                    Text("No transcriptions yet")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("Start recording to see your transcription history here")
                        .font(.system(.caption))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(historyManager.transcriptions) { item in
                            HistoryItemCard(item: item, onDelete: {
                                historyManager.deleteTranscription(item)
                            })
                        }
                    }
                    .padding(24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingExportSheet) {
            ExportHistoryView()
                .environmentObject(historyManager)
        }
    }
}

struct HistoryItemCard: View {
    let item: TranscriptionHistoryItem
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text(item.timestamp, style: .date)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary.opacity(0.5))
                    
                    Text(item.timestamp, style: .time)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 12))
                        .foregroundColor(.red.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
            
            Text(item.text)
                .font(.system(.body))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.1), lineWidth: 1)
                )
        )
        .contextMenu {
            Button {
                NSPasteboard.general.setString(item.text, forType: .string)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
