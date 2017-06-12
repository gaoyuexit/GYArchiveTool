//
//  RequestAuthorizationTool.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/3/14.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

class RequestAuthorizationTool {

    /// 相机权限
    static func cameraRequestAuthorization(queue: DispatchQueue = .main, complete: @escaping (_ status: AVAuthorizationStatus) -> Void) {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:   complete(.authorized)
        case .denied:       complete(.denied)
        case .restricted:   complete(.restricted)
        case .notDetermined:
            queue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                complete( granted ? .authorized : .denied )
                queue.resume()
            })
        }
    }
    /// 麦克风权限
    static func microphoneRequestAuthorization(queue: DispatchQueue = .main, complete: @escaping (_ status: AVAuthorizationStatus) -> Void) {
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio) {
        case .authorized:   complete(.authorized)
        case .denied:       complete(.denied)
        case .restricted:   complete(.restricted)
        case .notDetermined:
            queue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted) in
                complete( granted ? .authorized : .denied )
                queue.resume()
            })
        }
    }
}
