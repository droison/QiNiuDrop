//
//  NSImageExt.swift
//  QiNiuDrop
//
//  Created by song on 16/6/27.
//  Copyright © 2016年 song. All rights reserved.
//

import Cocoa

extension NSImage {

    private func opaqueBitmapImageRep() -> NSBitmapImageRep {
        var imageRep : NSBitmapImageRep! = nil
        let tempImage = NSImage.init(size: size)
        tempImage.lockFocus()
        
        NSColor.whiteColor().set()
        NSRectFill(NSMakeRect(0, 0, size.width, size.height));
        drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation: .CompositeCopy, fraction: 1.0)
        
        tempImage.unlockFocus()
        
        
        
        for rep in tempImage.representations {
            if rep.isKindOfClass(NSBitmapImageRep.self) {
                imageRep = rep as! NSBitmapImageRep;
            }
        }
        
        if imageRep == nil {
            imageRep = NSBitmapImageRep.imageRepsWithData(tempImage.TIFFRepresentation!)[0] as! NSBitmapImageRep
        }
        
        // 10.6 behavior: Drawing into a new image copies the display's color profile in.
        // Remove the color profile so we don't bloat the image size.
        
        imageRep.setProperty(NSImageColorSyncProfileData, withValue: nil)
        
        return imageRep;
    }
    
    func JPEGRepresentationWithCompressionFactor(compressionFactor : Float) -> NSData {
        return opaqueBitmapImageRep().representationUsingType(.NSJPEGFileType, properties: [NSImageCompressionFactor : compressionFactor])!
    }
}
