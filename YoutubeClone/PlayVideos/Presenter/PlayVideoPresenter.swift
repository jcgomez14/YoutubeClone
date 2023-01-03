

import Foundation

protocol PlayVideoViewProtocol : AnyObject{
    func getRelatedVideosFinished()
}

@MainActor class PlayVideoPresenter{
    private var provider : PlayVideoProviderProtocol
    private weak var delegate : PlayVideoViewProtocol?
    
    var relatedVideoList : [[Any]] = []
    var channelModel : ChannelModel.Items?
    
    init(delegate : PlayVideoViewProtocol, provider : PlayVideoProviderProtocol = PlayVideoProvider()){
        self.delegate = delegate
        self.provider = provider
        #if DEBUG
        if MockManager.shared.runAppWithMock{
            self.provider = PlayVideoProviderMock()
        }
        #endif
    }
    
    func getVideos(_ videoId: String) async {
        do {
            let response = try await provider.getVideo(videoId)
            relatedVideoList.append(response.items)
            await getChannelAndRelatedFinished(videoId, response.items.first?.snippet?.channelId ?? "")
            
            
            delegate?.getRelatedVideosFinished()
        } catch  {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func getChannelAndRelatedFinished(_ videoId: String, _ channelId: String) async {
        async let relatedVideos = try await provider.getRelatedVideo(videoId)
        async let channel = try await provider.getChannel(channelId)
        
        do {
            let (responseRelatedVideos, responseChannel) = await (try relatedVideos, try channel)
            let filterRelatedVideos = responseRelatedVideos.items.map({$0.snippet != nil})
            relatedVideoList.append(filterRelatedVideos)
            channelModel = responseChannel.items.first
        } catch  {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}
