//
//  ApproveAPI.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/23/19.
//

import Foundation

protocol ApproveAPIProtocol {
    
    /// Prompt changed
    ///
    /// - Parameters:
    ///   - client: `ApproveAPI` client.
    ///   - prompt: `Prompt` object that was updated.
    func approveClient(_ client: ApproveAPI, promptChanged prompt: Prompt)
    
    /// Prompt status changed
    ///
    /// - Parameters:
    ///   - client: `ApproveAPI` client.
    ///   - prompt: `PromptStatus` object that was updated.
    func approveClient(_ client: ApproveAPI, promptStatusChanged status: PromptStatus)
}

class ApproveAPI {
    
    // MARK: - Attributes
    
    /// Delegate for receiving data callbacks
    var delegate: ApproveAPIProtocol?
    
    /// Networking manager
    private var networking: Networking!
    
    // MARK: - Initialization
    
    /// Initialization
    ///
    /// - Parameters:
    ///   - apiKey: ApproveAPI token.
    ///   - isTestKey: If true, network requests use test key.
    init(apiKey: String, isTestKey: Bool, delegate: ApproveAPIProtocol? = nil) {
        self.networking = Networking(apiKey: apiKey, isTestKey: isTestKey, delegate: self)
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
    /// Creates a prompt and pushes it to the user
    /// (sends via email, sms, or other supported protocols).
    ///
    /// - Parameter request: `PromptRequest` object containing prompt information.
    /// - Parameter completion: Returns created `Prompt` object and/or an `Error`
    func sendPrompt(withRequest request: PromptRequest, completion: Callbacks.ApproveAPIGetPromptCompletion?) {
        networking.sendPrompt(withRequest: request, completion: completion)
    }
    
    /// The Prompt object if the call succeeds. This request supports long polling
    /// with the the `longPoll` parameter. The answer field may or not be null depending on
    /// if the user has responded to the prompt or not.
    ///
    /// - Parameter id: The identifier for a pending or completed `Prompt`.
    /// - Parameter longPoll: The request should wait until either the user responds to the approval request, the prompt request expires, or more than 10 minutes pass. Defaults to false.
    /// - Parameter completion: Returns created `Prompt` object and/or an `Error`
    func retreivePrompt(withId id: String, longPoll: Bool = false, completion: Callbacks.ApproveAPIGetPromptCompletion?) {
        networking.retreivePrompt(withId: id, longPoll: longPoll, completion: completion)
    }
    
    /// This is a convenience endpoint that doesn't require authentication
    /// for checking if a particular prompt has been answered or not.
    ///
    /// - Parameter id: The identifier for a pending or completed `Prompt`.
    /// - Parameter completion: Returns requested `PromptStatus` object and/or an `Error`
    func checkPromptStatus(withId id: String, completion: Callbacks.ApproveAPIGetPromptStatusCompletion?) {
        networking.checkPromptStatus(withId: id, completion: completion)
    }
}

extension ApproveAPI: NetworkingProtocol {
    
    func networkingClient(_ client: Networking, promptChanged prompt: Prompt?) {
        guard let prompt = prompt else { return }
        delegate?.approveClient(self, promptChanged: prompt)
    }
    
    func networkingClient(_ client: Networking, promptStatusChanged status: PromptStatus?) {
        guard let status = status else { return }
        delegate?.approveClient(self, promptStatusChanged: status)
    }
}
