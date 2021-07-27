@testable import SAPCAI
import XCTest

final class MessageDataTests: XCTestCase {
    var base: [MessageData] = []

    override func setUp() {
        self.base = [
            self.message(with: "1"),
            self.message(with: "2"),
            self.message(with: "3")
        ]
    }

    func testDeltaPositive() {
        let incomingMessages: [MessageData] = [self.message(with: "New"), self.message(with: "1")]
        guard let newMessages = incomingMessages.delta(to: self.base) else {
            XCTFail("array expected")
            return
        }
        XCTAssertEqual(newMessages.count, 1)
        XCTAssertEqual(newMessages[0].id, "New")
    }

    func testDeltaNegative() {
        let incomingMessages: [MessageData] = []
        guard let newMessages = incomingMessages.delta(to: self.base) else {
            XCTFail("array expected")
            return
        }
        XCTAssertEqual(newMessages.count, 0)

        guard let noNewMessages = self.base.delta(to: self.base) else {
            XCTFail("array expected")
            return
        }
        XCTAssertEqual(noNewMessages.count, 0)
    }

    func message(with id: String) -> CAIResponseMessageData {
        CAIResponseMessageData(id: id, participant: CAIResponseParticipantData(isBot: false, senderId: "doesNotMatter"), attachment: UIModelData(type: "text"), conversation: "doesNotMatter", receivedAt: Date())
    }
}
