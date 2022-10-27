import Foundation
import NablaCore
import NablaMessagingUI

@objc public class Theme: NSObject {
    @objc public static func configureNablaTheme() {
        NablaTheme.primaryColor = UIColor(red: 0.65, green: 0.89, blue: 0.8, alpha: 1)
    }
}
