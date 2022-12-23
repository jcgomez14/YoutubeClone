
import UIKit
import Kingfisher

class PlaylistCell: UITableViewCell {
    
    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var videoCountOverlay: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    
    var didTapDotsButton: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        dotsImage.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
        dotsImage.tintColor = .whiteColor
        selectionStyle = .none
    }
    
    @IBAction func dotsAction(_ sender: Any) {
        if let tap = didTapDotsButton {
            tap()
        }
    }
    
    func configCell(model: PlaylistModel.Items) {
       
        videoTitle.text = model.snippet.title
        videoCount.text = "\(model.contentDetails.itemCount) videos"
        videoCountOverlay.text = "\(model.contentDetails.itemCount)"
        
        let imageUrl = (model.snippet.thumbnails.medium?.url)
        if let url = URL(string: imageUrl!) {
            videoImage.kf.setImage(with: url)
        }
        
    }
    
}
