import SwiftUI

@main
struct SwiftStepsApp: App {
    
    @StateObject private var appState = AppStateViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.navigationPath) {
                ContentView()
                    .navigationDestination(for: NavigationRoute.self) { route in
                        switch route {
                        case .levelSelection:
                            LevelSelectionView(
                                viewModel: appState.levelViewModel
                            )
                        
                        case .lessonList(let level):
                            LessonListView(
                                level: level,
                                levelViewModel: appState.levelViewModel
                            )
                        
                        case .lessonDetail(let lesson):
                            LessonDetailView(lesson: lesson)
                        }
                    }
            }
            }
            .environmentObject(appState)
            .environmentObject(appState.levelViewModel)
            .environmentObject(appState.badgeViewModel)
        }
    }
}
