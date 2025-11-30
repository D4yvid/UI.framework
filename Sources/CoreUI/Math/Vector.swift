import Foundation

public struct Vec2: Sendable, Equatable, Hashable, Codable {
    public static let zero = Vec2(x: 0, y: 0)
    public static let one = Vec2(x: 1, y: 1)
    public static let right = Vec2(x: 1, y: 0)
    public static let left = Vec2(x: -1, y: 0)
    public static let up = Vec2(x: 0, y: 1)
    public static let down = Vec2(x: 0, y: -1)

    public var x: Float
    public var y: Float

    public var width: Float {
        get { x }
        set(value) { x = value }
    }

    public var height: Float {
        get { y }
        set(value) { y = value }
    }

    public init(x: Float = 0, y: Float = 0) {
        self.x = x
        self.y = y
    }

    public init(width: Float = 0, height: Float = 0) {
        self.init(x: width, y: height)
    }

    public init(_ value: (Float, Float)) {
        self.x = value.0
        self.y = value.1
    }

    public init(_ scalar: Float) {
        self.x = scalar
        self.y = scalar
    }
}

extension Vec2 {
    public static func + (left: Vec2, right: Vec2) -> Vec2 {
        return .init(x: left.x + right.x, y: left.y + right.y)
    }

    public static func - (left: Vec2, right: Vec2) -> Vec2 {
        return .init(x: left.x - right.x, y: left.y - right.y)
    }

    public prefix static func - (operand: Vec2) -> Vec2 {
        return .init(x: -operand.x, y: -operand.y)
    }

    public static func * (left: Vec2, right: Vec2) -> Vec2 {
        return .init(x: left.x * right.x, y: left.y * right.y)
    }

    public static func / (left: Vec2, right: Vec2) -> Vec2 {
        return .init(x: left.x / right.x, y: left.y / right.y)
    }
}

extension Vec2 {
    public static func * (vector: Vec2, scalar: Float) -> Vec2 {
        return .init(x: vector.x * scalar, y: vector.y * scalar)
    }

    public static func * (scalar: Float, vector: Vec2) -> Vec2 {
        return vector * scalar
    }

    public static func / (vector: Vec2, scalar: Float) -> Vec2 {
        return .init(x: vector.x / scalar, y: vector.y / scalar)
    }
}

extension Vec2 {
    public static func += (left: inout Vec2, right: Vec2) { left = left + right }
    public static func -= (left: inout Vec2, right: Vec2) { left = left - right }
    public static func *= (left: inout Vec2, scalar: Float) { left = left * scalar }
    public static func /= (left: inout Vec2, scalar: Float) { left = left / scalar }
}

extension Vec2 {
    public var magnitude: Float {
        return sqrt(x * x + y * y)
    }

    public var magnitudeSquared: Float {
        return x * x + y * y
    }

    public var normalized: Vec2 {
        let len = magnitude
        return len > 0 ? self / len : .zero
    }

    public mutating func normalize() {
        self = normalized
    }

    public func limit(to maxLength: Float) -> Vec2 {
        if magnitudeSquared > maxLength * maxLength {
            return normalized * maxLength
        }
        return self
    }
}

extension Vec2 {
    public func dot(_ other: Vec2) -> Float {
        return (x * other.x) + (y * other.y)
    }

    public func cross(_ other: Vec2) -> Float {
        return (x * other.y) - (y * other.x)
    }

    public func distance(to other: Vec2) -> Float {
        return (self - other).magnitude
    }

    public func distanceSquared(to other: Vec2) -> Float {
        return (self - other).magnitudeSquared
    }

    public var angle: Float {
        return atan2(y, x)
    }
}

extension Vec2 {
    public static func lerp(start: Vec2, end: Vec2, t: Float) -> Vec2 {
        return start + (end - start) * t.clamped(to: 0...1)
    }
}

extension Vec2: CustomStringConvertible {
    public var description: String {
        return String(format: "Vec2(x: %.2f, y: %.2f)", x, y)
    }
}

extension Comparable {
    fileprivate func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
