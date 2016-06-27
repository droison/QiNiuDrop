//
//  GenToken.h
//  QiNiuDrop
//
//  Created by song on 16/6/27.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenToken : NSObject
+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey bucket:(NSString*) bucket;
@end
