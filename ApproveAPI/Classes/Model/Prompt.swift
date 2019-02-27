//
//  Prompt.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/23/19.
//

import Foundation

struct Prompt: Codable { 
    
    // MARK: - Attributes
    
    /// A unique id for this prompt request.
    let id: String?
    
    /// The unix timestamp when the prompt was sent.
    let sentTime: Int?
    
    /// A boolean indicating if this prompt request expired before a user was able to answer it.
    /// If a prompt is answered, this value will always be false.
    let isExpired: Bool
    
    /// An object describing the user's answer to this approval request.
    /// If the user has yet to respond or the prompt is past expiration, the answer field will be null.
    let answer: PromptAnswer?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case sentTime = "sent_at"
        case isExpired = "is_expired"
        case answer = "answer"
    }
    
    // TODO: Add convenience 'wasAccepted', etc.
    // TODO: Add sentTime as Date
}

struct PromptStatus: Codable {
    
    // MARK: - Attributes
    
    let isAnswered: Bool
    let isExpired: Bool
    
    private enum CodingKeys: String, CodingKey {
        case isAnswered = "is_answered"
        case isExpired = "is_expired"
    }
}

struct PromptAnswer: Codable {
    
    // MARK: - Attributes
    
    /// The user's answer to whether or not they approve this prompt.
    let result: Bool
    
    /// The unix timestamp when the user answered this prompt.
    let time: Int?
    
    /// `AnswerMetadata` object about the device the user answered the prompt on.
    let metadata: AnswerMetadata?
    
    private enum CodingKeys: String, CodingKey {
        case result = "result"
        case time = "time"
        case metadata = "metadata"
    }
}

class AnswerMetadata: Codable {
    
    // MARK: - Attributes
    
    /// A physical location, like Oakland, CA for an action.
    var location: String?
    
    /// The unix timestamp when the user answered this prompt.
    let time: Int? = nil
    
    /// The IP address of the device the user responded to the prompt on.
    var ipAddress: String?
    
    /// The browser used by the user to respond to the prompt.
    var browser: String?
    
    /// The operating system used by the user to respond to the prompt.
    var operatingSystem: String?
    
    private enum CodingKeys: String, CodingKey {
        case location = "location"
        case time = "time"
        case ipAddress = "ip_address"
        case browser = "browser"
        case operatingSystem = "operating_system"
    }
}

class AnswerMetadataPost: AnswerMetadata {
    
    // MARK: - Attributes
    
    /// A time string, like Feb 21 at 4:45pm for an action.
    var timestamp: String?
}
