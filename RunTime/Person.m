//
//  Person.m
//  RunTime
//
//  Created by fanxiaobin on 2017/3/29.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>



@implementation Person

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        unsigned int outCount;
        Ivar * ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (void)study:(NSString *)subject{
    NSLog(@"learnig %@ hardwork!!!",subject);
}

@end
