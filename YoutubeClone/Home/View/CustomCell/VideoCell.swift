//
//  VideoCell.swift
//  YoutubeClone
//
//  Created by Desarrollo DevIOS on 21/12/2022.
//

import UIKit
import Kingfisher

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var dotsImage: UIImageView!
    
    var didTapDotsButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        selectionStyle = .none
        dotsImage.image = .dotsImage
        dotsImage.tintColor = .whiteColor
    }
    
    @IBAction func dotsButton(_ sender: Any) {
        if let tap = didTapDotsButton {
            tap()
        }
        
    }
    
    func configCell(model: Any) {

        
        if let video = model as? VideoModel.Items {
            if let imageUrl = video.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl) {
                videoImage.kf.setImage(with: url)
            }
            videoName.text = video.snippet?.title ?? ""
            channelName.text = video.snippet?.channelTitle ?? ""
            viewsCountLabel.text = "\(video.statistics?.viewCount) views"
  
            
            
        } else if let playlistItems = model as? PlaylistItemsModel.Items {
            if let imageUrl = playlistItems.snippet.thumbnails.medium?.url, let url = URL(string: imageUrl) {
                videoImage.kf.setImage(with: url)
                
                videoName.text = playlistItems.snippet.title
                channelName.text = playlistItems.snippet.channelTitle
                viewsCountLabel.text = "300 - 3 months ago"
   
            }
        }
    }
}
