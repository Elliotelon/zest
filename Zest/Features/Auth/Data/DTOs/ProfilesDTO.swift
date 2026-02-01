import Foundation

struct ProfilesDTO: Codable, Sendable {
    let id: UUID
    let email: String?
    let name: String?
}
