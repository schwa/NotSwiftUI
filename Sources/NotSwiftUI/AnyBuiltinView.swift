/// A type-erased View wrapper that converts a View to a BuiltinView.
internal struct AnyBuiltinView: BuiltinView {
    private var buildNodeTree: (Node) -> ()
    internal var kind: Any

    @MainActor
    init<V: View>(_ view: V) {
        buildNodeTree = view.buildNodeTree(_:)
        kind = type(of: view)
    }

    @MainActor
    func _buildNodeTree(_ node: Node) {
        buildNodeTree(node)
    }
}
