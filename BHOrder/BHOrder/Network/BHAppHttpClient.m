//
//  BHAppHttpClient.m
//  httprequest
//
//  Created by 王帅广 on 2016/11/26.
//  Copyright © 2016年 王帅广. All rights reserved.
//

#import "BHAppHttpClient.h"
#import "AppDelegate.h"
#import "BHResponse.h"
#import "BHUser.h"

@interface BHAppHttpClient ()

@property (nonatomic, strong) NSMutableArray *tasksArray;

@end

@implementation BHAppHttpClient

{
    NSInteger errorNum;
    
}

+ (instancetype)sharedInstance {
    static BHAppHttpClient *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[BHAppHttpClient alloc] init];
        sharedInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
        sharedInstance.requestSerializer.timeoutInterval = 20;
        sharedInstance.responseSerializer = [AFHTTPResponseSerializer serializer];
        sharedInstance.operationQueue.maxConcurrentOperationCount = 10;
        [sharedInstance.requestSerializer setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
        [sharedInstance.requestSerializer setValue:@"Mobile" forHTTPHeaderField:@"markVal"];
        [sharedInstance.requestSerializer setValue:@"app" forHTTPHeaderField:@"type"];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
        securityPolicy.validatesDomainName = NO;
        sharedInstance.securityPolicy  = securityPolicy;
        
        sharedInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", @"image/jpeg", @"image/png",@"application/octet-stream",nil];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            sharedInstance.status = status;
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    break;
                }
                default:
                    break;
            }
        }];
        
    });
    
    return sharedInstance;
}

- (void)requestGETWithPath:(NSString *)path
                parameters:(NSMutableDictionary *)parameters
                   success:(void(^)(BHResponse *response))success
                     error:(void(^)(NSError *error))failure
{
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    
#ifdef DEBUG
    [self logWithPath:path paramter:parameters];
#else
    
#endif
    if ([BHUser currentUser].token) {
         [self.requestSerializer setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
    }
    [self GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        errorNum = 0;
        
        BHResponse *response = [BHResponse mj_objectWithKeyValues:responseObject];
        
        /*token 登录*/
        if ([response.code isEqualToString:@"10010"]) {
            [BHUser showOtherLogin];
            return ;
        }
        if (success) {
            success(response);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

- (void)requestPOSTWithPath:(NSString *)path
                 parameters:(NSMutableDictionary *)parameters
                    success:(void(^)(BHResponse *response))success
                      error:(void(^)(NSError *error))failure
{
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
#ifdef DEBUG
    [self logWithPath:path paramter:parameters];
#else
    
#endif
    if ([parameters objectForKey:@"openid"]) {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"openid"];
    }
    if ([BHUser currentUser].token) {
        [self.requestSerializer setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
    }
    NSURLSessionDataTask *task = [self POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        errorNum = 0;
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        BHResponse *response = [BHResponse mj_objectWithKeyValues:dict];
        /*token 登录*/
        if ([response.code isEqualToString:@"10010"]) {
            [BHUser showOtherLogin];
            return ;
        }
        
        if (success) {
            success(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    [[BHAppHttpClient sharedInstance].tasksArray addObject:task];
}

- (void)requestPOSTWithPath:(NSString *)path
                 parameters:(NSMutableDictionary *)parameters
                     header:(NSString *)header
                    success:(void(^)(BHResponse *response))success
                      error:(void(^)(NSError *error))failure{
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
#ifdef DEBUG
    [self logWithPath:path paramter:parameters];
#else
    
#endif
    [self.requestSerializer setValue:header forHTTPHeaderField:@"openid"];
    if ([BHUser currentUser].token) {
        [self.requestSerializer setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
    }
    NSURLSessionDataTask *task = [self POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        errorNum = 0;
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        BHResponse *response = [BHResponse mj_objectWithKeyValues:dict];
        /*token 登录*/
        if ([response.code isEqualToString:@"10010"]) {
            [BHUser showOtherLogin];
            return ;
        }
        
        if (success) {
            success(response);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    [[BHAppHttpClient sharedInstance].tasksArray addObject:task];
}

- (void)requestPUTWithPath:(NSString *)path
                parameters:(NSMutableDictionary *)parameters
                  formData:(NSString *)data
                   success:(void(^)(BHResponse *response))success
                     error:(void(^)(NSError *error))failure
{
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    if ([BHUser currentUser].token) {
        [self.requestSerializer setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
    }
    NSString *path1;
    path1 = [NSString stringWithFormat:@"%@?token=%@",path,@""];
    
#ifdef DEBUG
    [self logWithPath:path1 paramter:parameters];
#else
    
#endif
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFHTTPResponseSerializer *responseSer = [[AFHTTPResponseSerializer alloc] init];
    responseSer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.responseSerializer = responseSer;
    
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:path1 parameters:nil error:nil];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"Mobile" forHTTPHeaderField:@"markVal"];
//    if (account.token) {
//        [req setValue:account.token forHTTPHeaderField:@"token"];
//    }else{
        [req setValue:@"" forHTTPHeaderField:@"token"];
//    }
    [req setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YESf
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            errorNum = 0;
            BHResponse *response1 = [BHResponse mj_objectWithKeyValues:responseObject];
            
//            if (account.token && ([response1.resultCode isEqualToString:@"10010"] || [response1.resultCode isEqualToString:@"10011"])) {
//                
//                [self jumpToLoginVC];
//                
//                BHAccount *account = [BHAccountTool account];
//                
//                if (account.token) {
//                    
//                    NSString *reason = (!response1.reason || [response1.reason isEmptyString]) ? @"您的登录信息已失效，请重新登录" : response1.reason;
//                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                    
//                    //退出登录了 需要跳出页面  弹出登录页面
//                    [BHUser logout];
//                }
//            }else{
                if (success) {
                    success(response1);
                }
//            }
            
        } else {
            
//            if (self.status != AFNetworkReachabilityStatusNotReachable) {
//                errorNum +=1;
//                if (errorNum == 5) {
//                    [self jumpToErrorVC];
//                }
//            }
            
            if (failure) {
                failure(error);
            }
        }
    }] resume];
}


- (void)requestPOSTWithPath:(NSString *)path
                 parameters:(NSMutableDictionary *)parameters
                   formData:(NSString *)data
                    success:(void(^)(BHResponse *response))success
                      error:(void(^)(NSError *error))failure
{
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    
    NSString *path1;
    
#ifdef DEBUG
    [self logWithPath:path1 paramter:parameters];
#else
    
#endif
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFHTTPResponseSerializer *responseSer = [[AFHTTPResponseSerializer alloc] init];
    responseSer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.responseSerializer = responseSer;
    
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:nil error:nil];
    
    [req setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"Mobile" forHTTPHeaderField:@"markVal"];
    [req setValue:@"app" forHTTPHeaderField:@"type"];
    if ([BHUser currentUser].token) {
        [req setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
    }
    [req setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YESf
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            errorNum = 0;
            BHResponse *response1 = [BHResponse mj_objectWithKeyValues:responseObject];
            
                if (success) {
                    success(response1);
                }
    
        } else {
            
            if (failure) {
                failure(error);
            }
        }
    }] resume];
}

- (void)jumpToErrorVC
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器当前连接异常，请检查您的网络是否正常后再次进行连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
}  

- (void)uploadImagesWithPath:(NSString *)path
                  parameters:(NSMutableDictionary *)parameters
                      images:(NSArray *)file
                     success:(void(^)(BHResponse *response))success
                       error:(void(^)(NSError *error))failure
{
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
#ifdef DEBUG
    [self logWithPath:path paramter:parameters];
#else
    
#endif
    if ([BHUser currentUser].token) {
        [self.requestSerializer setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
        [self.requestSerializer setValue:@"app" forHTTPHeaderField:@"type"];
    }
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    NSMutableString *body=[[NSMutableString alloc]init];
    NSArray *keys= [parameters allKeys];
    for(int i=0;i<[keys count];i++) {
        NSString *key = [keys objectAtIndex:i];
        [body appendFormat:@"%@\r\n",MPboundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
    }
    
    NSMutableData *myRequestData=[NSMutableData data];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (UIImage *image in file) {
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
        
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fileName];
        [imgbody appendFormat:@"Content-Type: audio/x-caf; charset=utf-8\r\n\r\n"];
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:data];
        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //手机标示
    [request setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mobile" forHTTPHeaderField:@"markVal"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
    [request setValue:@"app" forHTTPHeaderField:@"type"];
    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
        
        if (data) {
            BHResponse *response = [BHResponse mj_objectWithKeyValues:data];
            /*token 登录*/
            if ([response.code isEqualToString:@"10010"]) {
                [BHUser showOtherLogin];
                return ;
            }
            if (success) {
                success(response);
            }
        }
        
        if (error) {
            if (failure) {
                failure(error);
            }
        }
    });
}

- (void)uploadImagesAFWithPath:(NSString *)path
                    parameters:(NSMutableDictionary *)parameters
                        images:(NSArray *)file
                      progress:(void(^)(NSProgress *))progress
                       success:(void(^)(BHResponse *response))success
                         error:(void(^)(NSError *error))failure{
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
#ifdef DEBUG
    [self logWithPath:path paramter:parameters];
#else
    
#endif
    if ([BHUser currentUser].token) {
        [self.requestSerializer setValue:[BHUser currentUser].token forHTTPHeaderField:@"token"];
    }
    
    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < file.count; i++) {
            
            UIImage *image = file[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"MultipartFile" fileName:fileName mimeType:@"image/jpg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BHResponse *response = [BHResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(response);
            }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)logWithPath:(NSString *)path paramter:(NSMutableDictionary *)paramter{
    
    NSString *logStr = [NSString stringWithFormat:@"%@?",path];
    
    for (NSInteger i=0; i<paramter.allKeys.count; i++) {
        if (i == paramter.allKeys.count - 1) {
            NSString *keyvalue = [NSString stringWithFormat:@"%@=%@",paramter.allKeys[i],paramter.allValues[i]];
            logStr = [NSString stringWithFormat:@"%@%@",logStr,keyvalue];
        }else{
            NSString *keyvalue = [NSString stringWithFormat:@"%@=%@",paramter.allKeys[i],paramter.allValues[i]];
            logStr = [NSString stringWithFormat:@"%@%@&",logStr,keyvalue];
        }
    }
    NSLog(@"%@",logStr);
}

- (NSMutableArray *)tasksArray {
    if (!_tasksArray) {
        _tasksArray = [[NSMutableArray alloc] init];
    }
    
    return _tasksArray;
}

- (void)cancelAllRequest {
    [[BHAppHttpClient sharedInstance].tasksArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask *taskObj, NSUInteger idx, BOOL * _Nonnull stop) {
        [taskObj cancel];
    }];
    [[BHAppHttpClient sharedInstance].tasksArray removeAllObjects];
}

@end
