
import Foundation

class AboutProviderMock: AboutProviderProtocol {
    func getAbout(channelId: String) async throws -> ChannelModel.Items {
        guard let model = Utils.parseJson(jsonName: "Channel", model: ChannelModel.Items.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    
}
