import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        if appState.hasCompletedOnboarding {
            HomeView()
        } else {
            OnboardingContainerView()
        }
    }
}
