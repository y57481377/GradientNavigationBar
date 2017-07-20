//
//  NSDictionary+Log.m
//  pickerView
//
//  Created by Yang on 16/7/25.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"\n{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"\t%@",key];
        [string appendFormat:@" : "];
        [string appendFormat:@"%@,\n",obj];
    }];

    [string appendString:@"}\n"];
    //删除最后的逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {   /* range.location != NSNotFound  */
        [string deleteCharactersInRange:range];
    }
    return string;
}

@end


@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"[\n"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@,\n",obj];
    }];
    
    [string appendString:@"]"];
    
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {   /* range.location != NSNotFound  */
        [string deleteCharactersInRange:range];
    }
    return string;
}

@end
