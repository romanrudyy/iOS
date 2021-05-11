//
//  OpenExternallyPolicy.swift
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

public class OpenExternallyPolicy: NavigationActionPolicy {

    var openExternally: (URL) -> Void

    public init(openExternally: @escaping (URL) -> Void) {
        self.openExternally = openExternally
    }

    public func check(navigationAction: WKNavigationAction) -> NavigationActionResult {
        guard let url = navigationAction.request.url else {
            return .allow
        }

        let cancel = NavigationActionResult.immediate(.cancel, {
            self.openExternally(url)
        })

        let schemeType = SchemeHandler.schemeType(for: url)
        switch schemeType {
        case .external(let action) where action == .open:
            return cancel
        case .unknown where navigationAction.navigationType == .linkActivated:
            return cancel
        default:
            return .allow

        }
    }

}
