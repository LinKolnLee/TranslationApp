//
//  TranslationManager.m
//  TranslationApp
//
//  Created by llk on 2018/6/26.
//  Copyright © 2018年 Beauty. All rights reserved.
//

#import "TranslationManager.h"
#import "AFNetworking.h"

@implementation TranslationManager
#pragma mark //网络请求翻译
+(void)translationWord:(NSString *)word type:(NSString *)type success:(void (^)(NSString * result))success{
    NSString *content = word;
    
    /** 翻译规则 */
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"." withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"。" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"?" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"？" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@";" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"；" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"、" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"!" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"！" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"_" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"—" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"-" withString:@","];
    content = [content stringByReplacingOccurrencesOfString:@"+" withString:@","];
    
    /** Post网络请求 */
    NSDictionary *params = @{@"i":content,@"doctype":@"json",@"type":type};
    [self requestForParmars:params success:^(NSString *result) {
        success(result);
    }];
}
+(void)requestForParmars:(NSDictionary *)params success:(void (^)(NSString * result))success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://fanyi.youdao.com/translate" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = [[NSArray alloc]initWithArray:responseObject[@"translateResult"]];
        NSString * result = [[array firstObject] firstObject][@"tgt"];
        success(result);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}



@end
