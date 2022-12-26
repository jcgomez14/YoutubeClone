import Foundation

struct PlaylistItemsModel: Decodable{
    let kind: String
    let etag: String
    let items: [Items]
    let pageInfo : PageInfo
    
    struct Items: Decodable{
        let kind : String
        let etag : String
        let id : String
        let snippet : VideoModel.Items.Snippet
        let contentdetails: ContentDetails?
        
        struct ContentDetails: Decodable {
            let videoId: String?
            let videoPublishedAt: String?
        }
    }
    
    struct PageInfo: Decodable{
        let totalResults: Int
        let resultsPerPage: Int
    }
}
