import SwiftUI

struct APIKeysView: View {
    @EnvironmentObject var apiManager: APIManager
    @State private var apiKeys: [APIManager.ServiceType: String] = [:]
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Manage API Keys")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Enter your API keys for different transcription services:")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(APIManager.ServiceType.allCases, id: \.self) { service in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(service.rawValue)
                                .fontWeight(.medium)
                            
                            if service == .appleIntelligence {
                                Text("RECOMMENDED")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        
                        if service == .appleIntelligence {
                            Text("No API key required - uses Apple's built-in AI")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 8)
                        } else {
                            HStack {
                                SecureField("Enter API key", text: Binding(
                                    get: { apiKeys[service] ?? "" },
                                    set: { apiKeys[service] = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button("Save") {
                                    saveAPIKey(for: service)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
        for service in APIManager.ServiceType.allCases {
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
