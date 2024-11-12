public struct EmptyView: View {
    public typealias Body = Never

    public init() {
        // This line intentionally left blank.
    }
}

extension EmptyView: BodylessView {
    func _expandNode(_ node: Node) {
        // This line intentionally left blank.
    }
}
