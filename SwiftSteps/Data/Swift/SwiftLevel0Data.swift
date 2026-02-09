import Foundation

struct SwiftLevel0Data {
    static let level = Level(
        levelNumber: 0,
        title: "Swift Basics",
        description: "Learn the fundamentals of Swift programming",
        lessons: [
            Lesson(
                title: "Your First Variable",
                description: "Learn how to create and use variables in Swift",
                content: "Variables are containers that store values. In Swift, you declare a variable using the 'var' keyword, followed by the variable name and its value.\n\nFor example: var greeting = \"Hello\"",
                codeChallenge: "var message = \"\"",
                solution: "var message = \"Hello, World!\"",
                hints: [
                    "Use quotes around text to make it a String",
                    "Replace the empty quotes with Hello, World!"
                ],
                estimatedMinutes: 5
            ),
            Lesson(
                title: "Constants with Let",
                description: "Understand the difference between var and let",
                content: "Constants are values that cannot change after being set. Use 'let' instead of 'var' when you want a value to stay the same.\n\nFor example: let pi = 3.14159",
                codeChallenge: "var name = \"Swift\"",
                solution: "let name = \"Swift\"",
                hints: [
                    "Change 'var' to 'let'",
                    "Constants use 'let' instead of 'var'"
                ],
                estimatedMinutes: 5
            ),
            Lesson(
                title: "Numbers in Swift",
                description: "Work with integers and decimals",
                content: "Swift has different types for whole numbers (Int) and decimals (Double). You can perform math operations on numbers.\n\nFor example: let sum = 5 + 3",
                codeChallenge: "let result = 0",
                solution: "let result = 10",
                hints: [
                    "Replace 0 with 10",
                    "Just write the number without quotes"
                ],
                estimatedMinutes: 5
            )
        ],
        track: .swift
    )
}
