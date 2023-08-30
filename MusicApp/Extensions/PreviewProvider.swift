//
//  PreviewProvider.swift
//  MusicApp
//
//  Created by Steve on 23/06/2023.
//

import Foundation
import SwiftUI


#if DEBUG

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

/// Class to create global environment objects to allow Preview Provider to display content
class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {}
    
    let globalStudentVM = Global().test(token: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNiwidGVhY2hlcl9pZCI6bnVsbH0.tUpPUFtU8yPaafM9-HMs4sKyf-eYiWNdQh-SfESmyqc")
    
    let globalTeacherVM = Global().test(token: "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ0ZWFjaGVyX2lkIjoxfQ.F5NtYLnmT_4zAZ2L9UAOiwzyBsyc-QmdszDFUBceGHQ")
    
    let globalVMNotAuthenticated = Global()
    
}

#endif
