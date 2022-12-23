//
//  ChannelCell.swift
//  YoutubeClone
//
//  Created by Desarrollo DevIOS on 21/12/2022.
//

import UIKit
import Kingfisher

class ChannelCell: UITableViewCell {


    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var subscribedLabel: UILabel!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var subscriberNumbersLabel: UILabel!
    @IBOutlet weak var channelInfoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()

    }
    
    private func configView() {
        bellImage.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
        bellImage.tintColor = UIColor(named: "grayColor")
        profileImage.layer.cornerRadius = 51/2
    }
    
    func configCell(model: ChannelModel.Items) {
        selectionStyle = .none
        channelInfoLabel.text = model.snippet.description
        subscriberNumbersLabel.text = "\(model.statistics.subscriberCount ?? "0") subscribers - \(model.statistics.videoCount ?? "0") videos"
        channelTitle.text = model.snippet.title
        
        let imageUrl = model.snippet.thumbnails.medium.url
        guard let url = URL(string: imageUrl) else {
            return
        }
        profileImage.kf.setImage(with: url)
        
        if let bannerImageUrl = model.brandingSettings?.image.bannerExternalUrl, let url = URL(string: bannerImageUrl) {
            bannerImage.kf.setImage(with: url)
        }
    }
}
