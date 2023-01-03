
import UIKit
import Kingfisher

class VideoFullWidthCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var profileImageVideo: UIImageView!
    @IBOutlet weak var staticsVideoLabel: UILabel!    
    @IBOutlet weak var videoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(model : VideoModel.Items) {
        videoTitle.text = model.snippet?.title
        videoTitle.textColor = .whiteColor
        
        let channelTitle = model.snippet?.channelTitle
        let randInt = Int.random(in: 200..<999)
        staticsVideoLabel.text = "\(channelTitle) · \(randInt) views · 3 days ago"
        staticsVideoLabel.textColor = .grayColor
        
        guard let imageUrl = model.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl) else{
            videoImage.image = .videoPlaceholder
            return
        }
        videoImage.kf.setImage(with: url, placeholder: UIImage.videoPlaceholder)
    }
    
}
