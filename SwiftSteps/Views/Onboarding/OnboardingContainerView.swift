import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentPage = 0
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        TabView(selection: $currentPage) {
            WelcomeView()
                .tag(0)
            
            SwiftVsSwiftUIView()
                .tag(1)
            
            PathSelectionView()
                .tag(2)
        }
        #if os(iOS)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        #endif
    }
}
