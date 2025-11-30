import CoreUI

public struct Text: Widget {
    public let content: String

    public init(_ content: String) {
        self.content = content
    }

    struct Measurer {
        struct Fragment {
            let content: String
            let position: Vec2
            let length: Int
        }

        let maxContainerWidth: Int
        var maxWidth: Int = 0
        var maxHeight: Int = 0
        var currentWidth: Int = 0
        var currentHeight: Int = 1

        var size: Vec2 { .init(x: Float(maxWidth), y: Float(maxHeight)) }

        mutating func addMeasurementFor(word: String) -> [Fragment] {
            var fragments: [Fragment] = []
            let length = word.count

            if length > maxContainerWidth && currentWidth == 0 {
                let bigLineCount = (length / maxContainerWidth) - 1

                // The word is too big to fit in the container, the size will automatically be the container width
                // and the wrapped line will give another line (:
                maxWidth = maxContainerWidth

                for i in 0...bigLineCount {
                    let start = word.index(word.startIndex, offsetBy: i * maxContainerWidth)
                    let end = word.index(word.startIndex, offsetBy: (i + 1) * maxContainerWidth)

                    fragments.append(
                        Fragment(
                            content: String(word[start..<end]),
                            position: .init(x: 0, y: Float(currentHeight + i)),
                            length: maxContainerWidth
                        )
                    )
                }

                currentHeight += bigLineCount
                currentWidth = length % maxContainerWidth

                let start = word.index(
                    word.startIndex, offsetBy: maxContainerWidth * (bigLineCount + 1))

                if currentWidth > 0 {
                    currentHeight += 1

                    fragments.append(
                        Fragment(
                            content: String(word[start...]),
                            position: .init(x: 0, y: Float(currentHeight)),
                            length: currentWidth
                        )
                    )
                }
            } else if length > maxContainerWidth && currentWidth > 0 {
                let oldWidth = currentWidth

                fragments.append(
                    Fragment(
                        content: String(),
                        position: .init(x: Float(currentWidth), y: Float(currentHeight)),
                        length: maxContainerWidth - currentWidth
                    )
                )

                currentHeight += 1
                currentWidth = (oldWidth + length) % (maxContainerWidth + 1)

                if currentWidth > 0 {
                    fragments.append(
                        Fragment(
                            content: String(word),
                            position: .init(x: 0, y: Float(currentHeight)),
                            length: currentWidth
                        )
                    )
                }
            } else if currentWidth + length > maxContainerWidth {
                fragments.append(
                    Fragment(
                        content: word,
                        position: .init(x: 0, y: Float(currentHeight + 1)),
                        length: length
                    )
                )

                currentWidth = length + 1
                currentHeight += 1
            } else {
                fragments.append(
                    Fragment(
                        content: word,
                        position: .init(x: Float(currentWidth), y: Float(currentHeight)),
                        length: length
                    )
                )

                currentWidth += length + 1
            }

            maxWidth = max(maxWidth, currentWidth)
            maxHeight = max(maxHeight, currentHeight)

            return fragments
        }
    }

    public func measure(constraints: SizeConstraints) -> Size {
        var measurer = Measurer(maxContainerWidth: Int(constraints.maximum.width))
        let words = content.split(separator: " ")

        for word in words {
            _ = measurer.addMeasurementFor(word: String(word))
        }

        return constraints.constrain(measurer.size)
    }

    public func render(frame rawFrame: any Frame) -> any RenderCommand {
        guard let frame = rawFrame as? TerminalFrame else {
            return NoOperation()
        }

        var measurer = Measurer(maxContainerWidth: Int(frame.width))
        var commands: [WriteStringCommand] = []

        let words = content.split(separator: " ")

        for word in words {
            let fragments = measurer.addMeasurementFor(word: String(word))
            let isLast = word == words.last

            for fragment in fragments {
                commands.append(
                    WriteStringCommand(
                        content: isLast ? fragment.content : "\(fragment.content) ",
                        origin: frame.origin,
                        at: fragment.position
                    )
                )
            }
        }

        return CompoundCommands(commands: commands)
    }

}
