import CoreUI
import Foundation
import Testing

@testable import TerminalUI

@Suite("Terminal rendering context tests")
struct ContextTests {
    @Test("Test creation")
    func testContextCreation() {
        let size = Size(width: 24, height: 12)
        let context = RenderingContext(terminalSize: size)

        #expect(context.terminalSize == size, "This should obviously be that size")

        context.makeCurrent {
            #expect(RenderingContext.current == context, "This should be our own context now")
        }
    }
}

@Suite("Measurement tests")
struct MeasurementTests {
    @Test("Measurement of Text")
    func textMeasurement() {
        var text = Text("Hello, world!")

        // "Hello," is 6 characters and will fit (+ space = 7), but "world!" will not, so it does need
        // to be in the next line, that's why the `y` is 2
        #expect(text.measure(constraints: .loose(x: 10, y: 2)) == Vec2(x: 7, y: 2))

        // "Hello," is 6 characters and will fit (+ space = 7), but "world!" will not, so it does need
        // to be in the next line, but, because there's no more space, it should have only one line
        #expect(text.measure(constraints: .loose(x: 10, y: 1)) == Vec2(x: 7, y: 1))

        text = Text("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

        // The text should be splitted in two lines, with a hard break
        #expect(text.measure(constraints: .loose(x: 19, y: 2)) == Vec2(x: 19, y: 2))

        text = Text("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

        // The text should be splitted in two lines, with a hard break and have one single character at the third line
        #expect(text.measure(constraints: .loose(x: 19, y: 3)) == Vec2(x: 19, y: 3))
    }
}

@Suite("Rendering tests")
struct RenderingTests {
    @Test("Text rendering")
    func textRendering() {
        for width in 10..<25 {
            let ui = Column {
                Text("Hello, world!")
                Text("World, hello.")
                Text("This should wrap really well :)")
                Text("Width: \(width)")
            }

            let context = RenderingContext(
                terminalSize: .init(width: Float(width), height: 10))

            var frame = context.makeFrame() as any Frame

            context.render(widget: ui, frame: &frame)

            (frame as! TerminalFrame).draw()
        }
    }
}
