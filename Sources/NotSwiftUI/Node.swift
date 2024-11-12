internal final class Node {
    weak var graph: Graph?
    var children: [Node] = []
    var needsRebuild = true
    var view: (any View)?
    var previousView: Any?
    var stateProperties: [String: Any] = [:]
    var environmentValues = EnvironmentValues()

    init() {
    }

    init(graph: Graph?) {
        assert(graph != nil)
        self.graph = graph
    }

    @MainActor
    func rebuildIfNeeded() {
        view?.buildNodeTree(self)
    }

    func setNeedsRebuild() {
        needsRebuild = true
    }
}

// MARK: -

internal extension Node {
    @MainActor
    func dump(depth: Int = 0) {
        let indent = String(repeating: "  ", count: depth)

        if let view = view as? AnyBuiltinView {
            print("\(indent)\(String(describing: view.viewType))")
        }
        else if let view {
            print("\(indent)\(String(describing: view))")
        }
        else {
            print("\(indent)<no view!>")
        }

        for child in children {
            child.dump(depth: depth + 1)
        }
    }
}
