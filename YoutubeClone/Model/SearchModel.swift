import Foundation

struct SearchModel: Codable {
    let kind, etag: String
    let items: [Item]
    
    struct Item: Codable {
        let kind, etag: String
        let id: ID
        let snippet: Snippet
        
        struct ID: Codable {
            let kind, videoID: String

            enum CodingKeys: String, CodingKey {
                case kind
                case videoID = "videoId"
            }
        }
        
        struct Snippet: Codable {
            let publishedAt: Date
            let channelID, title, snippetDescription: String
            let thumbnails: Thumbnails
            let channelTitle, liveBroadcastContent: String
            let publishTime: Date

            enum CodingKeys: String, CodingKey {
                case publishedAt
                case channelID = "channelId"
                case title
                case snippetDescription = "description"
                case thumbnails, channelTitle, liveBroadcastContent, publishTime
            }
            
            struct Thumbnails: Codable {
                let thumbnailsDefault, medium, high, standard: Default
                let maxres: Default

                enum CodingKeys: String, CodingKey {
                    case thumbnailsDefault = "default"
                    case medium, high, standard, maxres
                }
                
                struct Default: Codable {
                    let url: String
                    let width, height: Int
                }
            }
        }
    }
}
