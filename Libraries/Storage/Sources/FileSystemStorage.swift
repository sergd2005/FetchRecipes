//
//  FileSystemStorage.swift
//  Storage
//
//  Created by Sergii D on 2/18/25.
//

import Foundation

public final class FileSystemStorage: StorageProviding {
    
    let storageURL: URL
    
    public init() {
        storageURL = FileManager.default.temporaryDirectory.appending(path: "cache")
    }
    
    public func save(data: Data, with id: String) async throws {
        if !FileManager.default.fileExists(atPath: storageURL.path()) {
            try FileManager.default.createDirectory(at: storageURL, withIntermediateDirectories: true)
        }
        FileManager.default.createFile(atPath: storageURL.appending(path: id).path(), contents: data)
    }
    
    public func readData(with id: String) async -> Data? {
        return FileManager.default.contents(atPath: storageURL.appending(path: id).path())
    }
}
