
import UIKit
import Kingfisher

class VideoHeaderCell: UITableViewCell {

    @IBOutlet weak var titleVideo: UILabel!
    @IBOutlet weak var staticsVideo: UILabel!
    
    @IBOutlet weak var buttonIconList: ButtonIconList!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleChannel: UILabel!
    @IBOutlet weak var staticsChannel: UILabel!
    @IBOutlet weak var bellIcon: UIImageView!
    @IBOutlet weak var subscriberLabel: UILabel!
    
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var seeAllComentButton: UIButton!
    @IBOutlet weak var comentProfileImage: UIImageView!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configHorizontalButtons(_ videoModel : VideoModel.Items){
        let options = [
            VideoButtonIcon(title: videoModel.statistics?.likeCount ?? "-", icon: .like),
            VideoButtonIcon(title: "Dislike", icon: .dislike),
            VideoButtonIcon(title: "Share", icon: .share),
            VideoButtonIcon(title: "Download", icon: .download),
            VideoButtonIcon(title: "Save", icon: .save),
            VideoButtonIcon(title: "Airplay", icon: .airplay),
        ]
        buttonIconList.buttonIconsList = options
        buttonIconList.delegate = self
        buttonIconList.buildView()
    }
   
    func configCell(videoModel : VideoModel.Items, channelModel : ChannelModel.Items?){
        configHorizontalButtons(videoModel)
        
        commentConfig()
        
        titleVideo.text = videoModel.snippet?.title
        titleVideo.textColor = .whiteColor
        
        let viewCount = videoModel.statistics?.viewCount ?? "0"
        let viewPlural = (Int(viewCount)!) > 0 ? "views" : "view"
        var tags = ""
        if let tagsArray = videoModel.snippet?.tags?.enumerated().filter({$0.offset<3}).map({"#"+$0.element}){
            tags = tagsArray.joined(separator: " ")
        }
        let published = "2 weeks ago" //videoModel.snippet?.publishedDateFriendly ?? ""
        let wholeString = "\(viewCount) \(viewPlural) · \(published) \(tags)"
        
        staticsVideo.text = wholeString
        staticsVideo.textColor = .grayColor
        staticsVideo.highlight(searchedText: tags, color: .systemBlue)
        
        channelDetails(videoModel, channelModel)
    }
    
    private func channelDetails(_ videoModel : VideoModel.Items, _ channelModel: ChannelModel.Items?){
        titleChannel.text = videoModel.snippet?.channelTitle
        titleChannel.textColor = .whiteColor
        
        subscriberLabel.text = "SUBSCRIBED"
        subscriberLabel.textColor = .grayColor
        
        bellIcon.image = .bellImage
        bellIcon.tintColor = .grayColor
        
        staticsChannel.text = "\(channelModel?.statistics.subscriberCount ?? "") subscribers"
        staticsChannel.textColor = .grayColor
        
        guard let imageUrl = channelModel?.snippet.thumbnails.medium.url, let url = URL(string: imageUrl) else{ return }
        profileImage.kf.setImage(with: url)
        profileImage.layer.cornerRadius = 20.0
    }
    
    private func commentConfig(){
        let randomInt = Int.random(in: 100..<1000)
        commentTitle.text = "Comments \(randomInt)"
        comentProfileImage.image = UIImage.personCircleFill
        comentProfileImage.tintColor = .whiteColor
        comment.text = "Excelente información. Gracias."
    }
}

extension VideoHeaderCell: ButtonIconListProtocol {
    func didSelectOption(tag: Int) {
        print("tag selected: \(tag)")
    }
}
