
import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var descriptionAboutLabel: UILabel!
    @IBOutlet weak var titleAboutLabel: UILabel!
    //private var aboutDescription = ChannelModel.Items()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    
    func configView() {
        titleAboutLabel.text = "Description"
       // descriptionAboutLabel.text = aboutDescription.snippet.description
    }

}
