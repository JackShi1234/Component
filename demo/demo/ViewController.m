//
//  ViewController.m
//  demo
//
//  Created by 张小二 on 2020/12/7.
//

#import "ViewController.h"
#import "dictMulitToString.h"
#import "VerificationCodeVC.h"
#import "PopViewsVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dictSort];
}

#pragma mark - dicMutilsSort 加签前对嵌套多层字典数组排序组装
- (void)dictSort{
    NSDictionary *dic = @{
            @"code":@0,
            @"list":@[@{
                          @"userName":@"wjx",
                          @"sex":@"男"
            },
                      @{
                                    @"userName":@"www",
                                    @"sex":@"男"
                      },@{
                          @"userName":@"jjj",
                          @"sex":@"男"
            }],
            @"data":@{
                    @"userinfo":@{
                            @"roleNo":@"0000000002",
                            @"lastLoginTime":@"2020-11-24 17:25:04",
                            @"roleFlag":@"1",
                            @"userName":@"网点社操作员",
                            @"level":@{
                                    @"normal":@"1",
                                    @"vip":@{
                                            @"start":@"1",
                                            @"time":@"2020-02-02",
                                            @"nums":@[@{@"b":@"1",@"a":@"3"},@{@"a":@"2"}]
                                    },
                                    @"svip":@"3"
                            }
                    },
                    @"token":@"5d60ab6bf0d64899952f38bdb7042010"
            },
            @"message":@"操作成功",
            @"status":@"success"
        };

       NSString *sgin = [dictMulitToString handleDic:dic];
        NSLog(@"%@",sgin);
}

// 弹出验证码
- (IBAction)VeriCodeClick:(id)sender {
    
    VerificationCodeVC * nextVc = [[VerificationCodeVC alloc]init];
    nextVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nextVc animated:YES completion:nil];
    
}

- (IBAction)popViewClick:(id)sender {
    
    PopViewsVC * nextVc = [[PopViewsVC alloc]init];
    nextVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nextVc animated:YES completion:nil];
    
}


@end
