//
//  ViewController.swift
//  QiNiuDrop
//
//  Created by song on 16/6/27.
//  Copyright © 2016年 song. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, DragDropViewProtocol {

    var textField : NSTextField!
    var copyButton : NSButton!
    var updatePasteImageBtn : NSButton!
    
    var uploadManager : UploadManager {
        get {
            if _uploadManager == nil {
                _uploadManager = UploadManager.init();
            }
            return _uploadManager!;
        }
    }
    
    var _uploadManager : UploadManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dragView = DragDropView.init(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height));
        dragView.dragProtocol = self;
        self.view.addSubview(dragView);
        
        updatePasteImageBtn = NSButton.init(frame: CGRectMake(0, 0, 200, 80));
        updatePasteImageBtn.title = "上传剪切板图片到七牛";
        updatePasteImageBtn.target = self;
        updatePasteImageBtn.action = #selector(ViewController.updatePasteImageBtnAction(_:));
        self.view.addSubview(updatePasteImageBtn)
        
        textField = NSTextField.init(frame: CGRectMake(0, 80, 200, 80))
        textField.textColor = NSColor.blackColor()
        textField.placeholderString = "图片最终的外链地址"
        textField.enabled = false
        self.view.addSubview(textField)
        
        copyButton = NSButton.init(frame: CGRectMake(205, 100, 150, 40));
        copyButton.title = "Copy MarkDown URL";
        copyButton.target = self;
        copyButton.action = #selector(ViewController.onClickCopyButton(Sender:));
        self.view.addSubview(copyButton);
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func dragFile(FilePath file: NSString) {
        self.uploadFile(file);
        
    }
    
    func updatePasteImageBtnAction(sender : NSButton) {
        let pasteBoard = NSPasteboard.generalPasteboard();
        let images = pasteBoard.readObjectsForClasses([NSImage.self], options: nil) as! [NSImage]
        if let image = images.first {
            let fileManager = NSFileManager.defaultManager();
            let urls = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
            let identifier = NSBundle.mainBundle().bundleIdentifier
            let cacheFile = urls[0].URLByAppendingPathComponent(identifier!)
            
            do {
                try fileManager.createDirectoryAtURL(cacheFile, withIntermediateDirectories: true, attributes: [:])
                let tmpImageName = NSString.localizedStringWithFormat("%ld.jpg", NSDate.timeIntervalSinceReferenceDate())
                let filePath = cacheFile.URLByAppendingPathComponent(tmpImageName as String)

                let imageData = image.JPEGRepresentationWithCompressionFactor(0.8)
                imageData.writeToFile(filePath.path!, atomically: true)
                self.uploadFile(filePath.path);
            } catch let error as NSError {
                print(error);
            }
        } else {
            let alert = NSAlert.init();
            alert.messageText =  "警告"
            alert.informativeText = "你并没有截屏，请截屏后再试。\n（默认快捷键是 cmd+shift+4 ）"
            alert.runModal()
        }
    }
    
    func onClickCopyButton(Sender btn : NSButton) {
        let url = textField.stringValue;
        if url.isEmpty {
            btn.enabled = false;
            return;
        }
        let pasteBoard = NSPasteboard.generalPasteboard();
        pasteBoard.clearContents();
        
        let fileName = NSURL.init(string: url)?.lastPathComponent;
        pasteBoard.writeObjects(["![".stringByAppendingString(fileName!).stringByAppendingString("](").stringByAppendingString(url).stringByAppendingString(")")]);
    }
    
    func uploadFile(file: NSString?) {
        textField.stringValue = ""
        textField.placeholderString = "文件上传中..."
        copyButton.enabled = false
        self.uploadManager.qiniuUpload(file, Name: file?.lastPathComponent) { (url) in
            print("上传成功，外链地址是：", url)
            self.textField.stringValue = url as! String
            let pasteBoard = NSPasteboard.generalPasteboard()
            pasteBoard.clearContents()
            pasteBoard.writeObjects([url!])
            self.copyButton.enabled = true
        }
    }

}

