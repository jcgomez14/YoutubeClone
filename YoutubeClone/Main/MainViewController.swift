
import UIKit

class MainViewController: UIViewController {
    var rootPageViewController: RootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootViewController {
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }

}

extension MainViewController: RootPageProtocol {

    func currentaPage(_ index: Int) {
     
    }
    
    

    
}
