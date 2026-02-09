import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    let level: Level?
    
    @EnvironmentObject var appState: AppStateViewModel
    @StateObject private var lessonViewModel = LessonViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCompletionMessage = false
    @State private var showLevelCompletion = false
    @State private var earnedBadge: Badge? = nil
    
    init(lesson: Lesson, level: Level? = nil) {
        self.lesson = lesson
        self.level = level
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large) {
                // Lesson title and description
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text(lesson.title)
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(lesson.description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if !lesson.content.isEmpty {
                        Divider()
                        
                        Text(lesson.content)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Code editor section
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text("Your Code")
                        .font(AppFonts.subtitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    CodeEditor(code: $lessonViewModel.userCode)
                        .frame(minHeight: 200)
                }
                
                // Output section
                if !lessonViewModel.output.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Output")
                            .font(AppFonts.subtitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(lessonViewModel.output)
                            .font(AppFonts.body)
                            .foregroundColor(lessonViewModel.isCorrect ? AppColors.success : AppColors.textPrimary)
                            .padding(AppSpacing.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                lessonViewModel.isCorrect
                                    ? AppColors.success.opacity(0.1)
                                    : AppColors.surface
                            )
                            .cornerRadius(8)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // Run code validation
                PrimaryButton(title: "Run Code") {
                    lessonViewModel.validateCode()
                    
                    if lessonViewModel.isCorrect {
                        // Mark lesson as completed
                        appState.levelViewModel.completeLesson(lesson.id)
                        
                        // Check if level is completed (if level context is available)
                        if let level = level {
                            let isLevelCompleted = appState.levelViewModel.isLevelCompleted(level)
                            
                            if isLevelCompleted {
                                // Check for earned badge
                                // Note: Badge logic would check specific unlock conditions
                                // For now, set to nil (no badge system fully implemented)
                                earnedBadge = nil
                                
                                // Show level completion view
                                showLevelCompletion = true
                            } else {
                                // Just show completion message for individual lesson
                                showCompletionMessage = true
                                
                                // Navigate back after a delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                            }
                        } else {
                            // No level context, just show completion and dismiss
                            showCompletionMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismiss()
                            }
                        }
                    }
                }
                .disabled(lessonViewModel.userCode.isEmpty)
                
                // Hints section (if available)
                if !lesson.hints.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Need Help?")
                            .font(AppFonts.subtitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        ForEach(Array(lesson.hints.enumerated()), id: \.offset) { index, hint in
                            Button {
                                lessonViewModel.showHint(index: index)
                            } label: {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(AppColors.warning)
                                    Text("Show Hint \(index + 1)")
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.textPrimary)
                                    Spacer()
                                }
                                .padding(AppSpacing.medium)
                                .background(AppColors.surface)
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle("Lesson")
        .onAppear {
            lessonViewModel.loadLesson(lesson)
        }
        .sheet(isPresented: $showLevelCompletion) {
            LevelCompletionView(level: level, earnedBadge: earnedBadge)
                .onDisappear {
                    // Dismiss back to lesson list when level completion is dismissed
                    dismiss()
                }
        }
        .alert("Lesson Completed!", isPresented: $showCompletionMessage) {
            Button("Continue", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Great job! You've successfully completed this lesson.")
        }
    }
}
