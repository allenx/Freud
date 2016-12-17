//
//  ThreadManager.swift
//  Freud
//
//  Created by Allen X on 12/17/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

struct ThreadManager {
    static func synchronize(_ object: AnyObject!, closure: () -> ()) {
        objc_sync_enter(object)
        closure()
        objc_sync_exit(object)
    }
}
