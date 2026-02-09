import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppSpacing.medium)
            .background(AppColors.surface)
            .cornerRadius(12)
            .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
    }
}
