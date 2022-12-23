
import Foundation
import UIKit

extension UITableView {
    public func register<T: UITableViewCell> (cell: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forCellReuseIdentifier: "\(T.self)")
    }
    
    
    public func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }
    
    public func registerFromClass<T: UITableViewHeaderFooterView>(headerFooterVieew: T.Type) {
        register(UINib(nibName: "\(T.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }
    
    public func deuqueueReusableCell<T: UITableViewCell> (for: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
            fatalError("Failed to dequeue cell")
        }
        return cell
    }
    
    public func deuqueueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(for type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: "\(T.self)") as? T else {
            fatalError("Failed to dequeue header")
        }
        return view
    }
}
