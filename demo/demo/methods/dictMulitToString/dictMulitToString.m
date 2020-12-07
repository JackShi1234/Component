//
//  dictMulitToString.m
//  demo
//
//  Created by 张小二 on 2020/12/7.
//

#import "dictMulitToString.h"

@implementation dictMulitToString

+(void)enumerateKeysAndObjectsUsingBlock:(NSDictionary*)dic block:(void (^)(id key, id obj))block{
    NSArray *allKey = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    for (int i=0;i<allKey.count;i++) {
        id obj = dic[allKey[i]];
        id key = allKey[i];
        block(key,obj);
    }
}

+ (NSString*)handleDic:(NSDictionary*)data
{

    NSMutableString *resultStr = [[NSMutableString alloc]initWithCapacity:0];
    //获取排好序的字典 blcok 返回key和Value
    [[self class] enumerateKeysAndObjectsUsingBlock:data block:^(id key, id obj) {

       //根据类型判断 针对每种类型处理
        if ([obj isKindOfClass:[NSDictionary class]]) { //  是字典对象

            obj = [[self class] handleDic:obj];
            //组装字典
            obj = [NSString stringWithFormat:@"{%@}",[[NSString stringWithFormat:@"%@",obj] substringToIndex:[NSString stringWithFormat:@"%@",obj].length-1]];

        }
        if ([obj isKindOfClass:[NSArray class]]) {//  是数组对象
            NSMutableString *resobj = [NSMutableString new];
            for (NSDictionary *dict in obj) {
                obj =  [[self class] handleDic:dict];
                //组装每一个字典
                  [resobj appendFormat:@"%@,",[NSString stringWithFormat:@"{%@}",obj]];
            }
            //给数组拼接中括号
            obj= [NSString stringWithFormat:@"[%@]",[resobj substringToIndex:resobj.length-1]];
        }
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {//字符串数字类型
            //拼接字符串和数字类型
            [resultStr appendFormat:@"%@=%@&",key,obj];
        }
    }];
    return [resultStr substringToIndex:resultStr.length-1];
}

@end
