import Foundation
import SnapshotTesting
import SwiftUI
import XCTest

extension XCTestCase {
    enum SnapshotTest {
        static var isRecordMode: Bool = false
        static var configs: [SnapshotTestViewConfig] = {
            let configs = PresetViewImageConfigs()
            return configs.phones + configs.pads
        }()
    }
}

extension XCTestCase {
    override open func setUpWithError() throws {
        let device = UIDevice.current.name
        if device != "iPhone 11" {
            fatalError("Switch to using iPhone 11 for these tests.")
        }

        UIView.setAnimationsEnabled(false)
        UIApplication.shared.windows.first?.layer.speed = 100
    }
}

extension XCTestCase {
    func assertSnapShotAsImage(
        matching vc: UIViewController,
        with style: UIUserInterfaceStyle = .light,
        on viewConfig: ViewImageConfig,
        isRecording: Bool = false,
        recordAs referenceNamePrefix: String,
        in file: StaticString,
        delay: Double = 0.0
    ) {
        switch style {
        case .dark:
            assertSnapshotAtCustomDir(
                matching: vc,
                as: .wait(for: delay, on: .image(on: viewConfig, traits: .init(userInterfaceStyle: style))),
                named: self.recordingInfo(),
                record: isRecording,
                file: file,
                testName: referenceNamePrefix + "_dark"
            )
        default:
            assertSnapshotAtCustomDir(
                matching: vc,
                as: .wait(for: delay, on: .image(on: viewConfig, traits: .init(userInterfaceStyle: style))),
                named: self.recordingInfo(),
                record: isRecording,
                file: file,
                testName: referenceNamePrefix + "_light"
            )
        }
    }

    func assertSnapShotAsText(
        matching vc: UIViewController,
        with style: UIUserInterfaceStyle = .light,
        on viewConfig: ViewImageConfig,
        isRecording: Bool = false,
        recordAs referenceNamePrefix: String,
        in file: StaticString,
        delay: Double = 0.0
    ) {
        switch style {
        case .dark:
            assertSnapshotAtCustomDir(
                matching: vc,
                as: .wait(for: delay, on: .recursiveDescription(on: viewConfig, traits: .init(userInterfaceStyle: style))),
                named: self.recordingInfo(),
                record: isRecording,
                file: file,
                testName: referenceNamePrefix + "_dark"
            )
        default:
            assertSnapshotAtCustomDir(
                matching: vc,
                as: .wait(for: delay, on: .recursiveDescription(on: viewConfig, traits: .init(userInterfaceStyle: style))),
                named: self.recordingInfo(),
                record: isRecording,
                file: file,
                testName: referenceNamePrefix + "_light"
            )
        }
    }

    func recordingInfo() -> String {
        "recordedOn\(UIDevice.current.name)Running\(UIDevice.current.systemName)\(UIDevice.current.systemVersion)".replacingOccurrences(of: "\\W+", with: "", options: .regularExpression)
    }
}

extension XCTestCase {
    func assertSnapshot<V: SwiftUI.View>(_ view: V, for size: CGSize? = nil, configs: [SnapshotTestViewConfig] = SnapshotTest.configs, recordAs referenceNamePrefix: String = #function, file name: StaticString = #file) {
        let vc = view.toVC(size: size)
        for c in configs {
            self.assertSnapShotAsImage(matching: vc, with: .dark, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name)
            self.assertSnapShotAsImage(matching: vc, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name)
        }
    }

    func assertSnapshot<V: SwiftUI.View>(_ view: V, for size: CGSize? = nil, configs: [SnapshotTestViewConfig] = SnapshotTest.configs, style: UIUserInterfaceStyle? = nil, recordAs referenceNamePrefix: String = #function, file name: StaticString = #file, delay: Double = 0.0) {
        let vc = view.toVC(size: size)
        for c in configs {
            switch style {
            case .some:
                self.assertSnapShotAsImage(matching: vc, with: style!, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name, delay: delay)
            case .none:
                self.assertSnapShotAsImage(matching: vc, with: .dark, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name, delay: delay)
                self.assertSnapShotAsImage(matching: vc, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name, delay: delay)
            }
        }
    }

    func assertSnapshotAsText<V: SwiftUI.View>(_ view: V, for size: CGSize? = nil, configs: [SnapshotTestViewConfig] = SnapshotTest.configs, style: UIUserInterfaceStyle? = nil, recordAs referenceNamePrefix: String = #function, file name: StaticString = #file, delay: Double = 0.0) {
        let vc = view.toVC(size: size)
        for c in configs {
            switch style {
            case .some:
                self.assertSnapShotAsText(matching: vc, with: style!, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name, delay: delay)
            case .none:
                self.assertSnapShotAsText(matching: vc, with: .dark, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name, delay: delay)
                self.assertSnapShotAsText(matching: vc, on: c.config, isRecording: SnapshotTest.isRecordMode, recordAs: referenceNamePrefix + c.identifier, in: name, delay: delay)
            }
        }
    }
}

private func assertSnapshotAtCustomDir<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let snapshotDirectory = getFilePath(file)
    let failure = verifySnapshot(
        matching: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        snapshotDirectory: snapshotDirectory,
        timeout: timeout,
        file: file,
        testName: testName
    )
    guard let message = failure else { return }
    XCTFail(message, file: file, line: line)
}

internal func getFilePath(_ file: StaticString) -> String {
    let currentFile = file.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }
    let components = currentFile.components(separatedBy: "/")
    guard let index = components.firstIndex(of: "CAITestApp") else { return "" }
    let prefix = components.dropLast(components.count - index - 1).joined(separator: "/")
    let suffixs = URL(fileURLWithPath: currentFile).deletingPathExtension().pathComponents.suffix(2)
    guard let parentFolder = suffixs.first, let currentFolder = suffixs.last else { return "" }
    return prefix + "/cai-snapshot-references" + "/" + parentFolder + "/" + currentFolder
}
