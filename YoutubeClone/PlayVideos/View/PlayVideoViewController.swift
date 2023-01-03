import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tableViewVideos: UITableView!
    lazy var presenter = PlayVideoPresenter(delegate: self)
    var videoId: String = ""
    var goingToBeCollapsed : ((Bool)->Void)?
    var isClosedVideo : (()->Void)?
    lazy var collapseVideoButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage.chevronDown, for: .normal)
        button.tintColor = .whiteColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(collapsedVideoButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleVideoLabel: UILabel!
    @IBOutlet weak var channelVideoLabel: UILabel!
    @IBOutlet weak var tipViewButton: UIButton!
    @IBOutlet weak var tipVIew: UIView!
    @IBOutlet weak var safeAreaInset: UIView!
    @IBOutlet weak var playerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    var isPlayingVideo: Bool = false {
        didSet {
            playButton.setImage(isPlayingVideo ? .pause : .playFill , for: .normal)
        }
    }
    
    var topSafeArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .black
            case .light, .unspecified:
                return .white
            @unknown default:
                return .white
            }
        })
        return view
    }()
    var progressBar: UIProgressView = {
        let pogressBarBottom = UIProgressView()
        pogressBarBottom.translatesAutoresizingMaskIntoConstraints = false
        pogressBarBottom.trackTintColor = .clear
        pogressBarBottom.progressTintColor = .red
        pogressBarBottom.progress = 0.0
        pogressBarBottom.isHidden = true
        return pogressBarBottom
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configPlayerView()
        loadDataFromApi()
        configCloseButton()
        generalConfig()
        configTopInsetSafeAreaConstraint()
        configPogressBarConstraint()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
          NotificationCenter.default.removeObserver(self, name: .viewPosition, object: nil)
      }
    
    private func generalConfig() {
        NotificationCenter.default.addObserver(self, selector: #selector(floatingPannelChanged(notification:)), name: .viewPosition, object: nil)
    }
    
    private func loadDataFromApi() {
        Task{ [weak self] in
        await self?.presenter.getVideos(videoId)
        }
    }
    
    func configPogressBarConstraint(){
        view.addSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(equalTo: tipVIew.widthAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 2.0),
            progressBar.centerXAnchor.constraint(equalTo: tipVIew.centerXAnchor),
            progressBar.bottomAnchor.constraint(equalTo: tipVIew.bottomAnchor, constant: 12),
        ])
    }
    
    func configTopInsetSafeAreaConstraint() {
        view.addSubview(topSafeArea)
        NSLayoutConstraint.activate([
            topSafeArea.widthAnchor.constraint(equalTo: view.widthAnchor),
            topSafeArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topSafeArea.topAnchor.constraint(equalTo: view.topAnchor),
            topSafeArea.bottomAnchor.constraint(equalTo: playerView.topAnchor),
        ])
    }
    
    func configPlayerView() {
        let playerVars : [AnyHashable : Any] = ["playsinline":1, "controls":1, "autohide": 1, "showinfo": 0, "modestbranding":0]
        playerView.load(withVideoId: videoId, playerVars: playerVars)
        playerView.delegate = self
    }

    private func configTableView() {
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
        
        tableViewVideos.register(cell: VideoHeaderCell.self)
        tableViewVideos.register(cell: VideoFullWidthCell.self)
        
        tableViewVideos.rowHeight = UITableView.automaticDimension
        tableViewVideos.estimatedRowHeight = 60
    }
    
    
    @objc func floatingPannelChanged(notification: Notification) {
        guard let value = notification.object as? [String:String] else { return }
        if value["position"] == "top" {
            tipVIew.isHidden = true
            safeAreaInset.isHidden = true
            progressBar.isHidden = true
            collapseVideoButton.isHidden = false
            playerViewHeightConstraint.constant = 225.0
            playerViewTrailingConstraint.constant = 0.0

            view.layoutIfNeeded()
        } else {
            tipVIew.isHidden = false
            safeAreaInset.isHidden = false
            collapseVideoButton.isHidden = true
            progressBar.isHidden = false
            playerViewHeightConstraint.constant = playerViewHeightConstraint.constant * 0.3
            playerViewTrailingConstraint.constant = UIScreen.main.bounds.width * 0.7
            view.layoutIfNeeded()
        }
    }
    
    //MARK: Buttons Action Floating
    @IBAction func playButton(_ sender: Any) {
        isPlayingVideo ? playerView.pauseVideo() : playerView.playVideo()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        if let isClosedVideo = isClosedVideo {
            isClosedVideo()
        }
        dismiss(animated: true)
    }
    
    
    @IBAction func tipViewButton(_ sender: Any) {
        if let goingToBeCollapsed = goingToBeCollapsed {
            goingToBeCollapsed(false)
        }
    }
    
}

extension PlayVideoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.relatedVideoList.count
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.relatedVideoList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.relatedVideoList[indexPath.section]
        if indexPath.section == 0 {
            guard let video = item[indexPath.row] as? VideoModel.Items else { return UITableViewCell()}
            
            let videoHeaderCell = tableView.deuqueueReusableCell(for: VideoHeaderCell.self, for: indexPath)
            videoHeaderCell.configCell(videoModel: video, channelModel: presenter.channelModel)
            videoHeaderCell.selectionStyle = .none
            return videoHeaderCell
            
        } else {
            guard let video = item[indexPath.row] as? VideoModel.Items else { return UITableViewCell()}
            let videoFullWidthCell = tableView.deuqueueReusableCell(for: VideoFullWidthCell.self, for: indexPath)
            videoFullWidthCell.configCell(model: video)
            return videoFullWidthCell
        }
    }
    
    private func configCloseButton(){
         playerView.addSubview(collapseVideoButton)
         NSLayoutConstraint.activate([
             collapseVideoButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 5),
             collapseVideoButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 5),
             collapseVideoButton.widthAnchor.constraint(equalToConstant: 25),
             collapseVideoButton.heightAnchor.constraint(equalToConstant: 25),
         ])
     }
    @objc private func collapsedVideoButtonPressed(_ sender : UIButton){
           guard let goingToBeCollapsed = self.goingToBeCollapsed else {return}
           goingToBeCollapsed(true)
       }
}


extension PlayVideoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
            
        case .unstarted:
            print("unstarted")
        case .ended:
            isPlayingVideo = false
        case .playing:
            isPlayingVideo = true
        case .paused:
            isPlayingVideo = false
        case .buffering:
            print("buffering")
        case .cued:
            isPlayingVideo = false
        case .unknown:
            print("unknown")
        @unknown default:
            print("error")
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        playerView.duration { duration, error in
            self.progressBar.progress = (playTime/Float(duration))
        }
    }
}

extension PlayVideoViewController: PlayVideoViewProtocol {
    func getRelatedVideosFinished() {
        if let video = presenter.relatedVideoList[0] as? VideoModel.Items, let title = video.snippet?.title {
            titleVideoLabel.text = title
        }
        channelVideoLabel.text = presenter.channelModel?.snippet.title
        tableViewVideos.reloadData()
    }
}
