//
//  NewpasswordViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/9.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "NewpasswordViewController.h"
#import "MyTulingHeader.h"

@interface NewpasswordViewController ()

/**
 *  账号信息
 */
@property (weak, nonatomic) IBOutlet UILabel *accountMsg;

/**
 *  新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *newpPasswordTextField;
/**
 *  确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordTextField;

@end

@implementation NewpasswordViewController
{
    int flag;
    NSUserDefaults *defaults;
}

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
    [self.newpPasswordTextField resignFirstResponder];
    [self.confirmNewPasswordTextField resignFirstResponder];
}



/**
 *  提交密码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)submitNewPassword:(UIButton *)sender {
    
    //判断两次密码是否一致
    if (![_confirmNewPasswordTextField.text isEqualToString:@""]) {
        if (![_confirmNewPasswordTextField.text isEqualToString:_newpPasswordTextField.text]) {
            flag = 1;
            //输入错误弹出警告
            [self addAlertBox:@"警告" message:@"两次密码不一致" actionTitle:@"确定"];
        } else {
            flag = 0;
            [self checkRegular:_newpPasswordTextField.text regular:REGEX_PASSWORD message:@"格式错误"];
        }
    } else {
        [self addAlertBox:@"警告" message:@"密码不能为空" actionTitle:@"确定"];
        flag = 1;
    }
    

    if (flag == 0) {
        NSLog(@"修改密码");
//        defaults = [NSUserDefaults standardUserDefaults];
//        NSDictionary *myDictionary =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:userName,_newpPasswordTextField.text, nil] forKeys:[NSArray arrayWithObjects:@"userName",@"password", nil]];
//        //将数据存入以用户名为名的字典中
//        [defaults setObject:myDictionary forKey:[NSString stringWithFormat:@"%@",userName]];
    
    
    //同步信息
//    [defaults synchronize];
    }

    
}

/**
 *  正则表达式的检查
 *
 *  @param searchText 检查的字符串
 *  @param regular    正则表达式规则
 *  @param message    输入错误是得弹出信息
 */
- (void)checkRegular:(NSString *)searchText
             regular:(NSString *)regular
             message:(NSString *)message {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (result) {
        NSLog(@"%@",[searchText substringWithRange:result.range]);
    } else {
        flag = 1;
        //输入错误弹出警告
        [self addAlertBox:@"警告" message:message actionTitle:@"确定"];
    }
}

#pragma mark - 弹出框
/**
 *  alert 警告框
 *
 *  @param title       alert title
 *  @param message     message
 *  @param actionAlert actionAlert
 */
- (void)addAlertBox:(NSString *)title
            message:(NSString *)message
        actionTitle:(NSString*)actionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:actionAlert style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
