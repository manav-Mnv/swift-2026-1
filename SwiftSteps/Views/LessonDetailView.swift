import SwiftUI

struct LessonDetailView: View {

    @StateObject private var viewModel: LessonViewModel
    @State private var userCode: String = ""

    init(lesson: Lesson) {
        _viewModel = StateObject(
            wrappedValue: LessonViewModel(lesson: lesson)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {

                lessonHeader

                lessonContent

                if lessonHasCode {
                    codeEditor
                    runSection
                }

                outputSection
            }
            .padding(AppSpacing.screen)
        }
        .navigationTitle(viewModel.lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Lesson Header (Context)
private extension LessonDetailView {

    var lessonHeader: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(viewModel.lesson.title)
                .font(AppFonts.title)

            Text(viewModel.lesson.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

// MARK: - Lesson Content (Theory)
private extension LessonDetailView {

    var lessonContent: some View {
        Text(viewModel.lesson.content)
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryText)
    }
}

// MARK: - Code Editor (Safe, Simple)
private extension LessonDetailView {

    var lessonHasCode: Bool {
        viewModel.lesson.codeChallenge != nil
    }

    var codeEditor: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {

            Text("Try it yourself")
                .font(AppFonts.section)

            TextEditor(text: $userCode)
                .font(AppFonts.code)
                .frame(minHeight: 160)
                .padding(AppSpacing.small)
                .background(AppColors.codeBackground)
                .cornerRadius(8)
                .onAppear {
                    userCode = viewModel.lesson.codeChallenge ?? ""
                }
        }
    }
}

// MARK: - Run Section (Single Action Only)
private extension LessonDetailView {

    var runSection: some View {
        VStack(spacing: AppSpacing.medium) {

            PrimaryButton(
                title: runButtonTitle,
                action: {
                    viewModel.run(userCode: userCode)
                }
            )
            .disabled(viewModel.runState == .running)
        }
    }

    var runButtonTitle: String {
        switch viewModel.runState {
        case .running:
            return "Running…"
        default:
            return "Run"
        }
    }
}

// MARK: - Output Section (Calm Feedback)
private extension LessonDetailView {

    var outputSection: some View {
        Group {
            if !viewModel.outputMessage.isEmpty {
                CardView {
                    Text(viewModel.outputMessage)
                        .font(AppFonts.body)
                        .foregroundColor(outputColor)
                }
            }
        }
    }

    var outputColor: Color {
        switch viewModel.runState {
        case .success:
            return AppColors.success
        case .failure:
            return AppColors.warning
        default:
            return AppColors.primaryText
        }
    }
}
