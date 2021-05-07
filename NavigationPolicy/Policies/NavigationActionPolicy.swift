//
//  NavigationActionPolicy.swift
//  DuckDuckGo
//
//  Copyright © 2021 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import WebKit

public struct NavigationActionResult {
    public let action: WKNavigationActionPolicy
    public let cancellationHandler: NavigationActionCancellation?

    static var allow: NavigationActionResult {
        NavigationActionResult(action: .allow, cancellationHandler: nil)
    }
}

public typealias NavigationActionCancellation = () -> Void

public protocol NavigationActionPolicy {

    func check(navigationAction: WKNavigationAction) -> NavigationActionResult

}

public struct NavigationActionPolicyChecker {

    public static func check(policies: [NavigationActionPolicy], for navigationAction: WKNavigationAction) -> NavigationActionResult {

        guard let nextPolicy = policies.first else {
            return NavigationActionResult(action: .allow, cancellationHandler: nil)
        }

        let result = nextPolicy.check(navigationAction: navigationAction)

        if result.action == .cancel {
            return result
        } else {
            return check(policies: Array(policies.dropFirst()), for: navigationAction)
        }
    }

}
