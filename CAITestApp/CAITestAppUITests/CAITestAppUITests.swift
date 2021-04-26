import SAPCAI
import XCTest

class CAITestAppUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAssistantViewKeyboardInputAndMockedResponse() throws {
        XCUIApplication().launch()
        let app = XCUIApplication()
        app.scrollViews.otherElements.buttons["Connect"].tap()
        let writeAMessageTextView = app.textViews["Ask me please"]
        writeAMessageTextView.tap()
        app.children(matching: .window).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 4).tap()
        app.keyboards.keys["H"].tap()
        app.keyboards.keys["i"].tap()
        app.buttons["arrow.up.square.fill"].tap()
        XCTAssertNotNil(app.staticTexts["Bot response for question Hi"].waitForExistence(timeout: 1))
    }
}
