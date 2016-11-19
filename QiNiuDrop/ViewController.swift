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

        let dragView = DragDropView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height));
        dragView.dragProtocol = self;
        self.view.addSubview(dragView);
        
        updatePasteImageBtn = NSButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 80));
        updatePasteImageBtn.title = "上传剪切板图片到七牛";
        updatePasteImageBtn.target = self;
        updatePasteImageBtn.action = #selector(ViewController.updatePasteImageBtnAction(_:));
        self.view.addSubview(updatePasteImageBtn)
        
        textField = NSTextField.init(frame: CGRect(x: 0, y: 80, width: 200, height: 80))
        textField.textColor = NSColor.black
        textField.placeholderString = "图片最终的外链地址"
        textField.isEnabled = false
        self.view.addSubview(textField)
        
        copyButton = NSButton.init(frame: CGRect(x: 205, y: 100, width: 150, height: 40));
        copyButton.title = "Copy MarkDown URL";
        copyButton.target = self;
        copyButton.action = #selector(ViewController.onClickCopyButton(Sender:));
        self.view.addSubview(copyButton);
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func dragFile(FilePath file: NSString) {
        self.uploadFile(file);
        
    }
    
    func updatePasteImageBtnAction(_ sender : NSButton) {
        let pasteBoard = NSPasteboard.general();
        let images = pasteBoard.readObjects(forClasses: [NSImage.self], options: nil) as! [NSImage]
        if let image = images.first {
            let fileManager = FileManager.default;
            let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            let identifier = Bundle.main.bundleIdentifier
            let cacheFile = urls[0].appendingPathComponent(identifier!)
            
            do {
                try fileManager.createDirectory(at: cacheFile, withIntermediateDirectories: true, attributes: [:])
                let tmpImageName = String(Int(Date.init().timeIntervalSince1970)) + ".jpg"
                let filePath = cacheFile.appendingPathComponent(tmpImageName as String)

                let imageData = image.JPEGRepresentationWithCompressionFactor(0.8)
                try? imageData.write(to: URL(fileURLWithPath: filePath.path), options: [.atomic])
                self.uploadFile(filePath.path as NSString?);
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
            btn.isEnabled = false;
            return;
        }
        let pasteBoard = NSPasteboard.general();
        pasteBoard.clearContents();
        
        let fileName = URL.init(string: url)?.lastPathComponent;
        pasteBoard.writeObjects([((("![" + fileName!) + "](") + url) + ")" as NSPasteboardWriting]);
    }
    
    func uploadFile(_ file: NSString?) {
        textField.stringValue = ""
        textField.placeholderString = "文件上传中..."
        copyButton.isEnabled = false
        self.uploadManager.qiniuUpload(file, Name: file?.lastPathComponent as NSString?) { (url) in
            print("上传成功，外链地址是：", url)
            self.textField.stringValue = url as! String
            let pasteBoard = NSPasteboard.general()
            pasteBoard.clearContents()
            pasteBoard.writeObjects([url])
            self.copyButton.isEnabled = true
        }
    }

}

