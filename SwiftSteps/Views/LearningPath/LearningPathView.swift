import SwiftUI

/// Entry point to the learning path when user taps "Continue Learning" from HomeView
///
/// Purpose:
/// - Serves as navigation wrapper for Track Selection
/// - Loads levels for the selected learning path
/// - Manages navigation state for the learning journey
///
/// Architecture:
/// - Observes AppStateViewModel for selected learning path
/// - Observes LevelViewModel to load levels
/// - Observes ProgressViewModel for unlock conditions
/// - Presents TrackSelectionView as main content
///
/// Navigation Flow:
/// - HomeView → LearningPathView → TrackSelectionView → LevelSelectionView
struct LearningPathView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @EnvironmentObject private var levelViewModel: LevelViewModel
    @EnvironmentObject private var progressViewModel: ProgressViewModel
    
    var body: some View {
        TrackSelectionView()
            .navigationTitle("Learning Path")
            .navigationBarTitleDisplayMode(.large)
            .background(AppColors.background)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LearningPathView()
            .environmentObject(AppStateViewModel())
            .environmentObject(LevelViewModel())
            .environmentObject(ProgressViewModel())
    }
}
