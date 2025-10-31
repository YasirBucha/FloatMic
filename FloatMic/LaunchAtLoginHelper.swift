import Foundation
import ServiceManagement

@available(macOS 13.0, *)
class LaunchAtLoginHelper {
    static let shared = LaunchAtLoginHelper()
    
    private init() {}
    
    func isEnabled() -> Bool {
        return SMAppService.mainApp.status == .enabled
    }
    
    func setEnabled(_ enabled: Bool) -> Bool {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            return true
        } catch {
            print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
            return false
        }
    }
}

