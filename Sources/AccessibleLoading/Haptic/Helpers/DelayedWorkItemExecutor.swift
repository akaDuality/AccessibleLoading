import Foundation
import Combine

final class DelayedWorkItemExecutor: Cancellable {

    // MARK: - Internal Init

    init(delay: TimeInterval, queue: DispatchQueue = .main, _ block: @escaping () -> Void) {
        self.workItem = DispatchWorkItem(block: block)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    deinit {
        cancel()
    }

    // MARK: - Internal Methods

    func cancel() {
        workItem.cancel()
    }

    // MARK: - Private Properties

    private let workItem: DispatchWorkItem

}
