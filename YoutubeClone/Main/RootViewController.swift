
import UIKit

enum ScrollDirection {
    case goingLeft
    case goingRight
}

protocol RootPageProtocol: AnyObject{
    func currentaPage(_ index: Int)
    func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int)
}

class RootViewController: UIPageViewController {
    var subViewsController = [UIViewController]()
    var currentIndex: Int = 0
    var startOffset: CGFloat = 0.0
    var currentPage: Int = 0
    weak var delegateRoot: RootPageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        delegateRoot?.currentaPage(0)
        setupViewController()
        setViewControllerDelegate()
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
    
      func setViewControllerIndex(index: Int, direction: NavigationDirection, animated: Bool = true) {
        setViewControllers([subViewsController[index]], direction: direction, animated: animated)
    }
    
    private func setViewControllerDelegate() {
        guard let scrollView = view.subviews.filter({$0 is UIScrollView}).first as? UIScrollView else {
            return
        }
        scrollView.delegate = self
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

extension RootViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction = 0
        if startOffset < scrollView.contentOffset.x {
            direction = 1
        } else if startOffset > scrollView.contentOffset.x {
            direction = -1
        }
        
        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage / self.view.frame.width
        delegateRoot?.scrollDetails(direction: (direction == 1) ? .goingRight : .goingLeft, percent: percent, index: currentPage)
        
        print(percent)
        print(direction)
    }
}
