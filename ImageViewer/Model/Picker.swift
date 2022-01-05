//
//  Picker.swift
//  ImageViewer
//
//  Created by Sebastian Morado on 1/5/22.
//

import Foundation
import SwiftUI
import AVFoundation

enum Picker {
    enum Source: String {
        case library, camera
    }
    
    enum PickerError: Error, LocalizedError {
        case unavailable
        case restricted
        case denied
        
        var errorDescription: String? {
            switch self {
            case .unavailable:
                return NSLocalizedString("There is no available camera on this device.", comment: "")
            case .restricted:
                return NSLocalizedString("You are not allowed to access media capture devices.", comment: "")
            case .denied:
                return NSLocalizedString("You have explicitly denied permission for media capture. Please open permissions/Privacy/Camera and grant access for this application.", comment: "")
            
            }
            
            
        }
    }
    
    static func checkPermissions()throws {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .restricted:
                throw PickerError.restricted
            case .denied:
                throw PickerError.denied
            default:
                break
            }
        } else {
            throw PickerError.unavailable
        }
    }
    
    struct CameraErrorType {
        let error: Picker.PickerError
        var message: String {
            error.localizedDescription
        }
        let button = Button("OK", role: .cancel) {}
    }
}
