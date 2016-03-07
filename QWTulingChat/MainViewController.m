//
//  MainViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/5.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "MainViewController.h"

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
    self.pictureImageView.backgroundColor = [UIColor colorWithRed:1.000 green:0.462 blue:0.691 alpha:1.000];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
/**
 *  登陆按钮
 *
 *  @param sender <#sender description#>
 */
- (IBAction)loginBtnClick:(UIButton *)sender {
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"使用帮助" message:@"  测试，如果没有账号，请先注册！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *  忘记密码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)forgetPasswordBtn:(UIButton *)sender {
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
