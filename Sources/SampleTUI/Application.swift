import Atomics
import CoreUI
import Foundation
import TerminalUI

class Application {
    private var running: ManagedAtomic<Bool> = .init(false)
    private var terminalSize: Size = .zero
    private var currentView: (any View)? = nil

    func start() {
        // Get terminal size
        var winsz = winsize()
        let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsz)

        if result != 0 {
            print("WARN: failed to get terminal size. using default of 80x24")

            self.terminalSize = .init(width: 80, height: 24)
        } else {
            self.terminalSize = .init(width: Float(winsz.ws_col), height: Float(winsz.ws_row))
        }

        self.currentView = MainView()

        // Start ts
        running.store(true, ordering: .sequentiallyConsistent)

        // First render
        self.render()

        while running.load(ordering: .sequentiallyConsistent) {
        }

        print("Quitting.")
    }

    func beforeExit() {
    }

    func onTerminalSizeChange(width: Int, height: Int) {
        self.terminalSize = .init(width: Float(width), height: Float(height))

        self.render()
    }

    func render() {
        let context = self.makeContext()

        context.makeCurrent {
            guard let ui = self.currentView?.compose() else { return }

            var frame: any Frame = context.makeFrame()

            context.render(widget: ui, frame: &frame)

            guard let terminalFrame = frame as? TerminalFrame else {
                return
            }

            print("\u{1b}[H\u{1b}[2J\u{1b}[3J")
            try! terminalFrame.draw()
        }
    }

    func onInterruption() {
        running.store(false, ordering: .sequentiallyConsistent)
    }

    private func makeContext() -> RenderingContext {
        .init(terminalSize: terminalSize)
    }
}
