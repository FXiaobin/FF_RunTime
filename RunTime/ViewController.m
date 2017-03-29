//
//  ViewController.m
//  RunTime
//
//  Created by fanxiaobin on 2017/3/29.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>
#import "RunTime.h"
#import "Person.h"
#import "NewImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ///参考资料: http://www.jianshu.com/p/d361f169423b   http://blog.csdn.net/meegomeego/article/details/18356169
    
    
    //[self exchangeMothodImp];
    
   //[self addProperty];
    
    //[self addMethod];
    
    //[self achiverCustomObject];
    
}

#pragma mark --  1. 获取其成员变量
- (void)emMemberIvarListWithClass:(Class)cls p:(Person *)p{
    
    unsigned int outCount = 0;
    Ivar * ivars = class_copyIvarList(cls, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:name];
        const char * type = ivar_getTypeEncoding(ivar);
        id value = object_getIvar(p,ivar);
        NSLog(@"类型为 %s 的 %@, value = %@ ",type, ivarName, value);
    }
    free(ivars);
}

#pragma mark -- 2. 获取属性列表
- (void)emPropertyListWithClass:(Class)cls{
    
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(cls, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i ++) {
        objc_property_t property = properties[i];
        //属性名
        const char * name = property_getName(property);
        NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        NSLog(@"--- 属性描述为 %@ ---", propertyName);
        //属性描述
        //const char * propertyAttr = property_getAttributes(property);
        //NSLog(@"属性描述为 %s 的 %s ", propertyAttr, name);
        
        //属性的特性
        unsigned int attrCount = 0;
        objc_property_attribute_t * attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int j = 0; j < attrCount; j ++) {
            objc_property_attribute_t attr = attrs[j];
            const char * name = attr.name;
            const char * value = attr.value;
            NSLog(@"属性的描述：name = %s , value = %s", name, value);
        }
        free(attrs);
        NSLog(@"\n");
    }
    free(properties);
}


#pragma mark --  3. 获取某个类方法列表
- (void)emMethodListWithClass:(Class)cls{
   
    unsigned int methodCount = 0;
    Method * methods = class_copyMethodList(cls, &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        Method m = methods[i];
        SEL  name = method_getName(m);
        NSString *mName = NSStringFromSelector(name);
        const char * type = method_getTypeEncoding(m);
        NSLog(@"+++++++ 类型为 %s 的 %@ 方法",type, mName);
    }
    free(methods);
}


#pragma mark --  4. runTime 归档解档自定义类的对象
- (void)achiverCustomObject{
    
    Person *p = [[Person alloc] init];
    p.name = @"xiaoMing";
    p.level = @"university student";
    p.age = @24;
    p.height = @180;
    NSData *ach = [NSKeyedArchiver archivedDataWithRootObject: p];
    [[NSUserDefaults standardUserDefaults] setObject:ach forKey:@"archiver"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"archiver"];
    Person *per = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //[self emPropertyListWithClass:[per class]];
    
    [self emMemberIvarListWithClass:[per class] p:per];
    
    
}

#pragma mark --  5. 修改只读属性值
- (void)modifyReadOnlyPropertyValue{
    
    Person *per = [[Person alloc] init];
    per.name = @"xiaoMing";
    per.level = @"university student";
    per.age = @24;
    per.height = @180;
    
    NSLog(@"---- 修改前 info= %@",per.info);
    
    NSString *modifyDes = @"modify personal des intro";
    //per.info = modifyDes;  //只读属性不可直接赋值
    
    ///1.运行时修改只读属性值
    //ivar是成员变量不是属性 成员变量和属性的区别就是成员变量以下划线开头 属性没有下划线
    Ivar ivar = class_getInstanceVariable([Person class], "_info");
    NSString *infoStr = [NSString stringWithUTF8String:ivar_getName(ivar)];
    NSLog(@"----成员变量ivar名称: %@",infoStr);
    object_setIvar(per, ivar, modifyDes);
    NSString *info = [per valueForKey:@"info"];
    NSLog(@"---- runTime modify info = %@",info);
    
    ///2.KVC修改只读属性值
    [per setValue:@"KVC modify info!!!" forKey:@"info"];
   
    NSLog(@"---- KVC modify info = %@",per.info);
    
    
}

#pragma mark --  6. 交换方法实现
- (void)exchangeMothodImp{
    ///重写+(void)load方法
    ///使用类别(UIImage+Exchange)来交换某个类的某个方法的实现过程 这里是将系统的imageNamed:的现实替换成xmg_imageNamed:
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    UIImage *image = [UIImage imageNamed:@"placeholder_image@2x.jpg"];
    //UIImage *image = [NewImage imageNamed:@"placeholder_image@2x.jpg"];
    imageView.image = image;
    [self.view addSubview:imageView];
    
}

#pragma mark --  7. 添加属性
- (void)addProperty{
    
    Person *person = [[Person alloc] init];
    
    objc_setAssociatedObject(person, @"addKey", @"i was a add value", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    id value = objc_getAssociatedObject(person, @"addKey");
    
    NSLog(@"--- add value = %@",value);
}


#pragma mark --  8.添加方法
/*
 // 参数解释:
 // Class;给哪个类添加方法
 // SEL:添加方法
 // IMP:方法实现,函数名
 // types:方法类型(不要去死记,官方文档中有)
 class_addMethod(__unsafe_unretained Class cls, SEL name, IMP imp, const char *types)
 */
- (void)addMethod{
    
    Person *person = [[Person alloc] init];
    
    class_addMethod([Person class], @selector(giveYouAName), (IMP)giveYouAName, "v@:");
    
    [person performSelector:@selector(giveYouAName)];
}

///id self, SEL _cmd 这两个隐藏的参数不能少
void giveYouAName(id self, SEL _cmd) {
    NSLog(@"--- add method ----");
}

#pragma mark --  9. 发送消息
- (void)sendMessage{
    
    /*
     报错问题解决:
     
     Too many arguments to function call, expected 0, have 3
     
     经过几番周折，终于叨叨解决方案了
     
     选中项目 - Project - Build Settings - ENABLE_STRICT_OBJC_MSGSEND  将其设置为 NO 即可
     */
    Person *person = [[Person alloc] init];
    objc_msgSend(person,@selector(study:), @"Math");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
