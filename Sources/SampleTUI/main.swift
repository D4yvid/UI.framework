import CoreUI
import Foundation
import TerminalUI

let app = Application()

atexit {
    app.beforeExit()
}

signal(SIGWINCH) { signal in
    _ = signal

    var winsz = winsize()
    let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsz)

    if result != 0 {
        return
    }

    app.onTerminalSizeChange(width: Int(winsz.ws_col), height: Int(winsz.ws_row))
}

let signals = [SIGINT, SIGTERM]

for sig in signals {
    signal(sig) { _ in
        app.onInterruption()
    }
}

app.start()
