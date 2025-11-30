import Swift

public struct SizeConstraints {
    public let minimum: Vec2
    public let maximum: Vec2

    public init(minimum: Vec2, maximum: Vec2) {
        self.minimum = minimum
        self.maximum = maximum
    }
}

extension SizeConstraints {
    public static func tight(_ size: Vec2) -> SizeConstraints {
        .init(minimum: size, maximum: size)
    }

    public static func tight(x: Float, y: Float) -> SizeConstraints {
        .tight(.init(x: x, y: y))
    }

    public static func loose(_ size: Vec2) -> SizeConstraints {
        .init(minimum: .zero, maximum: size)
    }

    public static func loose(x: Float, y: Float) -> SizeConstraints {
        .loose(.init(x: x, y: y))
    }

    public func withUnboundedHeight() -> SizeConstraints {
        SizeConstraints(
            minimum: .init(
                width: minimum.width,
                height: 0
            ),
            maximum: .init(
                width: maximum.width,
                height: .infinity
            )
        )
    }

    public func withUnboundedWidth() -> SizeConstraints {
        SizeConstraints(
            minimum: .init(
                width: 0,
                height: minimum.height
            ),
            maximum: .init(
                width: .infinity,
                height: maximum.height
            )
        )
    }

    public func constrain(x: Float = 0, y: Float = 0) -> Size {
        self.constrain(Size(x: x, y: y))
    }

    public func constrain(width: Float = 0, height: Float = 0) -> Size {
        self.constrain(Size(width: width, height: height))
    }

    public func constrain(_ size: Size) -> Size {
        Size(
            width: min(max(size.width, minimum.width), maximum.width),
            height: min(max(size.height, minimum.height), maximum.height)
        )
    }
}
