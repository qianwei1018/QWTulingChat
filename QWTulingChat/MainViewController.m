//
//  MainViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/5.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "MainViewController.h"
#import "ChatViewController.h"
#import "ForgetPasswordViewController.h"

@interface MainViewController ()
/**
 *  图像
 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
/**
 *  账号
 */
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pictureImageView.layer.cornerRadius = 40;  //设置图片圆角
    self.pictureImageView.layer.masksToBounds = YES;
    
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
- (void) initView {
    self.passwordTextField.secureTextEntry = YES;
    //默认数据
    self.accountTextField.text = @"qqqqqq";
    self.passwordTextField.text = @"qqqqqq";
}

#pragma mark - 点击事件
/**
 *  回收键盘
 *
 *  @param touches 点击
 *  @param event   回收键盘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

/**
 *  登陆按钮
 *
 *  @param sender <#sender description#>
 */
- (IBAction)loginBtnClick:(UIButton *)sender {
    [self checkOfData];
    
}

/**
 *  在数据库中找到数据（用户名一样的数据）
 */
- (void)checkOfData {
    NSString *userName = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    //读取数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *myDict = [defaults dictionaryForKey:[NSString stringWithFormat:@"%@",userName]];
    NSString *str = [NSString stringWithFormat:@"userName:%@,password:%@",[myDict valueForKey:@"userName"],[myDict valueForKey:@"password"]];
    NSLog(@"%@",str);
    
    //判断 登陆信息
    if ( ([userName isEqualToString:[myDict valueForKey:@"userName"]]) && [password isEqualToString:[myDict valueForKey:@"password"]]) {
        NSLog(@"登陆成功");
        
        
        //页面跳转
        //1.连线（show  连接整个view）  设置线的Identifier
//        [self performSegueWithIdentifier:@"ToTabBarController" sender:self];
        //2.使用StoryBoardId进行跳转 设置StoryBoardId
        ChatViewController *chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
        [self.navigationController pushViewController:chatViewController animated:YES];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:chatViewController];
//        [self presentViewController:navi
//                           animated:YES completion:^{
//            
//        }];
        
        
    } else if ([userName isEqualToString:@""]) {
        NSLog(@"用户名不能为空");
        [self addAlertBox:@"警告" message:@"用户名不能为空" actionTitle:@"OK"];
    } else if ([password isEqualToString:@""]) {
        NSLog(@"密码不能为空");
        [self addAlertBox:@"警告" message:@"密码不能为空" actionTitle:@"OK"];
    } else if (![userName isEqualToString:[myDict valueForKey:@"userName"]]) {
        NSLog(@"用户未注册");
        [self addAlertBox:@"警告" message:@"用户未注册" actionTitle:@"OK"];
    } else if (([userName isEqualToString:[myDict valueForKey:@"userName"]]) && ![password isEqualToString:[myDict valueForKey:@"password"]]) {
        NSLog(@"密码错误");
        [self addAlertBox:@"警告" message:@"密码错误" actionTitle:@"OK"];
    } else {
        NSLog(@"登陆失败");
        [self addAlertBox:@"警告" message:@"登录失败" actionTitle:@"OK"];
    }
    
}
/**
 *  注册
 *
 *  @param sender <#sender description#>
 */
- (IBAction)registerBtnClick:(UIButton *)sender {
    
}

/**
 *  忘记密码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)forgetPasswordBtn:(UIButton *)sender {
    NSString *userName = self.accountTextField.text;
//    NSString *password = self.passwordTextField.text;
    
    //查找数据库中是否有该用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *myDict = [defaults dictionaryForKey:[NSString stringWithFormat:@"%@",userName]];
    
    if ([userName isEqualToString:@""]) {
        NSLog(@"用户名不能为空");
        [self addAlertBox:@"警告" message:@"用户名不能为空" actionTitle:@"OK"];
    } else if ([userName isEqualToString:[myDict valueForKey:@"userName"]]) {
        //跳转到忘记密码界面
        ForgetPasswordViewController *forgetpw = [self.storyboard instantiateViewControllerWithIdentifier:@"forgetPasswordViewController"];
        [self.navigationController pushViewController:forgetpw animated:YES];
    }
}
/**
 *  帮助
 *
 *  @param sender <#sender description#>
 */
- (IBAction)helpBtnClick:(UIButton *)sender {
    [self addAlertBox:@"使用帮助" message:@"测试，如果没有账号，请先注册" actionTitle:@"OK"];
}

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
