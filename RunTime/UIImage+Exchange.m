//
//  UIImage+Exchange.m
//  RunTime
//
//  Created by fanxiaobin on 2017/3/29.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "UIImage+Exchange.h"
#import <objc/message.h>

@implementation UIImage (Exchange)

//+ (void)load
//{
//    // self -> UIImage
//    // 获取imageNamed
//    // 获取哪个类的方法
//    // SEL:获取哪个方法
//    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
//    // 获取xmg_imageNamed
//    Method xmg_imageNamedMethod = class_getClassMethod(self, @selector(xmg_imageNamed:));
//    
//    // 交互方法:runtime
//    method_exchangeImplementations(imageNamedMethod, xmg_imageNamedMethod);
//    // 调用imageNamed => xmg_imageNamedMethod
//    // 调用xmg_imageNamedMethod => imageNamed
//}

// 1.加载图片
// 2.判断是否加载成功
+ (UIImage *)xmg_imageNamed:(NSString *)name
{
    // 图片
    UIImage *image = [UIImage xmg_imageNamed:name];
    
    if (image) {
        NSLog(@"加载成功");
    } else {
        NSLog(@"加载失败");
    }
    
    return image;
}





@end
