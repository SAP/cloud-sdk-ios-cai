import SAPCommon
import SwiftUI

public struct URLNavigation {
    @Binding var isUrlSheetPresented: Bool
    let logger = Logger.shared(named: "CAIFoundation.URLNavigation")

    func performURLNavigation(value: String) {
        guard let url = URL(string: value) else {
            self.logger.error("Cannot navigate: Invalid URL " + value)
            return
        }
        
        if url.isHTTPURL {
            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: true]) { success in
                // if not success, then it is not a Universal Link, fallback to Safari
                if !success {
                    self.isUrlSheetPresented = true
                } else {
                    UIApplication.shared.open(url, options: [:]) { success in
                        self.logger.debug("navigation success? \(success)")
                    }
                }
            }
        } else {
            UIApplication.shared.open(url, options: [:]) { success in
                self.logger.debug("navigation success? \(success)")
            }
        }
    }
}
