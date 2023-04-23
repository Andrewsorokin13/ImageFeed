import XCTest

@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        sleep(2)
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 4))
        loginTextField.tap()
        loginTextField.typeText("")
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 6))
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        
        print(app.debugDescription)
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(3)
        cell.swipeUp()
        
        let likeButtons = tablesQuery.children(matching: .cell).element(boundBy: 1)
        likeButtons.buttons["likeButton"].tap()
        sleep(3)
        likeButtons.buttons["likeButton"].tap()
        sleep(5)
        likeButtons.tap()
        sleep(8)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(4)
        image.pinch(withScale: 3, velocity: 1)
        sleep(3)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(3)
        
        let navBackButtonWhiteButton = app.buttons["navBackButtonwWite"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        let nameLabel = app.staticTexts["ProfileNameLabel"]
        let loginNameLabel = app.staticTexts["ProfileLoginNameLabel"]
        
        XCTAssertTrue(nameLabel.exists)
        XCTAssertTrue(loginNameLabel.exists)
        
        let logOutButton  = app.buttons["ProfileExitButton"]
        logOutButton.tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["alertYesAction"].tap()
    }
}
