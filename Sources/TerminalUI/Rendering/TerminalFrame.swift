import CoreUI
import Foundation

public struct TerminalFrame: Frame, CustomStringConvertible {
    public var position: Vec2
    public var size: Vec2

    public var x: Float { position.x }
    public var y: Float { position.y }
    public var width: Float { size.width }
    public var height: Float { size.height }

    public var origin: Vec2 { position }

    public var buffer: [String]

    public var description: String {
        "\(buffer)"
    }

    public init(position: Vec2 = .zero, size: Vec2 = .zero) {
        self.position = position
        self.size = size

        self.buffer = .init(
            repeating: "",
            count: Int(size.height * size.width)
        )
    }

    public init(x: Float = 0, y: Float = 0, width: Float = 0, height: Float = .zero) {
        self.position = .init(x: x, y: y)
        self.size = .init(width: width, height: height)

        self.buffer = .init(
            repeating: .init(repeating: "", count: Int(size.width)),
            count: Int(size.height)
        )
    }

    public func draw() throws {
        for y in 0..<Int(self.height) {
            let start = Int(y) * Int(width)
            let end = start + Int(width)

            let line = buffer[start..<end]
            var hasPrevious = false

            for (idx, chr) in line.enumerated() {
                if chr.isEmpty {
                    hasPrevious = false

                    continue
                }

                if hasPrevious {
                    let data = chr.data(using: .utf8)!

                    try FileHandle.standardOutput.write(contentsOf: data)
                } else {
                    let data = "\u{1b}[\(y + 1);\(idx + 1)H\(chr)".data(using: .utf8)!

                    try FileHandle.standardOutput.write(contentsOf: data)

                    hasPrevious = true
                }
            }
        }

        try FileHandle.standardOutput.synchronize()
    }

}
