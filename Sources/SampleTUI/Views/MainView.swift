import CoreUI
import TerminalUI

class MainView: View {
    func compose() -> any Widget {
        let size = RenderingContext.current!.terminalSize

        return Column {
            Text("Hello, world! The current terminal size is: \(size)")
        }
    }
}
