import CoreUI

public struct RenderingContext: Sendable, Equatable {
    @TaskLocal
    public static var current: Self? = nil

    public let terminalSize: Size

    public init(terminalSize: Size = .zero) {
        self.terminalSize = terminalSize
    }

    public func makeCurrent<T: Any>(scope: () -> T) -> T {
        Self.$current.withValue(self, operation: scope)
    }

    public func makeFrame() -> TerminalFrame {
        .init(position: .zero, size: terminalSize)
    }

    public func render(widget: any Widget, frame: inout any Frame) {
        if RenderingContext.current != self {
            self.makeCurrent {
                var command = widget.render(frame: frame)

                if !command.render(frame: &frame) {
                    fatalError("Failed to render (TEMPORARY)")
                }
            }

            return
        }

        var command = widget.render(frame: frame)

        if !command.render(frame: &frame) {
            fatalError("Failed to render (TEMPORARY)")
        }
    }
}
