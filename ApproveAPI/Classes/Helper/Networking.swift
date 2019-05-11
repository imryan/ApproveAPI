//
//  Networking.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/25/19.
//

import Foundation
import Alamofire

protocol NetworkingProtocol {
    func networkingClient(_ client: Networking, promptChanged prompt: Prompt?)
    func networkingClient(_ client: Networking, promptStatusChanged status: PromptStatus?)
}

class Networking {

    // MARK: - Attributes

    private enum RequestError: Error, LocalizedError {
        case error(message: String)

        var errorDescription: String? {
            switch self {
            case .error(let message):
                return message
            }
        }
    }

    var delegate: NetworkingProtocol?

    private var apiKey: String?
    private var isUsingTestKey: Bool

    private var apiKeyBase64: String? {
        if let apiKey = apiKey {
            return "Basic \(Data("\(apiKey):".utf8).base64EncodedString())"
        }
        return nil
    }

    // MARK: - Initialization

    init(apiKey: String, isTestKey: Bool, delegate: NetworkingProtocol? = nil) {
        self.apiKey = apiKey
        self.isUsingTestKey = isTestKey
        self.delegate = delegate
    }

    // MARK: - Functions

    func sendPrompt(withRequest request: PromptRequest, completion: Callbacks.ApproveAPIGetPromptCompletion?) {
        post(.root, parameters: request.dictionary) { (data, error) in
            guard let data = data else {
                if let completion = completion {
                    completion(nil, error)
                }
                return
            }

            let prompt = try? JSONDecoder().decode(Prompt.self, from: data)
            self.delegate?.networkingClient(self, promptChanged: prompt)

            if let completion = completion {
                completion(prompt, error)
            }
        }
    }

    func retreivePrompt(withId id: String, longPoll: Bool = false, completion: Callbacks.ApproveAPIGetPromptCompletion?) {
        get(.promptRetrieve(id: id), parameters: ["long_poll": longPoll], needsAuthentication: true) { (data, error) in
            guard let data = data else {
                if let completion = completion {
                    completion(nil, error)
                }
                return
            }

            let prompt = try? JSONDecoder().decode(Prompt.self, from: data)
            self.delegate?.networkingClient(self, promptChanged: prompt)

            if let completion = completion {
                completion(prompt, error)
            }
        }
    }

    func checkPromptStatus(withId id: String, completion: Callbacks.ApproveAPIGetPromptStatusCompletion?) {
        get(.promptStatus(id: id), parameters: nil, needsAuthentication: false) { (data, error) in
            guard let data = data else {
                if let completion = completion {
                    completion(nil, error)
                }
                return
            }

            let promptStatus = try? JSONDecoder().decode(PromptStatus.self, from: data)
            self.delegate?.networkingClient(self, promptStatusChanged: promptStatus)

            if let completion = completion {
                completion(promptStatus, error)
            }
        }
    }
}

// MARK: - Netwoking+Extension

extension Networking {

    // MARK: - Get

    private func get(_ endpoint: Endpoint, parameters: Parameters? = nil, needsAuthentication: Bool = true,
                     completion: @escaping (_ data: Data?, _ error: Error?) -> ()) {

        var headers: HTTPHeaders = [:]

        if needsAuthentication {
            if let apiKeyBase64 = apiKeyBase64 {
                headers["Authorization"] = apiKeyBase64
            }
            else {
                assert(apiKey != nil, "API key required to access this endpoint.")
            }
        }

        Alamofire.request(endpoint.rawValue, method: .get, parameters: parameters,
                          encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse) in

            completion(dataResponse.data, dataResponse.error)
        }
    }

    // MARK: - Post

    private func post(_ endpoint: Endpoint, parameters: Parameters? = nil,
                      completion: @escaping (_ data: Data?, _ error: Error?) -> ()) {

        guard let apiKeyBase64 = apiKeyBase64 else { return }

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": apiKeyBase64
        ]

        Alamofire.request(endpoint.rawValue, method: .post, parameters: parameters,
                          encoding: JSONEncoding.default, headers: headers).responseJSON { (dataResponse) in

            if let data = dataResponse.data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                if let errorMessage = json["error"] as? String {
                    let error: RequestError = .error(message: errorMessage)
                    completion(nil, error)
                    return
                }
            }

            completion(dataResponse.data, dataResponse.error)
        }
    }
}
