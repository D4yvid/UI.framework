/// This should allow us to build some UIs like:
/// Column {
///   Text("Hello, world!")
///
///   Row {
///     Text("Hi")
///     Text(", how are you?")
///   }
/// }
@resultBuilder
public struct WidgetComposer {
    public static func buildBlock(_ component: any Widget) -> [any Widget] {
        [component]
    }

    public static func buildPartialBlock(first: [any Widget]) -> [any Widget] {
        first
    }

    public static func buildBlock() -> [any Widget] {
        []
    }

    public static func buildBlock(_ components: any Widget...) -> [any Widget] {
        components
    }

    public static func buildBlock(_ components: [any Widget]...) -> [any Widget] {
        components.flatMap { $0 }
    }

    public static func buildEither(first component: [any Widget]) -> [any Widget] {
        component
    }

    public static func buildEither(second component: [any Widget]) -> [any Widget] {
        component
    }

    public static func buildOptional(_ component: [any Widget]?) -> [any Widget] {
        component ?? []
    }

    public static func buildOptional(_ component: (any Widget)?) -> [any Widget] {
        component == nil ? [component!] : []
    }

    public static func buildArray(_ components: [[any Widget]]) -> [any Widget] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: any Widget) -> [any Widget] {
        [expression]
    }

    public static func buildExpression(_ expression: [any Widget]) -> [any Widget] {
        expression
    }
}
