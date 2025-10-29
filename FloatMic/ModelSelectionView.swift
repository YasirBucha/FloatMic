import SwiftUI

struct ModelSelectionView: View {
    @EnvironmentObject var apiManager: APIManager
    @State private var selectedService: APIManager.ServiceType
    
    init() {
        _selectedService = State(initialValue: .appleIntelligence)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose Transcription Model")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Select which service to use for speech-to-text transcription:")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(APIManager.ServiceType.allCases, id: \.self) { service in
                    HStack {
                        Button(action: {
                            selectedService = service
                            apiManager.setSelectedService(service)
                        }) {
                            HStack {
                                Image(systemName: selectedService == service ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedService == service ? .blue : .gray)
                                
                                VStack(alignment: .leading, spacing: 4) {
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
                                    
                                    Text(service.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedService == service ? Color.blue.opacity(0.1) : Color.clear)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
