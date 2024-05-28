//
//  BaseAuthenticator.swift
//  UberRides
//
//  Copyright © 2016 Uber Technologies, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

/// Base class for authorization flows
public class BaseAuthenticator: UberAuthenticating {
    /// Scopes to request during login
    public var scopes: [UberScope]
    
    public var requestUri: String?
    
    public init(scopes: [UberScope],
                      requestUri: String? = nil) {
        self.scopes = scopes
        self.requestUri = requestUri
    }

    /**
     Get URL to begin login process.
     */
    var authorizationURL: URL {
        preconditionFailure("Not Implemented, this is an abstract class. ")
    }

    public func consumeResponse(url: URL, completion: AuthenticationCompletionHandler?) {
        if AuthenticationURLUtility.shouldHandleRedirectURL(url) {
            do {
                let accessToken = try AccessToken(redirectURL: url)
                
                completion?(accessToken, nil)
            } catch let error as NSError {
                completion?(nil, error)
            } catch {
                completion?(nil, UberAuthenticationErrorFactory.errorForType(ridesAuthenticationErrorType: .invalidResponse))
            }
        }
    }
}
