import SwiftUI

struct LessonView: View {
    @StateObject private var viewModel = LessonViewModel()
    @EnvironmentObject private var progressViewModel: ProgressViewModel
    
    let lesson: Lesson?
    
    var body: some View {
        Group {
            if let lesson = lesson, viewModel.hasLesson {
                lessonContentView
            } else {
                EmptyStateView(
                    userMessage: .lessonNotFound,
                    actionTitle: "Go Back",
                    action: {
                        // Navigation will handle going back
                    }
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let lesson = lesson {
                viewModel.loadLesson(lesson)
            }
        }
    }
    
    private var lessonContentView: some View {
        VStack(spacing: 0) {
            // Lesson content area
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    if let currentLesson = viewModel.currentLesson {
                        Text(currentLesson.title)
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primary)
                        
                        Text(currentLesson.content)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textPrimary)
                        
                        BirdGuideView(message: "Let's try this together!")
                    }
                }
                .padding(AppSpacing.large)
            }
            
            Divider()
            
            // Code editor area
            CodeEditorView(code: $viewModel.userCode)
                .frame(height: 200)
                .disabled(viewModel.isExecuting)
                .opacity(viewModel.isExecuting ? 0.6 : 1.0)
            
            Divider()
            
            // Output area
            OutputView(output: viewModel.output, isCorrect: viewModel.isCorrect)
                .frame(height: 100)
            
            // Action buttons
            HStack {
                Button("Hint") {
                    viewModel.showNextHint()
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isExecuting || !(viewModel.currentLesson?.hasHints ?? false))
                
                Spacer()
                
               if viewModel.isExecuting {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Running...")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                } else {
                    PrimaryButton(title: "Run Code") {
                        viewModel.validateCode()
                        
                        // If correct, mark lesson as complete
                        if viewModel.isCorrect, let lessonId = viewModel.currentLesson?.id {
                            progressViewModel.completeLesson(lessonId)
                        }
                    }
                }
            }
            .padding(AppSpacing.medium)
        }
    }
}
