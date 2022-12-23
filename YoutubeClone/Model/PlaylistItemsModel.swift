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
    }
    
    struct PageInfo: Decodable{
        let totalResults: Int
        let resultsPerPage: Int
    }
}
