import Foundation
import UIKit

private extension UIEdgeInsets {
    var vertical: CGFloat {
        top + bottom
    }
}

// MARK: - UIScrollView Extension

extension UIScrollView {
    /// Tells you if the tableView is currently scrolled to the bottom
    /// with a threshold of 50
    var isAtBottom: Bool {
        let offset = contentOffset
        let inset = contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = contentSize.height
        
        return h - y < 50
    }
    
    /// Scrolls to bottom of the scrollview if content size is higher than scroll view bounds size
    ///
    /// - Parameter animated: Animates the scroll
    func scrollToBottom(animated: Bool, adjust safeAreaTop: CGFloat = 0) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - (bounds.size.height - contentInset.bottom) - safeAreaTop)
//        dlog(bottomOffset)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}

// MARK: - UITableView Extension

extension UITableView {
    /// lastIndexPath
    ///
    /// - Returns: IndexPath. Nil if no rows are in the tableView
    func lastIndexPath() -> IndexPath? {
        let nbRows = numberOfRows(inSection: 0)
        if nbRows == 0 {
            return nil
        }
        return IndexPath(row: nbRows - 1, section: 0)
    }
    
    /// Standard insertRows with a boolean that says if it needs to scroll to bottom
    ///
    /// - Parameters:
    ///   - indexPaths: [IndexPath]
    ///   - animation: UITableViewRowAnimation
    ///   - scrollToBottom: Bool
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation, scrollToBottom: Bool) {
        let shouldScroll = scrollToBottom || isAtBottom
        
        self.insertRows(at: indexPaths, with: animation)
        
        if shouldScroll {
            self.scrollToBottom(animated: true)
        }
    }
    
    /// Standard reloadRows with a boolean that says if it needs to scroll to bottom
    ///
    /// - Parameters:
    ///   - indexPaths: [IndexPath]
    ///   - animation: UITableViewRowAnimation
    ///   - scrollToBottom: Bool
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation, scrollToBottom: Bool) {
        let shouldScroll = scrollToBottom || isAtBottom
        
        self.reloadRows(at: indexPaths, with: animation)
        
        if shouldScroll {
            self.scrollToBottom(animated: true)
        }
    }
    
    /// Standard deleteRows with a boolean that says if it needs to scroll to bottom
    ///
    /// - Parameters:
    ///   - indexPaths: [IndexPath]
    ///   - animation: UITableViewRowAnimation
    ///   - scrollToBottom: Bool
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation, scrollToBottom: Bool) {
        let shouldScroll = scrollToBottom || isAtBottom
        
        self.deleteRows(at: indexPaths, with: animation)
        
        if shouldScroll {
            self.scrollToBottom(animated: true)
        }
    }
    
    /// Scrolls to specified indexPath
    ///
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - position: UITableViewScrollPosition. Default is bottom
    ///   - animated: Bool. Default is true
    func scrollTo(indexPath: IndexPath, at position: UITableView.ScrollPosition = .bottom, animated: Bool = true) {
        guard numberOfSections > indexPath.section else {
            dlog("cannot scroll to indexpath \(indexPath)")
            return
        }
        let numberOfItems = numberOfRows(inSection: indexPath.section)
        guard numberOfItems > 0 else {
            dlog("cannot scroll to indexpath \(indexPath)")
            return
        }
        
        let itemIndex = max(min(indexPath.row, numberOfItems), 0)
        let actualIndexPath = IndexPath(row: itemIndex, section: indexPath.section)
        
        scrollToRow(at: actualIndexPath, at: position, animated: animated)
    }
}
