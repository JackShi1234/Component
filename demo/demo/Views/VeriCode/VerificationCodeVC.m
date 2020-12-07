//
//  VerificationCodeVC.m
//  demo
//
//  Created by 张小二 on 2020/12/7.
//

#import "VerificationCodeVC.h"
#import "JMOAuthCode.h"

#import "Masonry.h"

#define JMColorHexWithAlpha(hexValue, aplha) [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:aplha]
#define JMColorHex(hexValue) JMColorHexWithAlpha(hexValue, 1.0)

@interface VerificationCodeVC ()<JMOAuthCodeViewDelegate>

@end

@implementation VerificationCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCodeView];
    
    
}

- (void)addCodeView {
    
    self.view.backgroundColor = JMColorHex(0x8D6AAC);
    
    //创建view时，需要指定验证码的长度
    JMOAuthCode *oacView = [[JMOAuthCode alloc] initWithMaxLength:4];
    [self.view addSubview:oacView];
    /* -----设置可选的属性 start----- */
    oacView.delegate = self; //设置代理
    oacView.boxNormalBorderColor = [UIColor yellowColor]; //方框的边框正常状态时的边框颜色
    oacView.boxHighlightBorderColor = [UIColor redColor]; //方框的边框输入状态时的边框颜色
    oacView.boxBorderWidth = 2; //方框的边框宽度
    oacView.boxCornerRadius = 6; //方框的圆角半径
    oacView.boxBGColor = [UIColor whiteColor];  //方框的背景色
    oacView.boxTextColor = [UIColor blackColor]; //方框内文字的颜色
    /* -----设置可选的属性 end----- */
    
    //显示键盘，可以输入验证码了
    [oacView beginEdit];
    
    //可选步骤：Masonry布局/设置frame
    [oacView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oacView.superview).offset(15);
        make.right.equalTo(oacView.superview).offset(-15);
        make.top.equalTo(oacView.superview).offset(150);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - SWOAuthCodeViewDelegate

- (void)oauthCodeView :(JMOAuthCode *)mqView inputTextChange:(NSString *)currentText{
    NSLog(@"currentText: %@", currentText);
}

- (void)oauthCodeView:(JMOAuthCode *)mqView didInputFinish:(NSString *)finalText{
    NSLog(@"didInputFinish: %@", finalText);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
