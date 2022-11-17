import Foundation
import NablaCore
import NablaMessagingUI

@objc public class Theme: NSObject {
    @objc public static func configureNablaTheme() {
      let primaryColor = UIColor(red: 0.65, green: 0.89, blue: 0.8, alpha: 1)
      
      NablaTheme.Colors.Text.accent = primaryColor
      NablaTheme.Colors.Fill.accent = primaryColor
      NablaTheme.Colors.Stroke.accent = primaryColor
      NablaTheme.Colors.ButtonBackground.accent = primaryColor
    }
}
