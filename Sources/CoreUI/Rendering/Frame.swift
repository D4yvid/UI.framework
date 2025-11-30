// A frame is a place where a widget can render itself, it's like a Rect, but
// it will have more metadata about the rendering pass in renderer implementations, like
// the current frame of animation, etc
public protocol Frame: Sendable, Equatable, Hashable {
    var position: Vec2 { get }
    var size: Vec2 { get }

    var x: Float { get }
    var y: Float { get }

    var width: Float { get }
    var height: Float { get }

    var origin: Vec2 { get }
}
