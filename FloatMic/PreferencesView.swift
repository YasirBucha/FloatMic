import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var apiManager: APIManager
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
