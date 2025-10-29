import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var apiManager: APIManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedService: APIManager.ServiceType
    
    init() {
        _selectedService = State(initialValue: .appleIntelligence)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Preferences")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Transcription Service")
                        .fontWeight(.medium)
                    
                    Picker("Service", selection: $selectedService) {
                        ForEach(APIManager.ServiceType.allCases, id: \.self) { service in
                            Text(service.rawValue).tag(service)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedService) { newValue in
                        apiManager.setSelectedService(newValue)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Service Priority")
                        .fontWeight(.medium)
                    
                    Text("The app will try services in this order:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(apiManager.getAvailableServices(), id: \.self) { service in
                            HStack {
                                Text("\(apiManager.getAvailableServices().firstIndex(of: service)! + 1).")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Button Settings")
                        .fontWeight(.medium)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Size:")
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
                            TextField("Hex Color", text: Binding(
                                get: { settingsManager.buttonColor },
                                set: { settingsManager.setButtonColor($0) }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            
                            Circle()
                                .fill(Color(hex: settingsManager.buttonColor))
                                .frame(width: 20, height: 20)
                        }
                        
                        Toggle("Enable Edge Snapping", isOn: Binding(
                            get: { settingsManager.enableEdgeSnapping },
                            set: { settingsManager.setEdgeSnapping($0) }
                        ))
                        
                        if settingsManager.enableEdgeSnapping {
                            HStack {
                                Text("Snap Distance:")
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Multi-Display Settings")
                        .fontWeight(.medium)
                    
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("About FloatMic")
                        .fontWeight(.medium)
                    
                    Text("FloatMic v1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("A floating microphone app for instant speech-to-text transcription")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            selectedService = apiManager.selectedService
        }
    }
}
