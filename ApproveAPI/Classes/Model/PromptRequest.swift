//
//  PromptRequest.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/25/19.
//

import Foundation

struct PromptRequest: Codable {
    
    // MARK: - Atributes
    
    /// The user to which to send the approval request to.
    /// Can be either an email address or a phone number. Required.
    var userAddress: String
    
    /// The title of an approval request. Defaults to an empty string.
    var title: String? = nil
    
    /// The body of the approval request to show the user. Required.
    var body: String
    
    /// The number of seconds after which answers to this prompt will no longer be accepted.
    /// Defaults to 86400 (24 hours).
    var expirationTimeSeconds: Int? = 86400
    
    /// The approve action text. Defaults to 'Approve'.
    var approveButtonText: String? = "Approve"
    
    /// The reject action text. Defaults to 'Reject'.
    var rejectButtonText: String? = "Reject"
    
    /// If true, the request waits (long-polls) either until the user responds to the
    /// approval request, the prompt expires, or more than 10 minutes pass. Defaults to false.
    var longPoll: Bool? = false
    
    /// Add additional details to show the user in prompt approval request.
    var metadata: AnswerMetadata? = nil
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case body = "body"
        case userAddress = "user"
        case expirationTimeSeconds = "expires_in"
        case approveButtonText = "approve_text"
        case rejectButtonText = "reject_text"
        case longPoll = "long_poll"
        case metadata = "metadata"
    }
    
    // MARK: - Initialization
    
    init(userAddress: String, body: String) {
        self.userAddress = userAddress
        self.body = body
    }
}

// MARK: - Encodable+Extensions

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
