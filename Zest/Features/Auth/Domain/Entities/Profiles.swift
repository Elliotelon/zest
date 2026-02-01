import Foundation

struct Profiles: Codable, Sendable {
    let id: UUID
    let email: String?
    let name: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case createdAt = "created_at"
    }
}
