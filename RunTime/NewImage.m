//
//  NewImage.m
//  RunTime
//
//  Created by fanxiaobin on 2017/3/29.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "NewImage.h"

@implementation NewImage

// 重写父类方法:想给系统的方法添加额外功能
+ (UIImage *)imageNamed:(NSString *)name
{
    // 真正加载图片：调用super初始化一张图片
    UIImage *image = [super imageNamed:name];
    
    if (image) {
        NSLog(@"加载成功");
    } else {
        NSLog(@"加载失败");
    }
    
    return image;
    
}

@end
