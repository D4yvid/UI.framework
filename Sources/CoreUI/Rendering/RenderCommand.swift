/// A render command, specific implementations will have specific render commands,
/// and ways to use them, so nothing is needed here, only the definition is sufficient
/// for the type. How a render command will be used, is defined by implementations
public protocol RenderCommand: Sendable {
    mutating func render(frame: inout any Frame) -> Bool
}

public struct NoOperation: RenderCommand {
    public init() {}

    public func render(frame: inout any Frame) -> Bool {
        _ = frame

        return true
    }
}

public struct CompoundCommands: RenderCommand {
    public var commands: [any RenderCommand]

    public init(commands: [any RenderCommand]) {
        self.commands = commands
    }

    public mutating func render(frame: inout any Frame) -> Bool {
        for var cmd in commands {
            _ = cmd.render(frame: &frame)
        }

        return true
    }
}
