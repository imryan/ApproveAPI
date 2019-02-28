import XCTest
@testable import ApproveAPI

class CompletionTests: XCTestCase {
    
    private let approveClient: ApproveAPI = ApproveAPI(apiKey: Secrets.API_KEY_TEST, isTestKey: true)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSendPrompt() {
        let expectation = XCTestExpectation(description: "Send prompt")
        var promptRequest = PromptRequest(userAddress: "notryancohen@gmail.com", body: "Some body...ha ha")
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
                    //    "result": true, (if metadata[answer][ip/browser/os] isn't nil)
                    XCTAssertNotNil(answer.result, "Answer result should not be nil.")
                    XCTAssertNotNil(answer.time, "Answer timestamp should not be nil.")
                    
                    if let metadata = answer.metadata, answer.result == true {
                        //    "ip_address": "172.17.54.22",
                        //    "browser": "Chrome",
                        //    "operating_system": "Windows 10"
                        XCTAssertNotNil(metadata.ipAddress, "Metadata's IP Address should not be nil for answered Prompt.")
                        XCTAssertNotNil(metadata.browser, "Metadata's browser should not be nil for answered Prompt.")
                        XCTAssertNotNil(metadata.operatingSystem, "Metadata's OS should not be nil for answered Prompt.")
                    }
                }
                else {
                    // ...
                }
                
                XCTAssertNotNil(prompt.sentTime, "Prompt timestamp should not be nil.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
//    func testCheckPromptStatus() {
//        let expectation = XCTestExpectation(description: "Send prompt")
//
//        approveClient.checkPromptStatus(withId: lastPromptIdentifier ?? "") { (status, error) in
//
//        }
//
//        wait(for: [expectation], timeout: 3.0)
//    }
    
    //    {
    //    "id": "prompt_veC5W1pLecGpUTdSJk",
    //    "sent_at": 1549336110,
    //    "is_expired": false,
    //    "answer": {
    //    "result": true,
    //    "time": 1549336241,
    //    "metadata": {
    //    "ip_address": "172.17.54.22",
    //    "browser": "Chrome",
    //    "operating_system": "Windows 10"
    //    }
    //    }
    //    }
    
//    func testSendPromptLongPoll() {
//        let expectation = XCTestExpectation(description: "Send prompt")
//
//        var promptRequest = PromptRequest(userAddress: "notryancohen@gmail.com", body: "Some body...ha ha")
//        promptRequest.metadata = AnswerMetadataPost(location: "New York, NY", timestamp: "9:41 AM")
//        promptRequest.longPoll = true
//
//        approveClient.sendPrompt(withRequest: promptRequest) { (prompt, error) in
//            if let prompt = prompt {
//                if let promptId = prompt.id {
//                    XCTAssert(promptId.starts(with: "prompt_"), "Prompt ID begins with 'prompt_'")
//                }
//                else {
//                    XCTAssertNotNil(prompt.id, "Prompt ID should not be nil.")
//                }
//
//                XCTAssertNotNil(prompt.sentTime, "Prompt timestamp should not be nil.")
//                XCTAssertNotNil(prompt.answer, "Prompt answer should not be nil on send unless `longPoll` is set to false.")
//            }
//            expectation.fulfill()
//        }
//
//        // User must confirm on receiving side
//        wait(for: [expectation], timeout: 10.0)
//    }
}

class DelegateTests: XCTestCase {
    
}
