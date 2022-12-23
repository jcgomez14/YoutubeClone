
import Foundation

struct RequestModel {
    let endpoint: Endpoints
    var queryItems: [String:String]?
    let httpMethod: HttpMethod = .GET
    var baseUrl: URLBase = .youtube
    
    func getUrl() -> String {
        return baseUrl.rawValue + endpoint.rawValue
    }
    
    enum HttpMethod: String {
        case GET
        case POST
    }
    
    enum Endpoints: String {
        case empty = ""
        case search = "/search"
        case channels = "/channels"
        case playlist = "/playlists"
        case playlistItem = "/playlistItems"
    }
    
    enum URLBase: String {
        case youtube = "https://www.googleapis.com/youtube/v3"
        case google = "https://othereweb.com/v2"
    }
}
