
import UIKit

class PlaylistViewController: UIViewController {

    @IBOutlet weak var viewTablePlaylist: UITableView!
    
    lazy var presenter = PlaylistPresenter(delegate: self)
    var playList: [PlaylistModel.Items] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await presenter.getPlaylist()
            configTableView()
        }

    }
    
    func configTableView() {
        let nibVideos = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        viewTablePlaylist.register(nibVideos, forCellReuseIdentifier: "\(PlaylistCell.self)")
        viewTablePlaylist.separatorColor = .clear
        viewTablePlaylist.delegate = self
        viewTablePlaylist.dataSource = self
    }

}


extension PlaylistViewController: PlaylistViewProtocol {
    func getPlaylist(playlist: [PlaylistModel.Items]) {
        self.playList = playlist
        viewTablePlaylist.reloadData()
    }
    
    func configButtonSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return playList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let playlist = playList[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
                return UITableViewCell()
            }
            cell.configCell(model: playlist)
            
            cell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            
            return cell
         
        }
}
