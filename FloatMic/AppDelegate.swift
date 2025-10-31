import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var floatingWindow: NSWindow?
    var modelSelectionWindow: NSWindow?
    var apiKeysWindow: NSWindow?
    var historyWindow: NSWindow?
    var preferencesWindow: NSWindow?
    var statusItem: NSStatusItem?
    var audioRecorder: AudioRecorder?
    var transcriptionManager: TranscriptionManager?
    var apiManager: APIManager?
    var historyManager: TranscriptionHistoryManager?
    var settingsManager: SettingsManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize managers
        apiManager = APIManager()
        historyManager = TranscriptionHistoryManager()
        settingsManager = SettingsManager()
        audioRecorder = AudioRecorder()
        transcriptionManager = TranscriptionManager(apiManager: apiManager!, historyManager: historyManager!)
        
        // Setup menu bar
        setupMenuBar()
        
        // Setup floating window
        setupFloatingWindow()
        
        // Setup global hotkeys
        setupGlobalHotkeys()
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "FloatMic")
            button.action = #selector(toggleFloatingWindow)
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Toggle Floating Mic", action: #selector(toggleFloatingWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Choose Model Source", action: #selector(showModelSelection), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Manage API Keys", action: #selector(showAPIKeys), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Transcription History", action: #selector(showHistory), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(showPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit FloatMic", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    func setupFloatingWindow() {
        let contentView = ContentView()
            .environmentObject(apiManager!)
            .environmentObject(transcriptionManager!)
            .environmentObject(audioRecorder!)
            .environmentObject(settingsManager!)
        
        let buttonSize = settingsManager?.buttonSize.size ?? 80
        floatingWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: buttonSize, height: buttonSize),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        floatingWindow?.contentView = NSHostingView(rootView: contentView)
        floatingWindow?.backgroundColor = .clear
        floatingWindow?.isOpaque = false
        floatingWindow?.hasShadow = true
        floatingWindow?.level = .floating
        floatingWindow?.collectionBehavior = [.canJoinAllSpaces, .stationary]
        floatingWindow?.isMovableByWindowBackground = true
        
        // Position window - restore from saved position or center on screen
        if let savedPosition = loadWindowPosition() {
            floatingWindow?.setFrameOrigin(savedPosition)
        } else if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let windowSize = floatingWindow!.frame.size
            let x = (screenFrame.width - windowSize.width) / 2
            let y = (screenFrame.height - windowSize.height) / 2
            floatingWindow?.setFrameOrigin(NSPoint(x: x, y: y))
        }
        
        // Save position when window moves
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidMove),
            name: NSWindow.didMoveNotification,
            object: floatingWindow
        )
        
        floatingWindow?.makeKeyAndOrderFront(nil)
    }
    
    func setupGlobalHotkeys() {
        // Register global hotkey for start/stop recording
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 36 { // Enter/Return key
                self.toggleRecording()
            }
        }
    }
    
    @objc func toggleFloatingWindow() {
        if let window = floatingWindow {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    @objc func toggleRecording() {
        audioRecorder?.toggleRecording()
    }
    
    @objc func showModelSelection() {
        // Reuse existing window if it exists
        if let existingWindow = modelSelectionWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }
        
        let modelView = ModelSelectionView()
            .environmentObject(apiManager!)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = NSHostingView(rootView: modelView)
        window.title = "Choose Model Source"
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        // Store reference and handle window closing
        modelSelectionWindow = window
        
        // Clean up when window closes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(modelSelectionWindowWillClose),
            name: NSWindow.willCloseNotification,
            object: window
        )
    }
    
    @objc private func modelSelectionWindowWillClose(_ notification: Notification) {
        modelSelectionWindow = nil
    }
    
    @objc func showAPIKeys() {
        // Reuse existing window if it exists
        if let existingWindow = apiKeysWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }
        
        let keysView = APIKeysView()
            .environmentObject(apiManager!)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = NSHostingView(rootView: keysView)
        window.title = "Manage API Keys"
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        apiKeysWindow = window
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(apiKeysWindowWillClose),
            name: NSWindow.willCloseNotification,
            object: window
        )
    }
    
    @objc private func apiKeysWindowWillClose(_ notification: Notification) {
        apiKeysWindow = nil
    }
    
    @objc func showHistory() {
        // Reuse existing window if it exists
        if let existingWindow = historyWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }
        
        let historyView = TranscriptionHistoryView()
            .environmentObject(historyManager!)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = NSHostingView(rootView: historyView)
        window.title = "Transcription History"
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        historyWindow = window
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(historyWindowWillClose),
            name: NSWindow.willCloseNotification,
            object: window
        )
    }
    
    @objc private func historyWindowWillClose(_ notification: Notification) {
        historyWindow = nil
    }
    
    @objc func showPreferences() {
        // Reuse existing window if it exists
        if let existingWindow = preferencesWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }
        
        let prefsView = PreferencesView()
            .environmentObject(apiManager!)
            .environmentObject(settingsManager!)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = NSHostingView(rootView: prefsView)
        window.title = "Preferences"
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        preferencesWindow = window
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(preferencesWindowWillClose),
            name: NSWindow.willCloseNotification,
            object: window
        )
    }
    
    @objc private func preferencesWindowWillClose(_ notification: Notification) {
        preferencesWindow = nil
    }
    
    // MARK: - Window Position Persistence
    
    private func loadWindowPosition() -> NSPoint? {
        guard let settings = settingsManager else { return nil }
        
        switch settings.multiDisplayMode {
        case .rememberPerDisplay:
            let displayID = settings.getCurrentDisplayID()
            if let position = settings.getPositionForDisplay(displayID) {
                return isPositionValid(position) ? position : nil
            }
            return nil
            
        case .constrainToVisible:
            let x = UserDefaults.standard.double(forKey: "floatingWindowX")
            let y = UserDefaults.standard.double(forKey: "floatingWindowY")
            if x != 0 || y != 0 {
                let point = NSPoint(x: x, y: y)
                return isPositionValid(point) ? point : nil
            }
            return nil
            
        case .alwaysCenter:
            return nil // Will center on main display
        }
    }
    
    private func saveWindowPosition(_ point: NSPoint) {
        guard let settings = settingsManager else { return }
        
        switch settings.multiDisplayMode {
        case .rememberPerDisplay:
            let displayID = settings.getCurrentDisplayID()
            settings.setPositionForDisplay(point, displayID: displayID)
            
        case .constrainToVisible, .alwaysCenter:
            UserDefaults.standard.set(point.x, forKey: "floatingWindowX")
            UserDefaults.standard.set(point.y, forKey: "floatingWindowY")
        }
    }
    
    private func isPositionValid(_ point: NSPoint) -> Bool {
        guard let screen = NSScreen.main else { return false }
        let screenFrame = screen.visibleFrame
        let windowSize = floatingWindow?.frame.size ?? NSSize(width: 100, height: 100)
        
        return point.x >= screenFrame.minX &&
               point.y >= screenFrame.minY &&
               point.x + windowSize.width <= screenFrame.maxX &&
               point.y + windowSize.height <= screenFrame.maxY
    }
    
    @objc private func windowDidMove() {
        if let window = floatingWindow {
            let snappedPosition = snapToEdges(window.frame.origin)
            if snappedPosition != window.frame.origin {
                window.setFrameOrigin(snappedPosition)
            }
            saveWindowPosition(snappedPosition)
        }
    }
    
    private func snapToEdges(_ position: NSPoint) -> NSPoint {
        guard let screen = NSScreen.main,
              let settings = settingsManager,
              settings.enableEdgeSnapping else { return position }
        let screenFrame = screen.visibleFrame
        let windowSize = floatingWindow?.frame.size ?? NSSize(width: 100, height: 100)
        let snapThreshold = settings.snapThreshold
        
        var newPosition = position
        
        // Snap to left edge
        if position.x <= screenFrame.minX + snapThreshold {
            newPosition.x = screenFrame.minX
        }
        // Snap to right edge
        else if position.x + windowSize.width >= screenFrame.maxX - snapThreshold {
            newPosition.x = screenFrame.maxX - windowSize.width
        }
        
        // Snap to top edge
        if position.y + windowSize.height >= screenFrame.maxY - snapThreshold {
            newPosition.y = screenFrame.maxY - windowSize.height
        }
        // Snap to bottom edge
        else if position.y <= screenFrame.minY + snapThreshold {
            newPosition.y = screenFrame.minY
        }
        
        return newPosition
    }
    
    deinit {
        // Clean up resources
        NotificationCenter.default.removeObserver(self)
        audioRecorder = nil
        transcriptionManager = nil
        apiManager = nil
        historyManager = nil
        floatingWindow = nil
        modelSelectionWindow = nil
        apiKeysWindow = nil
        historyWindow = nil
        preferencesWindow = nil
        statusItem = nil
    }
}
