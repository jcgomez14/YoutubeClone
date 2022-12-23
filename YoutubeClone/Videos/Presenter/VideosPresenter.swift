
import Foundation
protocol VideosViewProtocol {
    func getVideos(videolist: [VideoModel.Items])
}



class VideosPresenter {
  private  var delegate: VideosViewProtocol?
  private  var provider: VideosProviderProtocol
    
    
    init(delegate: VideosViewProtocol, provider: VideosProviderProtocol = VideosProvider()) {
        self.delegate = delegate
        self.provider = provider
        
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = VideosProviderMock()
        }
        #endif
    }
    @MainActor
    func getVideos() async {
        do {
            let videos = try await provider.getVideos(channelId: Constans.channelId).items
            delegate?.getVideos(videolist: videos)
        } catch  {
            print(error.localizedDescription)
        }
       
     }
}
