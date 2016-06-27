//
//  UploadManager.swift
//  QiNiuDrop
//
//  Created by song on 16/6/27.
//  Copyright © 2016年 song. All rights reserved.
//

import Cocoa

let AK = "七牛上的accessKey"
let SK = "七牛上的secretKey"
let bucket = "在七牛上你要上传的bucket名字"
let bucketHost = "该bucket的外链相对地址"


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
        self.qiniuUpManager.putFile(filePath! as String, key: name! as String, token: token, complete: { (reponseInfo : QNResponseInfo!, key : String!, resp : [NSObject : AnyObject]!) in
            complete(url: bucketHost.stringByAppendingString(key));
            }, option: nil)
    }
}
