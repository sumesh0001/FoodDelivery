//
//  Debouncer.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation

@MainActor
final class Debouncer {
    private var task: Task<Void, Never>?
    private let delay: Duration

    init(delay: Duration = .milliseconds(300)) {
        self.delay = delay
    }

    func run(_ action: @escaping @Sendable () async -> Void) {
        task?.cancel()
        task = Task {
            do {
                try await Task.sleep(for: delay)
                guard !Task.isCancelled else { return }
                await action()
            } catch {
                // Task.sleep throws only on cancellation — safe to ignore.
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
