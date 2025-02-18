// The Swift Programming Language
// https://docs.swift.org/swift-book
//
import Foundation

public protocol DependencyProviding {

    /// The associated type representing the type of the dependency injection key's value.
    associatedtype DependencyType

    /// The default value for the dependency injection key.
    static var dependency: Self.DependencyType { get set }
}

public struct Dependencies {
    
    nonisolated(unsafe) static var dependecies = Dependencies()
    
    public static subscript<K>(key: K.Type) -> K.DependencyType where K : DependencyProviding {
        get { key.dependency }
    }
    
    public static subscript<T>(_ keyPath: KeyPath<Dependencies, T>) -> T {
        get { dependecies[keyPath: keyPath] }
    }
}

@propertyWrapper
public struct Dependency<T>: Sendable {
    private let keyPath: KeyPath<Dependencies, T>
    
    public var wrappedValue: T {
        get { Dependencies[keyPath] }
    }
    
    public init(_ keyPath: KeyPath<Dependencies, T>) {
        self.keyPath = keyPath
    }
}

extension KeyPath: @unchecked Sendable {
    
}

