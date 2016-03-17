//
//  ForgetPasswordViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/9.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "NewpasswordViewController.h"
#import "SMS_SDK/SMSSDK.h"

@interface ForgetPasswordViewController ()
/**
 *  手机号码框
 */
@property (weak, nonatomic) IBOutlet UITextField *telNumTextField;
/**
 *  验证码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
/**
 *  回收键盘
 *
 *  @param touches 点击
 *  @param event   回收键盘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.telNumTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
}

/**
 *  请求发送验证码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)sendVerificationCode:(UIButton *)sender {
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.telNumTextField.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
        if (!error) {
            NSLog(@"successful");
        } else {
            NSLog(@"file:%@",error);
        }
    }];

}
/**
 *  验证验证码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)confirmVerificationCode:(UIButton *)sender {
    
    [SMSSDK commitVerificationCode:self.verificationCodeTextField.text
                       phoneNumber:self.telNumTextField.text
                              zone:@"86"
                            result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证成功");
            
            //跳转到修改密码界面
            NewpasswordViewController *newpasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newpasswordViewController"];
            [self.navigationController pushViewController:newpasswordVC animated:YES];
            
            
            
        } else {
            NSLog(@"验证失败,错误信息:%@",error);
        }
    }];

}











@end
