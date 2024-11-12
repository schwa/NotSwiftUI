public struct Button: View, BuiltinView {
    public typealias Body = Never

    public private(set) var title: String
    public private(set) var action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    func _buildNodeTree(_ node: Node) {
        // todo create a UIButton
    }
}
