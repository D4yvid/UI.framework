import CoreUI
import Foundation

public struct WriteStringCommand: RenderCommand {
    public let content: String
    public let at: Vec2
    public var origin: Vec2

    public init(content: String, origin: Vec2, at: Vec2) {
        self.content = content
        self.origin = origin
        self.at = at
    }

    public mutating func render(frame rawFrame: inout any Frame) -> Bool {
        guard var frame = rawFrame as? TerminalFrame else {
            return false
        }

        for (idx, letter) in self.content.enumerated() {
            let position = self.origin + self.at

            if position.y > frame.height || position.y < 0 || position.x > frame.width
                || position.x < 0
            {
                continue
            }

            let y = Int(floor(position.y - 1)) * Int(frame.width)
            let x = Int(floor(position.x)) + idx

            frame.buffer[y + x] = "\(letter)"
        }

        rawFrame = frame

        return true
    }
}
