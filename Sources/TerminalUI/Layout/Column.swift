import CoreUI

public struct Column: Widget {
    public let children: [any Widget]
    public let gap: Float

    public init(gap: Float = 0, @WidgetComposer content: () -> [any Widget]) {
        self.gap = gap
        self.children = content()
    }

    public func measure(constraints: SizeConstraints) -> Size {
        guard !children.isEmpty else {
            // TODO: add padding
            return .zero
        }

        var width: Float = 0
        var height: Float = 0

        let childConstraints = constraints.withUnboundedHeight()

        for child in children {
            let size = child.measure(constraints: childConstraints)

            width = max(size.width, width)
            height += size.height
        }

        height += gap * Float(children.count - 1)

        return constraints.constrain(width: width, height: height)
    }

    public func render(frame: any Frame) -> any RenderCommand {
        guard !children.isEmpty else {
            // TODO: add padding rendering of this box.
            return NoOperation()
        }

        var commands: [any RenderCommand] = []
        var currentY = frame.y

        let childConstraints = SizeConstraints(minimum: Size(x: 0, y: 0), maximum: frame.size)
            .withUnboundedHeight()

        for child in children {
            let position = Vec2(x: frame.x, y: currentY)
            let size = child.measure(constraints: childConstraints)
            let childFrame = TerminalFrame(position: position, size: size)

            commands.append(child.render(frame: childFrame))

            currentY += size.y + gap

            if currentY > frame.height { break }
        }

        return CompoundCommands(commands: commands)
    }
}
