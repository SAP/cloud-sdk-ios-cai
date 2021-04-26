import Foundation

/// :nodoc:
/// *Abstract* Base Async Operation class
class AsynchronousOperation: Operation {
    /// Concurrent queue for synchronizing access to `state`.
    private let lockQueue = DispatchQueue(label: Bundle.cai.bundleIdentifier! + ".asyncOp.state", attributes: .concurrent)

    override var isAsynchronous: Bool {
        true
    }

    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            self.lockQueue.sync { () -> Bool in
                _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            self.lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            lockQueue.sync { () -> Bool in
                _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        guard !isCancelled else {
            self.finish()
            return
        }

        self.isFinished = false
        self.isExecuting = true
        self.execute()
    }

    func execute() {
        preconditionFailure("Subclasses must implement `execute` without overriding super.")
    }

    func finish() {
        self.isExecuting = false
        self.isFinished = true
    }
}
