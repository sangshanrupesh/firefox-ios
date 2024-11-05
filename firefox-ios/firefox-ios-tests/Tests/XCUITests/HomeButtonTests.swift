// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import XCTest

class HomeButtonTests: BaseTestCase {
    override func tearDown() {
        XCUIDevice.shared.orientation = .portrait
        super.tearDown()
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2306925
    func testGoHome() throws {
        navigator.openURL(path(forTestPage: "test-mozilla-org.html"), waitForLoading: true)
        app.buttons[AccessibilityIdentifiers.Toolbar.addNewTabButton].waitAndTap()
        navigator.nowAt(NewTabScreen)
        waitForTabsButton()
        if !iPad() {
            XCTAssertEqual(app.buttons[AccessibilityIdentifiers.Toolbar.searchButton].label, "Search")
        }
        navigator.openURL(path(forTestPage: "test-mozilla-book.html"), waitForLoading: true)
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.addNewTabButton])

        XCUIDevice.shared.orientation = .landscapeRight
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.addNewTabButton])
        app.buttons[AccessibilityIdentifiers.Toolbar.addNewTabButton].tap()
        navigator.nowAt(NewTabScreen)
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2306883
    func testSwitchHomepageKeyboardRaisedUp() {
        // Open a new tab and load a web page
        navigator.openURL("http://localhost:\(serverPort)/test-fixture/find-in-page-test.html")
        waitUntilPageLoad()

        // Switch to Homepage by taping the home button
        app.buttons[AccessibilityIdentifiers.Toolbar.addNewTabButton].waitAndTap()

        validateHomePageAndKeyboardNotRaisedUp()
    }

    // https://mozilla.testrail.io/index.php?/cases/view/2306881
    func testAppLaunchKeyboardNotRaisedUp() {
        mozWaitForElementToExist(app.buttons[AccessibilityIdentifiers.Toolbar.settingsMenuButton])
        validateHomePageAndKeyboardNotRaisedUp()
    }

    private func validateHomePageAndKeyboardNotRaisedUp() {
        // With the new toolbar redesign, the home page button has been replaced with add new tab button
        // This will cause the keyboard to automatically raise up.
        // The home page is loaded. The keyboard is raised up
        navigator.nowAt(NewTabScreen)
        waitForTabsButton()
        XCTAssertTrue(app.keyboards.element.isVisible(), "The keyboard is not shown")
    }
}
