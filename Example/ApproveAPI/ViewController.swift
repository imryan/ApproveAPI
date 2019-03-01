//
//  ViewController.swift
//  ApproveAPI
//
//  Created by Ryan Cohen on 2/25/19.
//  Copyright © 2019 Ryan Cohen. All rights reserved.
//

import UIKit
import ApproveAPI

class ViewController: UIViewController {
    
    // MARK: - Attributes
    
    private lazy var approveClient: ApproveAPI = {
        let client = ApproveAPI(apiKey: "", isTestKey: true, delegate: self)
        return client
    }()
    
    // MARK: - Functions
    
    private func sendPrompt() {
        // Create metadata
        let metadata = AnswerMetadataPost(location: "New York, NY", timestamp: "9:41 AM")
        metadata.browser = UIDevice.current.model
        
        // Create Prompt request object
        var request = PromptRequest(userAddress: "you@email.com", body: "Demo body message.")
        request.title = "Optional prompt title"
        request.metadata = metadata
        //request.longPoll = false
        
        // Send prompt to provided user address
        approveClient.sendPrompt(withRequest: request) { (prompt, error) in
            guard let promptId = prompt?.id, error == nil else {
                debugPrint("Error:", error ?? "N/A")
                return
            }
            
            debugPrint("Prompt Send:", prompt ?? "None")
            self.retrievePrompt(id: promptId)
        }
    }
    
    private func retrievePrompt(id: String) {
        approveClient.retreivePrompt(withId: id) { (prompt, error) in
            guard let promptId = prompt?.id, error == nil else {
                debugPrint("Error:", error ?? "N/A")
                return
            }
            
            debugPrint("Prompt Retrieval:", prompt ?? "None")
            self.checkPromptStatus(id: promptId)
        }
    }
    
    private func checkPromptStatus(id: String) {
        approveClient.checkPromptStatus(withId: id) { (status, error) in
            guard let status = status, error == nil else {
                debugPrint("Error:", error ?? "N/A")
                return
            }
            
            debugPrint("Prompt Status:", status)
        }
    }
    
    private func sendPromptDelegate() {
        // Create Prompt request object
        var request = PromptRequest(userAddress: "notryancohen@gmail.com", body: "Demo body message.")
        request.longPoll = true
        
        // Will notify via delegate
        approveClient.sendPrompt(withRequest: request, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sendPrompt()
        //sendPromptDelegate()
    }
}

// MARK: - ApproveAPIProtocol

extension ViewController: ApproveAPIProtocol {
    
    func approveClient(_ client: ApproveAPI, promptChanged prompt: Prompt) {
        debugPrint("> Prompt changed:", prompt)
    }
    
    func approveClient(_ client: ApproveAPI, promptStatusChanged status: PromptStatus) {
        debugPrint("> Status changed:", status)
    }
}
