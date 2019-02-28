//
//  Constants.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/25/19.
//

import Foundation

public struct Callbacks {
    
    /// Get `Prompt` object completion handler.
    public typealias ApproveAPIGetPromptCompletion = (_ prompt: Prompt?, _ error: Error?) -> Void
    
    /// Get `PromptStatus` completion handler.
    public typealias ApproveAPIGetPromptStatusCompletion = (_ status: PromptStatus?, _ error: Error?) -> Void
}

/// API endpoints
///
/// - root: `/prompt`
/// - promptRetrieve: `/prompt/id`
/// - promptStatus: `/prompt/id`
enum Endpoint {
    
    case root
    case promptRetrieve(id: String)
    case promptStatus(id: String)
    
    var rawValue: String {
        switch self {
        case .root:
            return "https://approve.sh/prompt"
        case .promptRetrieve(let id):
            return "https://approve.sh/prompt/\(id)"
        case .promptStatus(let id):
            return "https://approve.sh/prompt/\(id)/status"
        }
    }
}
