import Foundation

/// Prints the filename, function name, line number and textual representation of `object`
/// and a newline character into the standard output if the build setting for
/// "Active Compilation Conditions" (SWIFT_ACTIVE_COMPILATION_CONDITIONS) defines `DEBUG`.
///
/// The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
///
/// Only the first parameter needs to be passed to this function.
///
/// The textual representation is obtained from the `object` using `String(reflecting:)`
/// which works for _any_ type. To provide a custom format for the output make your object conform
/// to `CustomDebugStringConvertible` and provide your format in the `debugDescription` parameter.
/// - Parameters:
///   - object: The object whose textual representation will be printed. If this is an expression, it is lazily evaluated.
///   - file: The name of the file, defaults to the current file without the ".swift" extension.
///   - function: The name of the function, defaults to the function within which the call is made.
///   - line: The line number, defaults to the line number within the file that the call is made.
func dlog<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        logit(object: value, file: file, function: function, line: line)
    #endif
}

func dlog(_ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        logit(object: nil, file: file, function: function, line: line)
    #endif
}

#if DEBUG
    private func logit(object: Any?, file: String, function: String, line: Int) {
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
    
        var output = "<\(queue)> \(fileURL) \(function)[\(line)]"

        if let object = object {
            output += ": " + String(reflecting: object)
        }

        print(output)
    }
#endif

/// Outputs a `dump` of the passed in value along with an optional label, the filename,
/// function name, and line number to the standard output if the build setting for
/// "Active Complilation Conditions" (SWIFT_ACTIVE_COMPILATION_CONDITIONS) defines `DEBUG`.
///
/// The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
///
/// Only the first parameter needs to be passed in to this function. If a label is required to describe what is
/// being dumped, the `label` parameter can be used. If `nil` (the default), no label is output.
/// - Parameters:
///   - object: The object to be `dump`ed. If it is obtained by evaluating an expression, this is lazily evaluated.
///   - label: An optional label that may be used to describe what is being dumped.
///   - file: he name of the file, defaults to the current file without the ".swift" extension.
///   - function: The name of the function, defaults to the function within which the call is made.
///   - line: The line number, defaults to the line number within the file that the call is made.
func dDump<T>(_ object: @autoclosure () -> T, label: String? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
{
    #if DEBUG
        let value = object()
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("--------")
        print("<\(queue)> \(fileURL) \(function):[\(line)] ")
        label.flatMap { print($0) }
        dump(value)
        print("--------")
    #endif
}
