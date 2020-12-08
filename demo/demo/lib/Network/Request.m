//
//  Request.m
//  demo
//
//  Created by 张小二 on 2020/12/8.
//

#import "Request.h"

@implementation Request
/* 使用digest原理实现流程
-(void)getRequest{
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//以GET请求为例，以下方法为封装的配置方法
    [self setHttpHeaderDigestURI:identifier requestType:RequestType_GET nonce:self.nonceStr];
NSURLSession *session = [NSURLSession sharedSession];
//发送请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * pFieldd =[(NSHTTPURLResponse*)response allHeaderFields];
        NSInteger statusCode =[(NSHTTPURLResponse*)response statusCode];
        if (statusCode == 401) {//digest auth
            NSString * strAuthenticate = [pFieldd valueForKey:@"Www-Authenticate"];
            if ([strAuthenticate containsString:@"nonce="]) {
                NSArray *arr = [strAuthenticate componentsSeparatedByString:@"nonce="];
                NSArray *newArr = [[arr lastObject] componentsSeparatedByString:@","];
                NSMutableString *newStr = [NSMutableString stringWithString:[newArr firstObject]] ;
                if (newStr.length >= 3) {
                    [newStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
                    [newStr replaceCharactersInRange:NSMakeRange(newStr.length - 1, 1) withString:@""];
                }
                NSString *nonce = newStr ;
                weakself.nonceStr = nonce;
                weakself.count += 1;
                if (weakself.count > 3) {
                    weakself.count = 0;
                    [weakself error:error finishedBlock:finishedBlock];
                }else{
                    [weakself sendGetRequestWithParams:params getValues:values resultType:type finishedBlock:finishedBlock];
                }
            }else{
                [weakself error:error finishedBlock:finishedBlock];
            }
        }else{
            NSError *error;
            NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if (finishedBlock) {
                    finishedBlock(CODE_JSON_OK,responseObject);
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
            }else{
                if (finishedBlock) {
                    if (responseObject != nil) {
                        finishedBlock(CODE_ERROR_JSON, responseObject);
                    }else{
                        finishedBlock(CODE_ERROR_JSON, @"responseObject为nil");
                    }
                }
            }
        }
    }];
    //执行任务
    [dataTask resume];
    }

//配置请求的header
-(void)setHttpHeaderDigestURI:(NSString *)digestURI requestType:(RequestType)requestType nonce:(NSString *)nonce{
NSString *username = @"ApiAdmin";
NSString *password = @"xxx";
NSString *realm = @"xxx.com";
NSString *method ;
switch (requestType) {
    case RequestType_POST:{
        method = @"POST";
    }
        break;
    case RequestType_GET:{
        method = @"GET";
    }
        break;
    case RequestType_PUT:{
        method = @"PUT";
    }
        break;
    case RequestType_DELETE:{
        method = @"DELETE";
    }
        break;
    default:
        break;
}
//修改请求方法
self.request.HTTPMethod = method;
//此字符串可任意
nonce = @"9e6146023a70bdb0b4d1da795a029990";
if (nonce.length > 0) {
    nonce = self.nonceStr;
    self.nonceStr = nil;
}
//这里是SHA256加密如果你是MD5或者其他的可自由切换
NSString *HA1 = [[NSString stringWithFormat:@"%@:%@:%@",username,realm,password] SHA256];
NSString *HA2 = [[NSString stringWithFormat:@"%@:%@",method,digestURI] SHA256];
NSString *sha265 = [NSString stringWithFormat:@"%@:%@:%@",HA1,nonce,HA2];
NSString *algorithm = @"SHA-256";
NSString *response = [sha265 SHA256];
NSString *authorization = [NSString stringWithFormat:@"Digest username=\"%@\", realm=\"%@\", nonce=\"%@\", uri=\"%@\", algorithm=\"%@\", response=\"%@\"",username,realm,nonce,digestURI,algorithm,response];
[self.request setValue:authorization forHTTPHeaderField:@"Authorization"];
[self.request  setValue :@"application/soap+xml;charset=utf-8"  forHTTPHeaderField:@"Content-Type" ] ;
}

//#import "NSString+SHA256.h"
//#import <CommonCrypto/CommonDigest.h>

//@implementation NSString (SHA256)

- (NSString *)SHA256
{
    const char *s = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    const unsigned *hashBytes = [out bytes];
    NSString *hash = [NSString stringWithFormat:@"xxxxxxxx",
                      ntohl(hashBytes[0]), ntohl(hashBytes[1]), ntohl(hashBytes[2]),
                      ntohl(hashBytes[3]), ntohl(hashBytes[4]), ntohl(hashBytes[5]),
                      ntohl(hashBytes[6]), ntohl(hashBytes[7])];
    return hash;
} */

@interface HttpHelper ()
@property (nonatomic,strong) AFHTTPSessionManager *httpManager;
///nonce字符串
@property(nonatomic,copy)NSString *nonceStr;
/// 限制401请求的次数
@property(nonatomic,assign)NSInteger count;
/// 所有的请求
@property(nonatomic,strong)NSMutableArray *allSessionTask;
/** authorization字符串处理*/
@property(nonatomic,copy)NSString *authorizationString;
/** 加密方式 */
@property(nonatomic, copy) NSString *algorithmStr;
/** 域名 */
@property(nonatomic, copy) NSString *realStr;

@end
/* 单例的初始化和manager的设置 */
+ (HttpHelper *)instance{
    static dispatch_once_t onceToken;
    static HttpHelper * httpHelper = nil;
    dispatch_once(&onceToken,^{
        httpHelper = [[HttpHelper alloc]init];

    });

    return httpHelper;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        self.httpManager = httpManager;
        //AFHTTPRequestSerializer 和 AFJSONRequestSerializer 随后台数据选择！！！
        self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //不验证证书 支持https
        self.httpManager.securityPolicy.allowInvalidCertificates = YES;
        [self.httpManager.securityPolicy setValidatesDomainName:NO];
    }
    return self;
}
/* 发送请求 */
#pragma mark - 自定义请求方式 支持POST\GET\PUT
- (void)sendRequestWithParams:(NSDictionary *)params requestType:(RequestType)requestType values:(NSDictionary *)values resultType:(ResultType)resultType finishedBlock:(APICompletionBlock)finishedBlock{
    NSString *url = [params objectForKey:REQUEST_URL];
    NSString *identifier = [params objectForKey:REQUEST_IDENTIFIER];
    if (![self validateRequstUrl:url identifier:identifier block:finishedBlock]) {
        return;
    }
    [self setHttpHeaderDigestURI:identifier requestType:requestType nonce:self.nonceStr];
    NSLog(@"identifier:%@,postValues:%@",identifier,values);
    DefineWeakSelf;
    switch (requestType) {
        case RequestType_POST:{
            NSURLSessionDataTask *task =  [self.httpManager POST:url parameters:values progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSError *er;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&er];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"_____请求链接url:%@\n________identifier:%@\n______数据返回___\n%@",url,identifier,jsonString);
                [weakself showSuccessTask:task response:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakself showErrorTask:task error:error params:params requestType:requestType values:values resultType:resultType finishedBlock:finishedBlock];
            }];
            task ? [[self allSessionTask] addObject:task] : nil ;
            [task resume];
        }
            break;
        case RequestType_GET:{
            NSURLSessionDataTask *task =  [self.httpManager GET:url parameters:values.count > 0 ?values:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSError *er;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&er];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"_____请求链接url:%@\n________identifier:%@\n______数据返回___\n%@",url,identifier,jsonString);
                [weakself showSuccessTask:task response:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable datatask, NSError * _Nonnull error) {
                [weakself showErrorTask:datatask error:error params:params requestType:requestType values:values resultType:resultType finishedBlock:finishedBlock];
            }];
            task ? [[self allSessionTask] addObject:task] : nil ;
            [task resume];
        }
            break;
        case RequestType_PUT:{
            NSURLSessionDataTask *task = [self.httpManager PUT:url parameters:values success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSError *er;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&er];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"_____请求链接url:%@\n________identifier:%@\n______数据返回___\n%@",url,identifier,jsonString);
                [weakself showSuccessTask:task response:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable datatask, NSError * _Nonnull error) {
                NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
                NSString *errorStr = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"errorStr:%@",errorStr);
                [weakself showErrorTask:datatask error:error params:params requestType:requestType values:values resultType:resultType finishedBlock:finishedBlock];
            }];
            task ? [[self allSessionTask] addObject:task] : nil ;
            [task resume];
        }
            break;
        case RequestType_DELETE:{
        }
            break;
        default:
            break;
    }
}
/* digest最重要的环节，header的设置 */
#pragma mark 配置请求的header
//配置请求的header
-(void)setHttpHeaderDigestURI:(NSString *)digestURI requestType:(RequestType)requestType nonce:(NSString *)nonce{
    NSString *username = [[ToolBox instance]checkIsString:[DataManager instance].auth_username]?[DataManager instance].auth_username:API_ADMIN;
    NSString *password = [[ToolBox instance]checkIsString:[DataManager instance].auth_userpwd]?[DataManager instance].auth_userpwd:API_PWD;
    NSString *realm = [[ToolBox instance]checkIsString:self.realStr]?self.realStr:@"Huawei.com";
    NSString *method ;
    switch (requestType) {
        case RequestType_POST:{
            method = @"POST";
        }
            break;
        case RequestType_GET:{
            method = @"GET";
        }
            break;
        case RequestType_PUT:{
            method = @"PUT";
        }
            break;
        case RequestType_DELETE:{
            method = @"DELETE";
        }
            break;
        default:
            break;
    }
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"image/jpeg",@"image/png",@"application/octet-stream",@"multipart/form-data",@"text/plain", nil];
    [self.httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [self.httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.httpManager.requestSerializer.timeoutInterval = 20;//超时时间
    [self.httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //此字符串可任意
    nonce = @"9e6146023a70bdb0b4d1da795a029990";
    if ([[ToolBox instance]checkIsString:self.nonceStr]) {
        nonce = [NSString stringWithFormat:@"%@",self.nonceStr];
        self.nonceStr = nil;
    }
    NSString *HA1 = [[NSString stringWithFormat:@"%@:%@:%@",username,realm,password] SHA256];
    NSString *HA2 = [[NSString stringWithFormat:@"%@:%@",method,digestURI] SHA256];
    NSString *sha265 = [NSString stringWithFormat:@"%@:%@:%@",HA1,nonce,HA2];
    NSString *algorithm = @"SHA-256";
    NSString *response = [sha265 SHA256];
    if ([[ToolBox instance]checkIsString:self.algorithmStr] && [[self.algorithmStr lowercaseString] isEqualToString:@"md5"]) {
        HA1 = [[NSString stringWithFormat:@"%@:%@:%@",username,realm,password] stringFromMD5];
        HA2 = [[NSString stringWithFormat:@"%@:%@",method,digestURI] stringFromMD5];
        sha265 = [NSString stringWithFormat:@"%@:%@:%@",HA1,nonce,HA2];
        algorithm = self.algorithmStr;
        response = [sha265 stringFromMD5];
    }
    NSString *authorization = [NSString stringWithFormat:@"Digest username=\"%@\", realm=\"%@\", nonce=\"%@\", uri=\"%@\", algorithm=\"%@\", response=\"%@\"",username,realm,nonce,digestURI,algorithm,response];
    [self.httpManager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    self.authorizationString = authorization;
    /*
     不以明文发送密码，在上述第2步时服务器响应返回随机字符串nonce，而客户端发送响应摘要 =MD5(HA1:nonce:HA2)，其中HA1=MD5(username:realm:password),HA2=MD5(method:digestURI)
     在HTTP 摘要认证中使用 MD5 加密是为了达成"不可逆的"，也就是说，当输出已知的时候，确定原始的输入应该是相当困难的。
     如果密码本身太过简单，也许可以通过尝试所有可能的输入来找到对应的输出（穷举攻击），甚至可以通过字典或者适当的查找表加快查找速度。
     username: 用户名（网站定义）
     password: 密码
     realm:　服务器返回的realm,一般是域名
     method: 请求的方法
     nonce: 服务器发给客户端的随机的字符串
     nc(nonceCount):请求的次数，用于标记，计数，防止重放攻击
     cnonce(clinetNonce): 客户端发送给服务器的随机字符串
     qop: 保护质量参数,一般是auth,或auth-int,这会影响摘要的算法
     uri: 请求的uri(只是ｐａｔｈ)
     response:　客户端根据算法算出的摘要值
     */
}
/* 处理成功和失败的回调 */
//成功请求
-(void)showSuccessTask:(NSURLSessionDataTask *_Nullable)task response:(id)responseObject finishedBlock:(APICompletionBlock)finishedBlock{
    [[self allSessionTask] removeObject:task];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if (finishedBlock) {
                finishedBlock(CODE_JSON_OK,responseObject);
            }
        }else{
            if (finishedBlock) {
                if (responseObject != nil) {
                    finishedBlock(CODE_ERROR_JSON, responseObject);
                }else{
                    finishedBlock(CODE_ERROR_JSON, @"responseObject为nil");
                }
            }
        }
    });
}
//失败请求
-(void)showErrorTask:(NSURLSessionDataTask *_Nullable)task error:(NSError * _Nonnull) error params:(NSDictionary *)params requestType:(RequestType)requestType values:(NSDictionary *)values resultType:(ResultType)type  finishedBlock:(APICompletionBlock)finishedBlock{
    NSDictionary * pField = [(NSHTTPURLResponse*)task.response allHeaderFields];
    NSInteger statusCode = [(NSHTTPURLResponse*)task.response statusCode];
    NSLog(@"失败日志：%@:",pField);
    [[self allSessionTask] removeObject:task];
    DefineWeakSelf;
    if (statusCode == 401) {//digest auth
        NSString * strAuthenticate = [pField valueForKey:@"Www-Authenticate"];
        NSArray *allValues = [strAuthenticate componentsSeparatedByString:@","];
        [allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                NSArray *sepArray = [obj componentsSeparatedByString:@"="];
                if ([sepArray firstObject] && [[sepArray firstObject] containsString:@"realm"]) {
                    NSMutableString *newStr = [NSMutableString stringWithString:[sepArray lastObject]] ;
                    if (newStr.length >= 3) {
                        [newStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
                        [newStr replaceCharactersInRange:NSMakeRange(newStr.length - 1, 1) withString:@""];
                        weakself.realStr = newStr;
                    }
                }
                if ([sepArray firstObject] && [[sepArray firstObject] containsString:@"algorithm"]) {
                    weakself.algorithmStr = [sepArray lastObject];
                }
                if ([sepArray firstObject] && [[sepArray firstObject] containsString:@"nonce"]) {
                    NSMutableString *newStr = [NSMutableString stringWithString:[sepArray lastObject]] ;
                    if (newStr.length >= 3) {
                        [newStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
                        [newStr replaceCharactersInRange:NSMakeRange(newStr.length - 1, 1) withString:@""];
                        weakself.nonceStr = newStr;
                    }
                }
            }
        }];
        weakself.count += 1;
        if (weakself.count == 2) {//第二次不再请求
            weakself.count = 0;
            if (statusCode == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(CODE_ID_AUTH,@"该设备暂不支持");
                });
            }else{
                if([[NSThread currentThread]isMainThread]){
                    [weakself error:error finishedBlock:finishedBlock];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself error:error finishedBlock:finishedBlock];
                    });
                }
            }
        }else{
            [weakself sendRequestWithParams:params requestType:requestType values:values resultType:type finishedBlock:finishedBlock];
        }
    }else if (statusCode == 403){
        dispatch_async(dispatch_get_main_queue(), ^{
            finishedBlock(CODE_USER_LOCKED,@"密码输入错误太多,账号锁定360秒");
        });
    }else if (statusCode == 502){
        dispatch_async(dispatch_get_main_queue(), ^{
            finishedBlock(CODE_URL_ERROR,@"网关或代理服务器错误");
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself error:error finishedBlock:finishedBlock];
        });
    }
}
#pragma mark - 请求失败的toast
//请求失败的toast
-(void)error:(NSError *)error finishedBlock:(APICompletionBlock)finishedBlock{
    if (finishedBlock) {
        if (error) {
            if (error && NSURLErrorRequestBodyStreamExhausted == error.code) {
                finishedBlock(CODE_ERROR_JSON, @"连接失败，因为它的请求的主体流已耗尽!");
            }else if (error && NSURLErrorTimedOut == error.code){
                finishedBlock(CODE_TIME_OUT, @"连接超时!");
            }else if (error && NSURLErrorNotConnectedToInternet == error.code){
                finishedBlock(CONN_EXCEPTON, kNoNetwork);
            }else if (error && NSURLErrorNetworkConnectionLost == error.code){
                finishedBlock(CONN_EXCEPTON, kNoNetwork);
            }else if (error && NSURLErrorCannotConnectToHost == error.code){
                finishedBlock(CODE_SYSTEM_MAINTAIN, @"连接失败，无法连接到主机，请检查网络或wifi设置了代理");
            }else if (error && NSURLErrorUserCancelledAuthentication == error.code){
                finishedBlock(CONN_EXCEPTON, @"连接失败，用户取消了所需的身份验证");
            }else if (error && NSURLErrorCannotFindHost == error.code){
                finishedBlock(CODE_SYSTEM_MAINTAIN, @"连接失败，因为找不到主机");
            }else if (error && NSURLErrorHTTPTooManyRedirects == error.code){
                finishedBlock(CONN_EXCEPTON, @"HTTP连接由于重定向太多而失败");
            }else if (error && NSURLErrorCancelled == error.code){
                finishedBlock(CODE_SYSTEM_MAINTAIN, @"服务器服务终止");
            }else if (error && error.code == 3840){
                finishedBlock(CODE_ERROR_JSON, @"数据无法读取，格式不正确");
            } else{
                finishedBlock(CODE_ERROR_JSON, error.localizedDescription);
            }
        }else{
            finishedBlock(CODE_BACK_ERR, @"请求失败");
        }
    }
}

@end
