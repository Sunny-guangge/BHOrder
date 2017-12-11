//
//  BHAppHttpClient.h
//  httprequest
//
//  Created by 王帅广 on 2016/11/26.
//  Copyright © 2016年 王帅广. All rights reserved.
//

#import "AFHTTPSessionManager.h"

//(^)(NSProgress *downloadProgress)) downloadProgress

@class BHResponse;
@interface BHAppHttpClient : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@property (nonatomic,assign) AFNetworkReachabilityStatus status;

/**
 封装的GET请求

 @param path 路径
 @param parameters 参数
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)requestGETWithPath:(NSString *)path
                parameters:(NSMutableDictionary *)parameters
                   success:(void(^)(BHResponse *response))success
                     error:(void(^)(NSError *error))failure;

/**
 封装的POST请求
 
 @param path 路径
 @param parameters 参数
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)requestPOSTWithPath:(NSString *)path
                parameters:(NSMutableDictionary *)parameters
                   success:(void(^)(BHResponse *response))success
                     error:(void(^)(NSError *error))failure;


- (void)requestPOSTWithPath:(NSString *)path
                 parameters:(NSMutableDictionary *)parameters
                     header:(NSString *)header
                    success:(void(^)(BHResponse *response))success
                      error:(void(^)(NSError *error))failure;

/**
 封装的PUT请求
 
 @param path 路径
 @param parameters 参数
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)requestPUTWithPath:(NSString *)path
                 parameters:(NSMutableDictionary *)parameters
                  formData:(NSString *)data
                    success:(void(^)(BHResponse *response))success
                      error:(void(^)(NSError *error))failure;

/**
 封装的POST请求
 
 @param path 路径
 @param parameters 参数
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)requestPOSTWithPath:(NSString *)path
                parameters:(NSMutableDictionary *)parameters
                  formData:(NSString *)data
                   success:(void(^)(BHResponse *response))success
                     error:(void(^)(NSError *error))failure;



- (void)uploadImagesWithPath:(NSString *)path
                  parameters:(NSMutableDictionary *)parameters
                      images:(NSArray *)file
                     success:(void(^)(BHResponse *response))success
                       error:(void(^)(NSError *error))failure;


- (void)uploadImagesAFWithPath:(NSString *)path
                  parameters:(NSMutableDictionary *)parameters
                      images:(NSArray *)file
                      progress:(void(^)(NSProgress *))progress
                     success:(void(^)(BHResponse *response))success
                       error:(void(^)(NSError *error))failure;

- (void)cancelAllRequest;

@end
