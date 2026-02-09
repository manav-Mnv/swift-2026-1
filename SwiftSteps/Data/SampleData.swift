import Foundation

struct SampleData {
    static let levels: [Level] = [
        Level(
            levelNumber: 1,
            title: "Hello Swift",
            description: "Your first steps into the world of Swift programming.",
            lessons: [
                Lesson(
                    title: "Variables",
                    description: "Learn how to store data.",
                    content: "Variables allow you to store values...",
                    codeChallenge: "var myVar = 10",
                    estimatedMinutes: 5
                ),
                Lesson(
                    title: "Constants",
                    description: "Values that don't change.",
                    content: "Constants are declared with let...",
                    codeChallenge: "let myConst = 20",
                    estimatedMinutes: 5
                )
            ],
            track: .swift
        ),
        Level(
            levelNumber: 2,
            title: "Control Flow",
            description: "Making decisions with code.",
            lessons: [
                Lesson(
                    title: "If Statements",
                    description: "Conditional logic.",
                    content: "If statements let you run code based on conditions...",
                    codeChallenge: "if true { print(\"Hello\") }",
                    estimatedMinutes: 10
                )
            ],
            track: .swift
        )
    ]
}
