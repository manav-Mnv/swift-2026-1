import SwiftUI

struct TrackSelectionView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel
    @EnvironmentObject var progressViewModel: ProgressViewModel
    
    @State private var showSwiftUILockedAlert = false
    @State private var navigateToLevelSelection = false
    @State private var selectedPath: LearningPath = .swift
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large) {
                // Header
                VStack(spacing: AppSpacing.small) {
                    Text("Choose Your Path")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Select a learning track to begin your journey")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppSpacing.large)
                
                // Swift Track Card
                TrackCard(
                    title: "Swift",
                    description: "Learn the fundamentals of Swift programming",
                    icon: "swift",
                    isLocked: false,
                    action: {
                        selectedPath = .swift
                        appStateViewModel.selectLearningPath(.swift)
                        navigateToLevelSelection = true
                    }
                )
                
                // SwiftUI Track Card
                TrackCard(
                    title: "SwiftUI",
                    description: "Build beautiful user interfaces with SwiftUI",
                    icon: "paintbrush.fill",
                    isLocked: !isSwiftUIUnlocked,
                    lockMessage: "Complete Swift Level 2 to unlock",
                    action: {
                        if isSwiftUIUnlocked {
                            selectedPath = .swiftUI
                            appStateViewModel.selectLearningPath(.swiftUI)
                            navigateToLevelSelection = true
                        } else {
                            showSwiftUILockedAlert = true
                        }
                    }
                )
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle("Learning Paths")
        .navigationDestination(isPresented: $navigateToLevelSelection) {
            LevelSelectionView(learningPath: selectedPath)
                .environmentObject(levelViewModel)
                .environmentObject(progressViewModel)
        }
        .alert("SwiftUI Track Locked", isPresented: $showSwiftUILockedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Complete all lessons in Swift Level 2 to unlock the SwiftUI track. Keep learning!")
        }
    }
    
    private var isSwiftUIUnlocked: Bool {
        appStateViewModel.isSwiftUITrackUnlocked(levelViewModel: levelViewModel, progress: progressViewModel)
    }
}

struct TrackCard: View {
    let title: String
    let description: String
    let icon: String
    let isLocked: Bool
    var lockMessage: String = ""
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.medium) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(isLocked ? AppColors.disabled : AppColors.primary)
                
                // Title
                Text(title)
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.textPrimary)
                
                // Description
                Text(description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                // Lock message if locked
                if isLocked && !lockMessage.isEmpty {
                    HStack(spacing: AppSpacing.small) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                        Text(lockMessage)
                            .font(AppFonts.caption)
                    }
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, AppSpacing.medium)
                    .padding(.vertical, AppSpacing.small)
                    .background(AppColors.disabled.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.large)
            .background(AppColors.surface)
            .cornerRadius(16)
            .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 4)
            .opacity(isLocked ? 0.7 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(title) learning track")
        .accessibilityHint(isLocked ? "This track is locked. \(lockMessage)" : "Tap to view levels")
    }
}
