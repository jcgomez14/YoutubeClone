
import Foundation

class PlaylistProviderMock: PlaylistProviderProtocol {
    func getPlaylist(channelId: String) async throws -> PlaylistModel {
        guard let model = Utils.parseJson(jsonName: "Playlists", model: PlaylistModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
    

}
