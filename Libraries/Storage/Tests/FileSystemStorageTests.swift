import Testing
@testable import Storage
import Foundation

struct FileSystemStorageTests {
    let storage = FileSystemStorage()
    
    @Test func saveAndRead() async throws {
        try await storage.save(data: "testInfo".data(using: .utf8)!, with: "test")
        let result = String(data: await storage.readData(with: "test")!, encoding: .utf8)
        #expect(result == "testInfo")
    }
}
