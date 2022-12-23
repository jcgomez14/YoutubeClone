
import Foundation

protocol PlaylistViewProtocol {
    func getPlaylist(playlist: [PlaylistModel.Items])
}

class PlaylistPresenter {
    private  var delegate: PlaylistViewProtocol?
    private  var provider: PlaylistProviderProtocol
    init(delegate: PlaylistViewProtocol, provider: PlaylistProviderProtocol = PlaylistProvider()) {
        self.delegate = delegate
        self.provider = provider
        
        #if DEBUG
        self.provider = PlaylistProviderMock()
        #endif
    }
    
    @MainActor
    func getPlaylist() async {
        do {
            let playlist = try await provider.getPlaylist(channelId: Constans.channelId).items
            delegate?.getPlaylist(playlist: playlist)
        } catch  {
            print(error.localizedDescription)
        }
    }
}
