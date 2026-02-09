import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppStateViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()
    @StateObject private var levelViewModel = LevelViewModel()
    
    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                HomeView()
            } else {
                OnboardingContainerView()
            }
        }
        .environmentObject(appState)
        .environmentObject(progressViewModel)
        .environmentObject(levelViewModel)
    }
}
