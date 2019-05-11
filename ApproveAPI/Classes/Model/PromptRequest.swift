//
//  PromptRequest.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/25/19.
//

import Foundation

public struct PromptRequest: Codable {
    
    // MARK: - Atributes
    
    /// User Types
    ///
    /// - email: A standard email address.
    /// - sms: An E.164 format telephone number.
    /// - slack: Slack username, user email address, channel id, or channel name.
    /// - push: The string `@push:<user-id>` where `<user-id>` is an attribute you associate a user to via the API.
    public enum UserType {
        case email(_ email: String)
        case sms(_ sms: String)
        case slack(user: String)
        case push(user: String)

        var userAddress: String {
            switch self {
            case .email(let email):
                return email
            case .sms(let sms):
                return sms
            case .slack(let user):
                return "@slack:\(user)"
            case .push(let user):
                return "@push:\(user)"
            }
        }
    }
    
    /// The user to which to send the approval request to.
    /// Can be either an email address or a phone number. Required.
    public var user: String
    
    /// The title of an approval request. Defaults to an empty string.
    public var title: String? = nil
    
    /// The body of the approval request to show the user. Required.
    public var body: String
    
    /// The number of seconds after which answers to this prompt will no longer be accepted.
    /// Defaults to 86400 (24 hours).
    public var expirationTimeSeconds: Int? = 86400
    
    /// The approve action text. Defaults to 'Approve'.
    public var approveButtonText: String? = "Approve"
    
    /// The reject action text. Defaults to 'Reject'.
    public var rejectButtonText: String? = "Reject"
    
    /// If true, the request waits (long-polls) either until the user responds to the
    /// approval request, the prompt expires, or more than 10 minutes pass. Defaults to false.
    public var longPoll: Bool? = false
    
    /// Add additional details to show the user in prompt approval request.
    public var metadata: AnswerMetadata? = nil
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case body = "body"
        case user = "user"
        case expirationTimeSeconds = "expires_in"
        case approveButtonText = "approve_text"
        case rejectButtonText = "reject_text"
        case longPoll = "long_poll"
        case metadata = "metadata"
    }
    
    // MARK: - Initialization
    
    public init(userType: UserType, body: String) {
        self.user = userType.userAddress
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
