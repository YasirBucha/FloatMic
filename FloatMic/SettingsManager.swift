import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    @Published var buttonSize: ButtonSize = .medium
    @Published var buttonColor: String = "aaca52"
    @Published var enableEdgeSnapping: Bool = true
    @Published var snapThreshold: CGFloat = 20.0
    
    enum ButtonSize: String, CaseIterable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        
        var size: CGFloat {
            switch self {
            case .small: return 60
            case .medium: return 80
            case .large: return 100
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 24
            case .medium: return 32
            case .large: return 40
            }
        }
    }
    
    init() {
        loadSettings()
    }
    
    func setButtonSize(_ size: ButtonSize) {
        buttonSize = size
        saveSettings()
    }
    
    func setButtonColor(_ color: String) {
        buttonColor = color
        saveSettings()
    }
    
    func setEdgeSnapping(_ enabled: Bool) {
        enableEdgeSnapping = enabled
        saveSettings()
    }
    
    func setSnapThreshold(_ threshold: CGFloat) {
        snapThreshold = threshold
        saveSettings()
    }
    
    private func loadSettings() {
        if let sizeString = UserDefaults.standard.string(forKey: "buttonSize"),
           let size = ButtonSize(rawValue: sizeString) {
            buttonSize = size
        }
        
        if let color = UserDefaults.standard.string(forKey: "buttonColor") {
            buttonColor = color
        }
        
        enableEdgeSnapping = UserDefaults.standard.bool(forKey: "enableEdgeSnapping")
        snapThreshold = UserDefaults.standard.double(forKey: "snapThreshold") != 0 ? 
            UserDefaults.standard.double(forKey: "snapThreshold") : 20.0
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(buttonSize.rawValue, forKey: "buttonSize")
        UserDefaults.standard.set(buttonColor, forKey: "buttonColor")
        UserDefaults.standard.set(enableEdgeSnapping, forKey: "enableEdgeSnapping")
        UserDefaults.standard.set(snapThreshold, forKey: "snapThreshold")
    }
}
