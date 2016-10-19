//
//  BHBaseModel.m
//  BlogDemo
//
//  Created by HanBin on 16/5/14.
//  Copyright © 2016年 BinHan. All rights reserved.
//

@interface BHBaseModel()

@property (nonatomic, copy) NSString *name;

@end

@implementation BHBaseModel


- (NSString *)description
{
    id modelClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:outCount];
    //遍历出所有的属性key/value
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [[self valueForKey:propName] description];
        [dict setObject:value forKey:propName];
    }
    return [NSString stringWithFormat:@"<%@: %p> %@", NSStringFromClass([self class]), self, dict];
}

-(NSString *)debugDescription
{
    return [self description];
}

@end
