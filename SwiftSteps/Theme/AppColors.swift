import SwiftUI

struct AppColors {
    // Primary colors
    static let primary = Color("PrimaryColor", bundle: nil)
    static let accent = Color("AccentColor", bundle: nil)
    
    // Background colors
    static let background = Color("BackgroundColor", bundle: nil)
    static let surface = Color("SurfaceColor", bundle: nil)
    static let surfaceSecondary = Color("SurfaceSecondaryColor", bundle: nil)
    
    // Text colors
    static let textPrimary = Color("TextPrimaryColor", bundle: nil)
    static let textSecondary = Color("TextSecondaryColor", bundle: nil)
    
    // Code editor colors
    static let codeBackground = Color("CodeBackgroundColor", bundle: nil)
    
    // Status colors
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    static let disabled = Color.gray
    
    // Shadow
    static let shadow = Color.black.opacity(0.1)
}
