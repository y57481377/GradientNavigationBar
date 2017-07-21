//
//  NSObject+Runtime.m
//  GradientNavigationBar
//
//  Created by YANG on 2017/7/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>
@implementation NSObject (Runtime)

- (NSArray *)getAllMethods {
    unsigned int count = 0;
    Method *list = class_copyMethodList([self class], &count);
    
    NSMutableArray *methodArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        Method method = list[i];
        
        SEL name = method_getName(method);
        unsigned int params = method_getNumberOfArguments(method);
        const char *encode = method_getTypeEncoding(method);
        const char *name_c = sel_getName(name);
        
        NSString *str = [NSString stringWithFormat:@"方法名：%s, 参数个数:%d, 参数类型: %s", name_c, params, encode];
        [methodArray addObject:str];
    }
    free(list);
    return methodArray;
}

- (NSArray *)getAllProperties
{
    unsigned int count = 0;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        const char* propertyName =property_getName(property);
        [propertiesArray addObject: [NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return propertiesArray;
}

- (NSArray *)getAllIvars {
    
    unsigned int count = 0;

    NSMutableArray *ivarArray = [NSMutableArray array];
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i< count; i++) {
        Ivar ivar = ivars[i];
        
        const char *name = ivar_getName(ivar);
        const char *encode = ivar_getTypeEncoding(ivar);
        NSString *str = [NSString stringWithFormat:@"%s, %s", name, encode];
        
        [ivarArray addObject:str];
    }
    free(ivars);
    return ivarArray;
}
@end
