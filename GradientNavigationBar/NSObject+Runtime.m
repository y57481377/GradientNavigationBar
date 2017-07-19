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
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        Method method = list[i];
        
        SEL name = method_getName(method);
        unsigned int params = method_getNumberOfArguments(method);
        char type;
        size_t len = 0;
        method_getReturnType(method, &type, len);
        const char *name_c = sel_getName(name);
        
        NSString *str = [NSString stringWithFormat:@"Method-%s,----*****---%d,\\n编码--%c\\n", name_c, params, type];
        [muArr addObject:str];
    }
    
    free(list);
    
    return muArr;
}

- (NSArray *)getAllProperties
{
    unsigned int count;
    //获取属性的链表
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
@end
