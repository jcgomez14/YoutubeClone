
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
        viewTablePlaylist.register(cell: PlaylistCell.self)
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
            let cell = tableView.deuqueueReusableCell(for: PlaylistCell.self, for: indexPath)
            cell.configCell(model: playlist)
            
            cell.didTapDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            
            return cell
         
        }
}
