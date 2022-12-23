
import Foundation

protocol PlaylistProviderProtocol {
    func getPlaylist(channelId: String) async throws -> PlaylistModel
}


class PlaylistProvider: PlaylistProviderProtocol {

    func getPlaylist(channelId: String) async throws -> PlaylistModel {
        let queryParams: [String:String] = ["part":"snippet,contentDetails",
                                            "channelId": channelId]
     
        let requestModel = RequestModel(endpoint: .playlist, queryItems: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, PlaylistModel.self)
            return model
        } catch  {
            print(error)
            throw error
        }
    }
    
}
