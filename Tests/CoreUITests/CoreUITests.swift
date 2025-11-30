import Testing

@testable import CoreUI

@Suite("Constraints")
struct ConstraintsTest {
    @Test("Tight constraints")
    func tightConstraints() {
        let tightConstraint = SizeConstraints.tight(x: 640, y: 480)

        #expect(
            tightConstraint.constrain(Size(50)) == tightConstraint.maximum,
            "It's tight, so it should always be 640, 480")

        #expect(
            tightConstraint.constrain(Size(10)) == tightConstraint.minimum,
            "It's tight, so it should always be 640, 480")
    }

    @Test("Loose constraints")
    func looseConstraints() {
        let looseConstraint = SizeConstraints.loose(x: 200, y: 100)

        #expect(
            looseConstraint.constrain(x: 10, y: 10) == Size(x: 10, y: 10),
            "The constraint is loose, so it can be anything but not bigger than maximum")

        #expect(
            looseConstraint.constrain(x: 500, y: 300) == looseConstraint.maximum,
            "The constraint is loose, so it should not be bigger than the maximum")
    }
}

// This one was made with AI, i'm sorry, i don't want to write tests for a math vector :c
@Suite("Vec2 Tests")
struct Vec2Tests {

    // MARK: - Initialization & Constants
    @Test("Initialization and Static Constants")
    func testInit() {
        let v = Vec2(x: 1, y: 2)
        #expect(v.x == 1)
        #expect(v.y == 2)

        let vTuple = Vec2((3, 4))
        #expect(vTuple.x == 3)
        #expect(vTuple.y == 4)

        let vScalar = Vec2(5)
        #expect(vScalar.x == 5)
        #expect(vScalar.y == 5)

        #expect(Vec2.zero == Vec2(x: 0, y: 0))
        #expect(Vec2.one == Vec2(x: 1, y: 1))
        #expect(Vec2.right == Vec2(x: 1, y: 0))
    }

    // MARK: - Arithmetic
    @Test("Vector Arithmetic (+, -, *, /)")
    func testArithmetic() {
        let v1 = Vec2(x: 2, y: 3)
        let v2 = Vec2(x: 4, y: 5)

        // Addition
        #expect((v1 + v2) == Vec2(x: 6, y: 8))

        // Subtraction
        #expect((v2 - v1) == Vec2(x: 2, y: 2))

        // Component-wise Multiplication
        #expect((v1 * v2) == Vec2(x: 8, y: 15))

        // Component-wise Division
        let v3 = Vec2(x: 10, y: 20)
        let v4 = Vec2(x: 2, y: 4)
        #expect((v3 / v4) == Vec2(x: 5, y: 5))
    }

    @Test("Scalar Arithmetic")
    func testScalarArithmetic() {
        let v = Vec2(x: 2, y: 4)

        // Multiply
        #expect((v * 2.0) == Vec2(x: 4, y: 8))
        #expect((3.0 * v) == Vec2(x: 6, y: 12))  // Commutative check

        // Divide
        #expect((v / 2.0) == Vec2(x: 1, y: 2))
    }

    @Test("Mutating Operators (+=, *=)")
    func testMutatingOps() {
        var v = Vec2(x: 1, y: 1)
        v += Vec2(x: 2, y: 2)
        #expect(v == Vec2(x: 3, y: 3))

        v *= 2
        #expect(v == Vec2(x: 6, y: 6))
    }

    // MARK: - Geometry
    @Test("Magnitude and Normalization")
    func testGeometry() {
        // 3-4-5 Triangle
        let v = Vec2(x: 3, y: 4)

        #expect(v.magnitude == 5)
        #expect(v.magnitudeSquared == 25)

        // Normalization
        // (3, 4) normalized is (0.6, 0.8)
        let normalized = v.normalized
        #expect(normalized.x.isApprox(0.6))
        #expect(normalized.y.isApprox(0.8))
        #expect(normalized.magnitude.isApprox(1.0))
    }

    @Test("Normalization of Zero")
    func testZeroNormalization() {
        // Should not crash and return zero
        let v = Vec2.zero
        #expect(v.normalized == .zero)
    }

    @Test("Limit")
    func testLimit() {
        let v = Vec2(x: 10, y: 0)

        // Limit is higher than length, no change
        #expect(v.limit(to: 20) == v)

        // Limit is lower, should clamp
        let limited = v.limit(to: 5)
        #expect(limited.magnitude.isApprox(5))
        #expect(limited.x.isApprox(5))
    }

    // MARK: - Linear Algebra
    @Test("Dot and Cross Product")
    func testDotCross() {
        let up = Vec2.up  // (0, 1)
        let right = Vec2.right  // (1, 0)

        // Perpendicular vectors dot product is 0
        #expect(up.dot(right) == 0)

        // Parallel vectors dot product is 1 * 1 = 1
        #expect(up.dot(up) == 1)

        // Cross Product (2D Z-component)
        // Right cross Up should be positive Z (1)
        #expect(right.cross(up) == 1)
        // Up cross Right should be negative Z (-1)
        #expect(up.cross(right) == -1)
    }

    @Test("Distance")
    func testDistance() {
        let v1 = Vec2(x: 0, y: 0)
        let v2 = Vec2(x: 0, y: 10)

        #expect(v1.distance(to: v2) == 10)
        #expect(v1.distanceSquared(to: v2) == 100)
    }

    @Test("Angle")
    func testAngle() {
        let right = Vec2.right
        let up = Vec2.up

        #expect(right.angle == 0)
        #expect(up.angle.isApprox(Float.pi / 2))  // 90 degrees
    }

    // MARK: - Utilities
    @Test("Lerp (Linear Interpolation)")
    func testLerp() {
        let start = Vec2(x: 0, y: 0)
        let end = Vec2(x: 10, y: 10)

        // 0%
        #expect(Vec2.lerp(start: start, end: end, t: 0) == start)

        // 100%
        #expect(Vec2.lerp(start: start, end: end, t: 1) == end)

        // 50%
        let mid = Vec2.lerp(start: start, end: end, t: 0.5)
        #expect(mid == Vec2(x: 5, y: 5))

        // Clamped (t = 2.0 should behave like t = 1.0)
        #expect(Vec2.lerp(start: start, end: end, t: 2.0) == end)
    }
}

extension Float {
    fileprivate func isApprox(_ other: Float, tolerance: Float = 0.0001) -> Bool {
        return abs(self - other) < tolerance
    }
}
