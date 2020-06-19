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
            "\(Constant.BASE_SERVER)": .disableEvaluation
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
}
