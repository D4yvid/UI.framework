public protocol Widget: Sendable {
    func measure(constraints: SizeConstraints) -> Size
    func render(frame: any Frame) -> any RenderCommand
}
