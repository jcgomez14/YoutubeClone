
import UIKit

class VideosViewController: UIViewController {

    @IBOutlet weak var tableViewVideos: UITableView!
   
    lazy var presenter = VideosPresenter(delegate: self)
    var videosList: [VideoModel.Items] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await presenter.getVideos()
        }
        configTableView()
    }
    
    func configTableView() {
        let nibVideos = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        tableViewVideos.register(nibVideos, forCellReuseIdentifier: "\(VideoCell.self)")
        tableViewVideos.separatorColor = .clear
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
    }

    
}
extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videosList[indexPath.row]
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
            return UITableViewCell()
        }
        cell.configCell(model: video)
        cell.didTapDotsButton = { [weak self] in
            self?.configButtonSheet()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}

extension VideosViewController: VideosViewProtocol {
    func getVideos(videolist: [VideoModel.Items]) {
        self.videosList = videolist
        tableViewVideos.reloadData()
    }
    
    func configButtonSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
}
