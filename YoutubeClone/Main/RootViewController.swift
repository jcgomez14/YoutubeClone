
import UIKit

protocol RootPageProtocol: AnyObject{
    func currentaPage(_ index: Int)
}

class RootViewController: UIPageViewController {
    var subViewsController = [UIViewController]()
    var currentIndex: Int = 0
    weak var delegateRoot: RootPageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setupViewController()
       
    }
}

extension RootViewController {
    private func setupViewController(){
        subViewsController = [
        HomeViewController(),
        VideosViewController(),
        PlaylistViewController(),
        ChannelViewController(),
        AboutViewController(),
        ]
        
        _ = subViewsController.enumerated().map({$0.element.view.tag = $0.offset})
        setViewControllerIndex(index: 0, direction: .forward)
    }
    
    private func setViewControllerIndex(index: Int, direction: NavigationDirection, animated: Bool = true) {
        setViewControllers([subViewsController[index]], direction: direction, animated: animated)
    }
}


extension RootViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewsController.count
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewsController.firstIndex(of: viewController) ?? 0
        if index <= 0 {
            return nil
        }
        return subViewsController[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewsController.firstIndex(of: viewController) ?? 0
        if index >= (subViewsController.count - 1) {
            return nil
        }
        return subViewsController[index+1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let index = pageViewController.viewControllers?.first?.view.tag {
            currentIndex = index
            delegateRoot?.currentaPage(index)
        }
    }
}
