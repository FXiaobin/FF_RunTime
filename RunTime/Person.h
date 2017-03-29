//
//  Person.h
//  RunTime
//
//  Created by fanxiaobin on 2017/3/29.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///运行时归档解档
@interface Person : NSObject<NSCoding>

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *level;
@property (nonatomic,strong) NSNumber *age;
@property (nonatomic,strong) NSNumber *height;

@property (nonatomic,readonly) NSString *info;


- (void)study:(NSString *)subject;

@end
