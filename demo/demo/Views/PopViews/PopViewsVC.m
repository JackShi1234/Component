//
//  PopViewsVC.m
//  demo
//
//  Created by 张小二 on 2020/12/7.
//

#import "PopViewsVC.h"

#import "YsyPopMacro.h"
#import "YsyPopHelper.h"
#import "TestView.h"
#import "BaiDuView.h"

@interface PopViewsVC ()<TestViewDelegate>

@property (nonatomic,strong) YsyPopHelper *helper;

@end

@implementation PopViewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addButtons];
}

- (void)addButtons {
    
    UIButton *btntop = [UIButton buttonWithType:UIButtonTypeCustom];
    [btntop setFrame:CGRectMake((MyWidth - 60) / 2, 60, 60 , 60 )];
    [btntop setTitle:@"上" forState:UIControlStateNormal];
    [btntop addTarget:self action:@selector(btnTopClick:) forControlEvents:UIControlEventTouchUpInside];
    btntop.backgroundColor = [UIColor redColor];
    [self.view addSubview:btntop];
    
    UIButton *btnbottom = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnbottom setFrame:CGRectMake((MyWidth - 60) / 2, 300, 60 , 60 )];
    [btnbottom setTitle:@"下" forState:UIControlStateNormal];
    [btnbottom addTarget:self action:@selector(btnBottomClick:) forControlEvents:UIControlEventTouchUpInside];
    btnbottom.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnbottom];
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnleft setFrame:CGRectMake(60, 180, 60 , 60 )];
    [btnleft setTitle:@"左" forState:UIControlStateNormal];
    [btnleft addTarget:self action:@selector(btnLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    btnleft.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnleft];
    
    UIButton *btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnright setFrame:CGRectMake(MyWidth-100, 180, 60 , 60 )];
    [btnright setTitle:@"右" forState:UIControlStateNormal];
    [btnright addTarget:self action:@selector(btnRightClick:) forControlEvents:UIControlEventTouchUpInside];
    btnright.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnright];
    
    UIButton *btncenter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btncenter setFrame:CGRectMake((MyWidth - 60) / 2, 180, 60 , 60 )];
    [btncenter setTitle:@"中" forState:UIControlStateNormal];
    [btncenter addTarget:self action:@selector(btnCenterClick:) forControlEvents:UIControlEventTouchUpInside];
    btncenter.backgroundColor = [UIColor redColor];
    [self.view addSubview:btncenter];
    
}

- (void)btnTopClick:(id)sender {
    BaiDuView *popView = [[BaiDuView alloc] initWithFrame:CGRectMake(0, 0, MyWidth,MyWidth/1.95)];
    _helper = [[YsyPopHelper alloc] initWithCustomView:popView popStyle:YsyPopStyleSpringFromTop dismissStyle:YsyDismissStyleSmoothToTop position:YsyPositonTop];
    _helper.superView = self.view;
    _helper.offsetY = [[UIApplication sharedApplication] statusBarFrame].size.height+44;
    [_helper show];
}

- (void)btnBottomClick:(id)sender {
    BaiDuView *popView = [[BaiDuView alloc] initWithFrame:CGRectMake(0, 0, MyWidth,MyWidth/1.95)];
    _helper = [[YsyPopHelper alloc] initWithCustomView:popView popStyle:YsyPopStyleSpringFromBottom dismissStyle:YsyDismissStyleSmoothToBottom position:YsyPositonBottom];
    [_helper show];
}

- (void)btnLeftClick:(id)sender {
    TestView *popView = [TestView new];
    popView.bounds  = CGRectMake(0, 0, 260,291 );
    popView.delegate = self;
    _helper = [[YsyPopHelper alloc] initWithCustomView:popView popStyle:YsyPopStyleSmoothFromLeft dismissStyle:YsyDismissStyleSmoothToRight position:YsyPositonLeft];
    [_helper show];
}

- (void)btnRightClick:(id)sender {
    TestView *popView = [TestView new];
    popView.bounds  = CGRectMake(0, 0, 260,291 );
    popView.delegate = self;
    _helper = [[YsyPopHelper alloc] initWithCustomView:popView popStyle:YsyPopStyleSpringFromRight dismissStyle:YsyDismissStyleSmoothToLeft position:YsyPositonRight];
    [_helper show];
}

- (void)btnCenterClick:(id)sender {
    TestView *popView = [TestView new];
    popView.bounds  = CGRectMake(0, 0, 260,291 );
    popView.delegate = self;
    _helper = [[YsyPopHelper alloc] initWithCustomView:popView popStyle:YsyPopStyleFade dismissStyle:YsyDismissStyleScale position:YsyPositonCenter];
    [_helper show];
}

//自定义弹窗代理
- (void)iKnowButtClick{
    NSLog(@"弹窗代理");
    [_helper dismiss];
    
}

@end
