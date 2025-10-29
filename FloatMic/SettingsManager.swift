import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    @Published var buttonSize: ButtonSize = .medium
    @Published var buttonColor: String = "aaca52"
    @Published var enableEdgeSnapping: Bool = true
    @Published var snapThreshold: CGFloat = 20.0
    @Published var multiDisplayMode: MultiDisplayMode = .rememberPerDisplay
    @Published var displayPositions: [String: NSPoint] = [:]
    
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
    
    enum MultiDisplayMode: String, CaseIterable {
        case rememberPerDisplay = "Remember Per Display"
        case constrainToVisible = "Constrain to Visible Frame"
        case alwaysCenter = "Always Center"
        
        var description: String {
            switch self {
            case .rememberPerDisplay:
                return "Remember button position for each display separately"
            case .constrainToVisible:
                return "Keep button within visible screen bounds"
            case .alwaysCenter:
                return "Always center button on main display"
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
    
    func setMultiDisplayMode(_ mode: MultiDisplayMode) {
        multiDisplayMode = mode
        saveSettings()
    }
    
    func setPositionForDisplay(_ position: NSPoint, displayID: String) {
        displayPositions[displayID] = position
        saveSettings()
    }
    
    func getPositionForDisplay(_ displayID: String) -> NSPoint? {
        return displayPositions[displayID]
    }
    
    func getCurrentDisplayID() -> String {
        guard let screen = NSScreen.main else { return "main" }
        return "\(screen.frame.origin.x)_\(screen.frame.origin.y)_\(screen.frame.size.width)_\(screen.frame.size.height)"
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
        
        if let modeString = UserDefaults.standard.string(forKey: "multiDisplayMode"),
           let mode = MultiDisplayMode(rawValue: modeString) {
            multiDisplayMode = mode
        }
        
        // Load display positions
        if let data = UserDefaults.standard.data(forKey: "displayPositions"),
           let positions = try? JSONDecoder().decode([String: NSPoint].self, from: data) {
            displayPositions = positions
        }
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(buttonSize.rawValue, forKey: "buttonSize")
        UserDefaults.standard.set(buttonColor, forKey: "buttonColor")
        UserDefaults.standard.set(enableEdgeSnapping, forKey: "enableEdgeSnapping")
        UserDefaults.standard.set(snapThreshold, forKey: "snapThreshold")
        UserDefaults.standard.set(multiDisplayMode.rawValue, forKey: "multiDisplayMode")
        
        // Save display positions
        if let data = try? JSONEncoder().encode(displayPositions) {
            UserDefaults.standard.set(data, forKey: "displayPositions")
        }
    }
}
