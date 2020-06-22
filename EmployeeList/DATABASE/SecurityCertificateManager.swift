//
//  SecurityCertificateManager.swift
//  DEMS
//
//  Created by UITOUX on 10/02/20.
//  Copyright © 2020 UITOUX. All rights reserved.
//

import Foundation
import Alamofire

class SecurityCertificateManager {
    static let sharedInstance = SecurityCertificateManager()
    
    let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "http://api.openweathermap.org/data/2.5/weather": .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
}
