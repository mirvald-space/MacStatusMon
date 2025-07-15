import Cocoa
import Foundation

class MacStatusMon: NSObject {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer: Timer?
    
    override init() {
        super.init()
        setupStatusItem()
        startMonitoring()
    }
    
    func setupStatusItem() {
        statusItem.button?.title = "Loading..."
        
        let menu = NSMenu()
        
        let updateItem = NSMenuItem(title: "Refresh", action: #selector(updateStats), keyEquivalent: "r")
        updateItem.target = self
        menu.addItem(updateItem)
        
        let restartItem = NSMenuItem(title: "Restart", action: #selector(restart), keyEquivalent: "p")
        restartItem.target = self
        menu.addItem(restartItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.updateStats()
        }
        updateStats()
    }
    
    @objc func updateStats() {
        let cpu = getCPUUsage()
        let (used, total) = getMemoryInfo()
        statusItem.button?.title = "CPU: \(cpu)% RAM: \(used)/\(total)GB"
    }
    
    func getCPUUsage() -> Int {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "top -l 1 | grep 'CPU usage' | awk '{print $3}' | sed 's/%//'"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        
        return Int(Double(output) ?? 0)
    }
    
    func getMemoryInfo() -> (String, String) {
        // Получаем общее количество памяти
        let totalMemoryTask = Process()
        totalMemoryTask.launchPath = "/bin/sh"
        totalMemoryTask.arguments = ["-c", "sysctl hw.memsize | awk '{print $2}'"]
        
        let totalMemoryPipe = Pipe()
        totalMemoryTask.standardOutput = totalMemoryPipe
        totalMemoryTask.launch()
        
        let totalMemoryData = totalMemoryPipe.fileHandleForReading.readDataToEndOfFile()
        let totalMemoryOutput = String(data: totalMemoryData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        let totalMemoryBytes = Double(totalMemoryOutput) ?? 0
        let totalMemoryGB = totalMemoryBytes / (1024 * 1024 * 1024)
        
        // Получаем используемую память
        let task = Process()
        task.launchPath = "/usr/bin/vm_stat"
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        let pageSize = 4096 // стандартный размер страницы памяти на macOS
        
        var activePages = 0
        var inactivePages = 0
        var wiredPages = 0
        var compressedPages = 0
        
        for line in output.components(separatedBy: "\n") {
            if line.contains("Pages active:") {
                let parts = line.components(separatedBy: ":")
                if parts.count >= 2 {
                    let valueStr = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ".", with: "")
                    activePages = Int(valueStr) ?? 0
                }
            } else if line.contains("Pages inactive:") {
                let parts = line.components(separatedBy: ":")
                if parts.count >= 2 {
                    let valueStr = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ".", with: "")
                    inactivePages = Int(valueStr) ?? 0
                }
            } else if line.contains("Pages wired down:") {
                let parts = line.components(separatedBy: ":")
                if parts.count >= 2 {
                    let valueStr = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ".", with: "")
                    wiredPages = Int(valueStr) ?? 0
                }
            } else if line.contains("Pages occupied by compressor:") {
                let parts = line.components(separatedBy: ":")
                if parts.count >= 2 {
                    let valueStr = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ".", with: "")
                    compressedPages = Int(valueStr) ?? 0
                }
            }
        }
        
        let usedPages = activePages + wiredPages + compressedPages
        let usedMemoryGB = Double(usedPages * pageSize) / (1024 * 1024 * 1024)
        
        return (String(format: "%.1f", usedMemoryGB), String(format: "%.1f", totalMemoryGB))
    }
    
    @objc func restart() {
        let executablePath = Bundle.main.executablePath ?? ""
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [executablePath]
        
        // Запускаем новый процесс
        task.launch()
        
        // Завершаем текущий процесс
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.quit()
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var monitor: MacStatusMon?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor = MacStatusMon()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
