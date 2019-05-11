//
//  Prompt.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/23/19.
//

import Foundation

public struct Prompt: Codable {
    
    // MARK: - Attributes
    
    /// A unique id for this prompt request.
    public let id: String?
    
    /// The unix timestamp when the prompt was sent.
    public let sentTime: Int?
    
    /// A boolean indicating if this prompt request expired before a user was able to answer it.
    /// If a prompt is answered, this value will always be false.
    public let isExpired: Bool
    
    /// An object describing the user's answer to this approval request.
    /// If the user has yet to respond or the prompt is past expiration, the answer field will be null.
    public let answer: PromptAnswer?
    
    /// Returns true if this Prompt object was approved.
    var wasApproved: Bool {
        guard let answer = answer else {
            return false
        }
        
        return answer.result
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case sentTime = "sent_at"
        case isExpired = "is_expired"
        case answer = "answer"
    }
    
    // TODO: Add sentTime as Date
}

public struct PromptStatus: Codable {
    
    // MARK: - Attributes
    
    public let isAnswered: Bool?
    public let isExpired: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case isAnswered = "is_answered"
        case isExpired = "is_expired"
    }
}

public struct PromptAnswer: Codable {
    
    // MARK: - Attributes
    
    /// The user's answer to whether or not they approve this prompt.
    public let result: Bool
    
    /// The unix timestamp when the user answered this prompt.
    public let time: Int?
    
    /// `AnswerMetadata` object about the device the user answered the prompt on.
    public let metadata: AnswerMetadata?
    
    private enum CodingKeys: String, CodingKey {
        case result = "result"
        case time = "time"
        case metadata = "metadata"
    }
}

public class AnswerMetadata: Codable {
    
    // MARK: - Attributes
    
    /// A physical location, like Oakland, CA for an action.
    public var location: String?
    
    /// The unix timestamp when the user answered this prompt.
    public var time: Int? = nil
    
    /// The IP address of the device the user responded to the prompt on.
    public var ipAddress: String?
    
    /// The browser used by the user to respond to the prompt.
    public var browser: String?
    
    /// The operating system used by the user to respond to the prompt.
    public var operatingSystem: String?
    
    private enum CodingKeys: String, CodingKey {
        case location = "location"
        case time = "time"
        case ipAddress = "ip_address"
        case browser = "browser"
        case operatingSystem = "operating_system"
    }
}

public class AnswerMetadataPost: AnswerMetadata {
    
    // MARK: - Attributes
    
    /// A time string, like Feb 21 at 4:45pm for an action.
    public var timestamp: String?
    
    // MARK: - Initialization
    
    public init(location: String? = nil, timestamp: String? = nil,
                ipAddress: String? = nil, browser: String? = nil,
                operatingSystem: String? = nil) {
        
        super.init()
        self.timestamp = timestamp
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
