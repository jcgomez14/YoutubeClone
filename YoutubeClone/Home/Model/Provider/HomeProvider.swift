
import Foundation

protocol HomeProviderProtocol{
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel
    func getPlaylist(channelId: String) async throws -> PlaylistModel
    func getChannel(channelId: String) async throws -> ChannelModel
    func getPlaylistItems(playlistId: String) async throws -> PlaylistItemsModel
}

class HomeProvider: HomeProviderProtocol {
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel {
        var queryParams: [String:String] = ["part":"snippet", "type":"video"]
        if !channelId.isEmpty {
            queryParams["channelId"] = channelId
        }
        
        if !searchString.isEmpty {
            queryParams["q"] = searchString
        }
        let requestModel = RequestModel(endpoint: .search, queryItems: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            return model
        } catch  {
            print(error)
            throw error
        }
    }
    
    func getChannel(channelId: String) async throws -> ChannelModel {
        let queryParams: [String:String] = ["part":"snippet,statistics,brandingSettings",
                                            "id": channelId]
        
        let requestModel = RequestModel(endpoint: .channels, queryItems: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, ChannelModel.self)
            return model
        } catch  {
            print(error)
            throw error
        }
    }
    
    
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
    
    func getPlaylistItems(playlistId: String) async throws -> PlaylistItemsModel {
        let queryParams: [String:String] = ["part":"snippet,id,contentDetails",
                                            "playlistId": playlistId]
     
        let requestModel = RequestModel(endpoint: .playlistItem, queryItems: queryParams, baseUrl: .youtube)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, PlaylistItemsModel.self)
            return model
        } catch  {
            print(error)
            throw error
        }
    }
    
}

