import XCTest
@testable import ApproveAPI

class CompletionTests: XCTestCase {
    
    // MARK: - Attributes
    
    private let approveClient: ApproveAPI = ApproveAPI(apiKey: Secrets.API_KEY_TEST, isTestKey: true)
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testSendPromptEmail() {
        let expectation = XCTestExpectation(description: "Send prompt to email address")
        
        var promptRequest = PromptRequest(userType: .email("you@email.com"), body: "Demo body message.")
        promptRequest.title = "Money request"
        promptRequest.metadata = AnswerMetadataPost(location: "New York, NY", timestamp: "9:41 AM")
        
        approveClient.sendPrompt(withRequest: promptRequest) { (prompt, error) in
            if let prompt = prompt {
                if let promptId = prompt.id {
                    XCTAssert(promptId.starts(with: "prompt_"), "Prompt ID begins with 'prompt_'")
                }
                else {
                    XCTAssertNotNil(prompt.id, "Prompt ID should not be nil.")
                }
                
                XCTAssertNotNil(prompt.sentTime, "Prompt timestamp should not be nil.")
                XCTAssertNil(prompt.answer, "Prompt answer should be nil on send unless `longPoll` is set to true.")
            }
            
            XCTAssertNotNil(prompt, "Prompt should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSendPromptSms() {
        let expectation = XCTestExpectation(description: "Send prompt to SMS number")
        
        var promptRequest = PromptRequest(userType: .sms("+12125551234"), body: "Demo body message.")
        promptRequest.title = "Money request"
        promptRequest.metadata = AnswerMetadataPost(location: "New York, NY", timestamp: "9:41 AM")
        
        approveClient.sendPrompt(withRequest: promptRequest) { (prompt, error) in
            if let prompt = prompt {
                if let promptId = prompt.id {
                    XCTAssert(promptId.starts(with: "prompt_"), "Prompt ID begins with 'prompt_'")
                }
                else {
                    XCTAssertNotNil(prompt.id, "Prompt ID should not be nil.")
                }
                
                XCTAssertNotNil(prompt.sentTime, "Prompt timestamp should not be nil.")
                XCTAssertNil(prompt.answer, "Prompt answer should be nil on send unless `longPoll` is set to true.")
            }
            
            XCTAssertNotNil(prompt, "Prompt should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSendPromptSlack() {
        let expectation = XCTestExpectation(description: "Send message to Slack user/channel")
        
        var promptRequest = PromptRequest(userType: .slack(user: "general"), body: "Demo body message.")
        promptRequest.title = "Money request"
        promptRequest.metadata = AnswerMetadataPost(location: "New York, NY", timestamp: "9:41 AM")
        
        approveClient.sendPrompt(withRequest: promptRequest) { (prompt, error) in
            if let prompt = prompt {
                if let promptId = prompt.id {
                    XCTAssert(promptId.starts(with: "prompt_"), "Prompt ID begins with 'prompt_'")
                }
                else {
                    XCTAssertNotNil(prompt.id, "Prompt ID should not be nil.")
                }
                
                XCTAssertNotNil(prompt.sentTime, "Prompt timestamp should not be nil.")
                XCTAssertNil(prompt.answer, "Prompt answer should be nil on send unless `longPoll` is set to true.")
            }
            
            XCTAssertNotNil(prompt, "Prompt should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSendPromptPush() {
        let expectation = XCTestExpectation(description: "Send push notification to user")
        
        var promptRequest = PromptRequest(userType: .push(user: "you@email.com"), body: "Demo body message.")
        promptRequest.title = "Money request"
        promptRequest.metadata = AnswerMetadataPost(location: "New York, NY", timestamp: "9:41 AM")
        
        approveClient.sendPrompt(withRequest: promptRequest) { (prompt, error) in
            if let prompt = prompt {
                if let promptId = prompt.id {
                    XCTAssert(promptId.starts(with: "prompt_"), "Prompt ID begins with 'prompt_'")
                }
                else {
                    XCTAssertNotNil(prompt.id, "Prompt ID should not be nil.")
                }
                
                XCTAssertNotNil(prompt.sentTime, "Prompt timestamp should not be nil.")
                XCTAssertNil(prompt.answer, "Prompt answer should be nil on send unless `longPoll` is set to true.")
            }
            
            XCTAssertNotNil(prompt, "Prompt should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRetrievePrompt() {
        let expectation = XCTestExpectation(description: "Retrieve prompt")
        
        approveClient.retreivePrompt(withId: "") { (prompt, error) in
            if let prompt = prompt {
                if let promptId = prompt.id {
                    XCTAssert(promptId.starts(with: "prompt_"), "Prompt ID begins with 'prompt_'")
                }
                else {
                    XCTAssertNotNil(prompt.id, "Prompt ID should not be nil.")
                }
                
                if let answer = prompt.answer {
                    XCTAssertNotNil(answer.result, "Answer result should not be nil.")
                    XCTAssertNotNil(answer.time, "Answer timestamp should not be nil.")
                    
                    if let metadata = answer.metadata, answer.result == true {
                        XCTAssertNotNil(metadata.ipAddress, "Metadata's IP Address should not be nil for answered Prompt.")
                        XCTAssertNotNil(metadata.browser, "Metadata's browser should not be nil for answered Prompt.")
                        XCTAssertNotNil(metadata.operatingSystem, "Metadata's OS should not be nil for answered Prompt.")
                    }
                }
                else {
                    XCTAssertNil(prompt.answer, "Prompt's answer should be nil")
                }
                
                XCTAssertNotNil(prompt.sentTime, "Prompt timestamp should not be nil.")
            }
            
            XCTAssertNotNil(prompt, "Prompt should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCheckPromptStatus() {
        let expectation = XCTestExpectation(description: "Check prompt status")
        
        approveClient.checkPromptStatus(withId: "") { (status, error) in
            XCTAssertNotNil(status, "Status must not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
