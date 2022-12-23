
import Foundation

protocol AboutViewProtocol {
    func getAbout(about: ChannelModel.Items)
}

class AboutPresenter {
    
    private var aboutObject: [String] = []
    private  var delegate: AboutViewProtocol?
    private  var provider: AboutProviderProtocol
    
    init(delegate: AboutViewProtocol?, provider: AboutProviderProtocol = AboutProvider()) {
        self.delegate = delegate
        self.provider = provider

            #if DEBUG
            self.provider = AboutProviderMock()
            #endif
    }
    
    @MainActor
    func getAbout() async {
        aboutObject.removeAll()
        
        do {
            let about = try await provider.getAbout(channelId: Constans.channelId)
            delegate?.getAbout(about: about)
        } catch  {
            print(error.localizedDescription)
        }
    }
}
