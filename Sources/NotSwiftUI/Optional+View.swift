extension Optional: View, BuiltinView where Wrapped: View {
    public typealias Body = Never

    func _buildNodeTree(_ node: Node) {
        self?.buildNodeTree(node)
    }
}
