# ✅ ApproveAPI

[![CI Status](https://img.shields.io/travis/imryan/ApproveAPI.svg?style=flat)](https://travis-ci.org/imryan/ApproveAPI)
[![Version](https://img.shields.io/cocoapods/v/ApproveAPI.svg?style=flat)](https://cocoapods.org/pods/ApproveAPI)
[![License](https://img.shields.io/cocoapods/l/ApproveAPI.svg?style=flat)](https://cocoapods.org/pods/ApproveAPI)
[![Platform](https://img.shields.io/cocoapods/p/ApproveAPI.svg?style=flat)](https://cocoapods.org/pods/ApproveAPI)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Alamofire

## Installation

ApproveAPI is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ApproveAPI'
```

## Usage

#### Create ApproveAPI client with API key
```swift
let approveClient = ApproveAPI(apiKey: "your-api-key", isTestKey: true, delegate: nil)
```

#### Send a Prompt
```swift
// Create metadata
let metadata = AnswerMetadataPost(location: "New York, NY", timestamp: "9:41 AM")
metadata.browser = UIDevice.current.model

// Create Prompt request object
var request = PromptRequest(userType: .email("someone@email.com"), body: "Demo body message.")
request.title = "Optional prompt title"
request.metadata = metadata

// Send prompt to provided user address
approveClient.sendPrompt(withRequest: request) { (prompt, error) in
    guard let promptId = prompt?.id, error == nil else {
        debugPrint("Error:", error ?? "N/A")
        return
    }

    debugPrint("Prompt Send:", prompt ?? "None")
}
```

#### Retrieve a Prompt
```swift
approveClient.retreivePrompt(withId: "prompt_id") { (prompt, error) in
    guard let promptId = prompt?.id, error == nil else {
        debugPrint("Error:", error ?? "N/A")
        return
    }

    debugPrint("Prompt Retrieval:", prompt ?? "None")
}
```

#### Get Prompt status
```swift
approveClient.checkPromptStatus(withId: "prompt_id") { (status, error) in
    guard let status = status, error == nil else {
        debugPrint("Error:", error ?? "N/A")
        return
    }

    debugPrint("Prompt Status:", status)
}
```

#### Send prompt (with delegate response)
```swift
// Create Prompt request object
var request = PromptRequest(userType: .email("someone@email.com"), body: "Demo body message.")
request.longPoll = true // Wait for user response

// Will notify via delegate
approveClient.delegate = self // Can also set on init()
approveClient.sendPrompt(withRequest: request, completion: nil)
```
```swift
extension ViewController: ApproveAPIProtocol {

    func approveClient(_ client: ApproveAPI, promptChanged prompt: Prompt) {
        debugPrint("Prompt changed:", prompt)
    }

    func approveClient(_ client: ApproveAPI, promptStatusChanged status: PromptStatus) {
        debugPrint("Status changed:", status)
    }
}
```

## Author

Ryan Cohen, notryancohen@gmail.com

## License

ApproveAPI is available under the MIT license. See the LICENSE file for more info.
