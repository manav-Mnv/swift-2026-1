import SwiftUI

struct LessonListView: View {
    let level: Level
    
    @EnvironmentObject var progressViewModel: ProgressViewModel
    @StateObject private var lessonViewModel = LessonViewModel()
    
    @State private var navigateToLessonDetail = false
    @State private var selectedLesson: Lesson?
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.medium) {
                // Level header with progress
                VStack(spacing: AppSpacing.medium) {
                    Text(level.title)
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(level.description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    ProgressBar(
                        completed: progressViewModel.completedLessonsInLevel(level),
                        total: level.lessons.count
                    )
                    .padding(.horizontal, AppSpacing.medium)
                }
                .padding(.top, AppSpacing.medium)
                .padding(.horizontal, AppSpacing.medium)
                
                Divider()
                    .padding(.vertical, AppSpacing.small)
                
                // Lesson rows
                if level.lessons.isEmpty {
                    EmptyStateView(
                        icon: "doc.text.fill",
                        title: "No Lessons Available",
                        message: "There are no lessons in this level yet."
                    )
                    .padding(.top, AppSpacing.xlarge)
                } else {
                    VStack(spacing: AppSpacing.medium) {
                        ForEach(Array(level.lessons.enumerated()), id: \.element.id) { index, lesson in
                            let state = lessonViewModel.getLessonState(lesson, in: level.lessons, progress: progressViewModel)
                            let itemState = convertLessonStateToItemState(state)
                            
                            LessonRow(
                                lessonNumber: index + 1,
                                lesson: lesson,
                                state: itemState,
                                isDisabled: state == .locked
                            ) {
                                if state != .locked {
                                    selectedLesson = lesson
                                    navigateToLessonDetail = true
                                }
                            }
                        }
                    }
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle("Lessons")
        .navigationDestination(isPresented: $navigateToLessonDetail) {
            if let lesson = selectedLesson {
                LessonDetailView(lesson: lesson, level: level)
                    .environmentObject(progressViewModel)
            }
        }
    }
    
    private func convertLessonStateToItemState(_ lessonState: LessonState) -> ItemState {
        switch lessonState {
        case .locked:
            return .locked
        case .available:
            return .unlocked
        case .completed:
            return .completed
        }
    }
}
