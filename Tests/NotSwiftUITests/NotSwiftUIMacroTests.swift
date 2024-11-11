import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(NotSwiftUIMacros)
import NotSwiftUIMacros

let testMacros: [String: Macro.Type] = [
    "Entry": EntryMacro.self
]
#endif

final class NotSwiftUITests: XCTestCase {
    func testMacro() throws {
        #if canImport(NotSwiftUIMacros)
        assertMacroExpansion(
            """
            extension EnvironmentValues {
                @Entry
                var name: String?
            }
            """,
            expandedSource: """
            extension EnvironmentValues {
                var name: String?
                    {
                    get {
                        self[__Key_name.self]
                    }
                    set {
                        self[__Key_name.self] = newValue
                    }
                }
                private struct -_Key_name: SwiftUICore.EnvironmentKey {
                    typealias Value = String?
                    static var defaultValue: Value { nil }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
