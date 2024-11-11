import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// @attached(accessor) @attached(peer, names: prefixed(__Key_))
// public macro Entry() = #externalMacro(module: "NotSwiftUIMacros", type: "EntryMacro")

public struct EntryMacro {
}

extension EntryMacro: AccessorMacro {
    public static func expansion(of node: AttributeSyntax, providingAccessorsOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [AccessorDeclSyntax] {
        // TODO: '@Entry' macro can only attach to var declarations inside extensions of EnvironmentValues, Transaction, ContainerValues, or FocusedValues
        guard case let .argumentList(arguments) = node.arguments, let argument = arguments.first else {
            return []
        }
        return [
          """
          get { self[\(argument.expression)] }
          """,
          """
          set { self[\(argument.expression)] = newValue }
          """
        ]
    }
}

extension EntryMacro: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let identified = declaration.asProtocol(NamedDeclSyntax.self) else {
            return []
        }
        let name = identified.name.text
        let type = "String?" // TODO:
        let defaultValue = "nil" // TODO:
        return ["""
        private struct __Key_\(raw: name): EnvironmentKey {
            typealias Value = \(raw: type)
            static var defaultValue: Value { \(raw: defaultValue) }
        }
        """]
    }
}
