
import Foundation

struct PlaylistModel: Decodable {
    let kind : String
    let etag : String
    let pageInfo : PageInfo
    let items : [Items]
    
    struct Items: Decodable {
        let kind: String
        let etag: String
        let id: String
        let snippet : Snippet
        let contentDetails : ContentDetails
        
        struct Snippet: Decodable {
            let publishedAt : String
            let channelId : String
            let title : String
            let description : String
            let thumbnails: Thumbnails
            let channelTitle: String
            
            struct Thumbnails: Decodable{
                let medium : Medium?
                
                struct Medium: Decodable{
                    let url : String
                    let width : Int
                    let height : Int
                }
            }
            
        }
        
        struct ContentDetails: Decodable {
            let itemCount : Int
        }
        
    }

    struct PageInfo : Decodable {
        let totalResults : Int
        let resultsPerPage : Int
    }
}


/*
 import Foundation

 struct PlaylistModel: Decodable {
     let kind: String
     let etag: String
     let nextPageToken: String
     let pageInfo: PageInfo
     let items: [Items]
    
     struct PageInfo: Decodable {
         let totalResults: Int
         let resultsPerPage: Int
     }
     struct Items: Decodable {
         let kind: String
         let etag: String
         let id: String
         let snippet: Snippet
         let contentDetails: ContentDetails
         
         struct Snippet: Decodable {
             let publishedAt: String
             let channelId: String
             let title: String
             let description: String
             let thumbnails: Thumbnails
             let channelTitle: String
             let localized: Localized
              
             struct Thumbnails: Decodable {
                 let medium: Medium
                 let high: High
                 let standard: Standard
                 let maxres: Maxres
             
                 struct Medium: Decodable {
                     let url: String
                     let width: Int
                     let height: Int
                 }
                 
                 struct High: Decodable {
                     let url: String
                     let width: Int
                     let height: Int
                 }
                 
                 struct Standard: Decodable {
                     let url: String
                     let width: Int
                     let height: Int
                 }
                 
                 struct Maxres: Decodable {
                     let url: String
                     let width: Int
                     let height: Int
                 }
             }
             
             struct Localized: Decodable {
                 let title: String
                 let description: String
             }
         }
         struct ContentDetails: Decodable {
             let itemCount: Int
         }
     }
 }


 */
