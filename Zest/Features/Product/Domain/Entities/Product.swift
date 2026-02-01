import Foundation

struct Product: Identifiable, Codable, Sendable {
    let id: UUID
    let name: String
    let price: Double
    let description: String
    let imageUrl: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
