//
//  RunTime.m
//  RunTime
//
//  Created by fanxiaobin on 2017/3/29.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "RunTime.h"

@implementation RunTime

- (NSString *)obtainName{
    return _name;
}

- (void)setName:(NSString *)name age:(NSString *)age{
    _name = name;
    _age = age;
}

@end
