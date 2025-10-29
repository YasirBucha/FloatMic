import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var floatingWindow: NSWindow?
    var statusItem: NSStatusItem?
    var audioRecorder: AudioRecorder?
    var transcriptionManager: TranscriptionManager?
    var apiManager: APIManager?
    var historyManager: TranscriptionHistoryManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize managers
        apiManager = APIManager()
        historyManager = TranscriptionHistoryManager()
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
        
        floatingWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
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
        
        // Position window in center of screen
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let windowSize = floatingWindow!.frame.size
            let x = (screenFrame.width - windowSize.width) / 2
            let y = (screenFrame.height - windowSize.height) / 2
            floatingWindow?.setFrameOrigin(NSPoint(x: x, y: y))
        }
        
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
    }
    
    @objc func showAPIKeys() {
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
    }
    
    @objc func showHistory() {
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
    }
    
    @objc func showPreferences() {
        let prefsView = PreferencesView()
            .environmentObject(apiManager!)
        
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
    }
}
