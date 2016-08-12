//
//  UploadManager.swift
//  QiNiuDrop
//
//  Created by song on 16/6/27.
//  Copyright © 2016年 song. All rights reserved.
//

import Cocoa
import Qiniu

let AK = "1tcwA-6KJ0C4SVODQ2dE2TwsfGfCM5KzlR6Xm-9W"
let SK = "woQvw6xOmNKCgxU8nDI8gARfNQE0OC5_-wJusa1h"
let bucket = "billchaiblog"
let bucketHost = "http://7vii9n.com1.z0.glb.clouddn.com/"

/**
let AK = "g4-e2qB0UfVA5b4K4vb4bVWRwtAWOktgFAzJUBQ2"
let SK = "orCj8625m47ULqDV2-sGinCpVjnEGxTto6ZQrAMw"
let bucket = "test"
let bucketHost = "http://7xruw8.com1.z0.glb.clouddn.com/"
**/

class UploadManager: NSObject {

    var qiniuUpManager : QNUploadManager {
        get {
            if _qiniuUpManager == nil {
                _qiniuUpManager = QNUploadManager.init()
            }
            return _qiniuUpManager!
        }
    }
    var _qiniuUpManager: QNUploadManager? = nil
    
    func qiniuUpload(filePath: NSString?, Name name: NSString?,Complete complete: (url : NSString?) -> Void) {
        let token = GenToken.makeToken(AK, secretKey: SK, bucket: bucket)
        self.qiniuUpManager.putFile(filePath! as String, key: "blog_".stringByAppendingString(name! as String), token: token, complete: { (reponseInfo : QNResponseInfo!, key : String!, resp : [NSObject : AnyObject]!) in
            complete(url: bucketHost.stringByAppendingString(key));
            }, option: nil)
    }
}
