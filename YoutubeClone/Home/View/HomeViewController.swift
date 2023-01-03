
import UIKit
import FloatingPanel

class HomeViewController: BaseViewController {
   
    
    @IBOutlet weak var tableViewHome: UITableView!
    lazy var presenter = HomePresenter(delegate: self)
    private var objectList: [[Any]] = []
    private var sectionTitleList: [String] = []
    var floatinPanelIsPresented: Bool = false
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configPanelFloating()
        
        Task{
            await presenter.getHomeObjects()
        }
    }

    func configTableView(){
        tableViewHome.register(cell: ChannelCell.self)
        tableViewHome.register(cell: VideoCell.self)
        tableViewHome.register(cell: PlaylistCell.self)
        tableViewHome.registerFromClass(headerFooterView: SectionTitleView.self)
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorColor = .clear
        tableViewHome.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: -80, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -5 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > -5 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = objectList[indexPath.section]
        
        if let channel = item as? [ChannelModel.Items] {
            let channelCell = tableView.deuqueueReusableCell(for: ChannelCell.self, for: indexPath)
            channelCell.configCell(model: channel[indexPath.row])
            return channelCell

        } else if let playlistItems = item as? [PlaylistItemsModel.Items] {
            let playlistItemsCell = tableView.deuqueueReusableCell(for: VideoCell.self, for: indexPath)
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            
            playlistItemsCell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            
            return playlistItemsCell
            
        } else if let videos = item as? [VideoModel.Items] {
            let videosCell = tableView.deuqueueReusableCell(for: VideoCell.self, for: indexPath)
            videosCell.configCell(model: videos[indexPath.row])
            
            videosCell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }

            return videosCell
            
        } else if let playlist = item as? [PlaylistModel.Items] {
            let playlistCell = tableView.deuqueueReusableCell(for: PlaylistCell.self, for: indexPath)
            playlistCell.configCell(model: playlist[indexPath.row])
            
            playlistCell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            
            return playlistCell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
            return 95.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView else{
            return nil
        }
        sectionView.title.text = sectionTitleList[section]
        sectionView.configView()
        return sectionView
    }

    func configButtonSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = objectList[indexPath.section]
        var videoId = ""
        if let playlist = item as? [PlaylistItemsModel.Items] {
            videoId = playlist[indexPath.row].contentdetails?.videoId ?? ""
        } else if let videos = item as? [VideoModel.Items] {
            videoId = videos[indexPath.row].id ?? ""
        }
        if floatinPanelIsPresented {
            fpc.willMove(toParent: nil)
            fpc.hide(animated: true) { [weak self] in
                self?.fpc.view.removeFromSuperview()
                self?.fpc.removeFromParent()
                self?.dismiss(animated: true, completion: {
                    self?.presentViewPanel(videoId)
                })
            }
        } else {
            presentViewPanel(videoId)
        }
    }
}

extension HomeViewController: HomeViewProtocol {
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
}

extension HomeViewController: FloatingPanelControllerDelegate {
    func configPanelFloating(){
        fpc = FloatingPanelController()
        fpc.delegate = self // Optional
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.layout = MyFloatingPanelLayout()
        fpc.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
    }
    
    func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
        self.floatinPanelIsPresented = false
    }
    
    func presentViewPanel(_ videoId: String) {
        let contentVC = PlayVideoViewController()
        contentVC.videoId = videoId
        contentVC.goingToBeCollapsed = {[weak self] goingToBeCollapsed in
            guard let self = self else { return }
            if goingToBeCollapsed {
                self.fpc.move(to: .tip, animated: true)
                NotificationCenter.default.post(name: .viewPosition, object: ["position":"bottom"])
                self.fpc?.surfaceView.contentPadding = .init(top: 0, left: 0, bottom: 0, right: 0)
            } else {
                self.fpc.move(to: .full, animated: true)
                NotificationCenter.default.post(name: .viewPosition, object: ["position":"top"])
                self.fpc?.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
            }
        }
        
        contentVC.isClosedVideo = {[weak self] in
            self?.floatinPanelIsPresented = false
        }
        
        fpc?.set(contentViewController: contentVC)
        // fpc?.track(scrollView: contentVC.tableViewVideos)
        if let fpc = fpc {
            floatinPanelIsPresented = true
            present(fpc, animated: true)
        }
    }
    
    func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
         if targetState.pointee != .full {
             NotificationCenter.default.post(name: .viewPosition, object: ["position":"bottom"])
             fpc?.surfaceView.contentPadding = .init(top: 0, left: 0, bottom: 0, right: 0)
         }else{
             NotificationCenter.default.post(name: .viewPosition, object: ["position":"top"])
             fpc?.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
         }
     }
    
}
    
extension NSNotification.Name {
    static let viewPosition = Notification.Name("viewPosition")
    static let expand = Notification.Name("expand")
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 60.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
