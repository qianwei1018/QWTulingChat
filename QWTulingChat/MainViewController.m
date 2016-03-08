//
//  MainViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/5.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "MainViewController.h"
#import "ChatViewController.h"

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
}

#pragma mark - 点击事件
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
    
    //判断是否登陆成功
    if ( ([userName isEqualToString:[myDict valueForKey:@"userName"]]) && [password isEqualToString:[myDict valueForKey:@"password"]]) {
        NSLog(@"登陆成功");
        
        
        
        
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
 *  帮助
 *
 *  @param sender <#sender description#>
 */
- (IBAction)helpBtnClick:(UIButton *)sender {
    [self addAlertBox:@"使用帮助" message:@"测试@@@@，如果没有账号，请先注册" actionTitle:@"OK"];
}
/**
 *  忘记密码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)forgetPasswordBtn:(UIButton *)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
