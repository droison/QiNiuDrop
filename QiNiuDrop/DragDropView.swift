//
//  DragDropView.swift
//  QiNiuDrop
//
//  Created by song on 16/6/27.
//  Copyright © 2016年 song. All rights reserved.
//

import Cocoa


protocol DragDropViewProtocol {
    func dragFile(FilePath file: NSString)
}

class DragDropView: NSView {
    
    var dragProtocol: DragDropViewProtocol?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.registerForDraggedTypes([NSFilenamesPboardType]);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        let pboard = sender.draggingPasteboard();
        if pboard.types!.contains(NSFilenamesPboardType) {
            return .Copy;
        }
        return .None
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        let zPasteboard = sender.draggingPasteboard();
        let list = zPasteboard.propertyListForType(NSFilenamesPboardType) as! NSArray;
        if list.count > 0 {
            let firstFile = list.firstObject as! NSString;
            NSLog(">>> 暂时我们只支持第一个文件上传到七牛:%@", firstFile)
            if dragProtocol != nil {
                dragProtocol?.dragFile(FilePath: firstFile);
            }
        }
        
        return true;
    }
    
}
