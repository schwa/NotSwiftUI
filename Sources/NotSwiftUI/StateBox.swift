internal final class StateBox<Wrapped> {
    private weak var graph: Graph?
    private var _value: Wrapped
    private var dependencies: [WeakBox<Node>] = []
    var binding: Binding<Wrapped> = Binding(
        get: { fatalError("Empty Binding: get() called.") },
        set: { _ in fatalError("Empty Binding: set() called.") }
    )

    init(_ wrappedValue: Wrapped) {
        self._value = wrappedValue
        self.binding = Binding(get: { [unowned self] in
            self.wrappedValue
        }, set: { [unowned self] in
            self.wrappedValue = $0
        })
    }

    var wrappedValue: Wrapped {
        get {
            if graph == nil {
                graph = Graph.current
            }
            // Remove lazy values whose nodes have been deallocated
            dependencies = dependencies.filter { $0.wrappedValue != nil }
            guard let graph else {
                fatalError("StateBox used outside of Graph")
            }
            if let node = graph.activeNodeStack.last, dependencies.contains(where: { $0.wrappedValue === node }) == false {
                dependencies.append(WeakBox(node))
            }
            return _value
        }
        set {
            if graph == nil {
                graph = Graph.current
            }
            _value = newValue
            dependencies.compactMap { $0() }.forEach { $0.setNeedsRebuild() }
        }
    }
}
