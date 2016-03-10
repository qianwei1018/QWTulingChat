//
//  RegisterViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/7.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "RegisterViewController.h"
#import "MyTulingHeader.h"

@interface RegisterViewController ()
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/**
 *  性别选择
 */
@property (strong, nonatomic) NSString *segmentStr;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/**
 *  确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
/**
 *  电话号码
 */
@property (weak, nonatomic) IBOutlet UITextField *TelTextField;
/**
 *  图片选择
 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property(strong,nonatomic)NSUserDefaults *defaults;


@end

@implementation RegisterViewController
{
    int _currentIndex;    //当前pictureImageView的图片
    int flag;             //标记符（用于标记是否注册成功）
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    //添加手势
    [self addGestureOnPictureImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化界面
 */
- (void) initView {
    self.pictureImageView.layer.cornerRadius = self.pictureImageView.bounds.size.height/2;
    //添加默认图片
    _currentIndex = 1;
    self.pictureImageView.image = [UIImage imageNamed:@"pictureImage1"];
    
    //设置图片可操作模式
    self.pictureImageView.userInteractionEnabled = YES;
    
    //设置密码隐藏
    self.passwordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.secureTextEntry = YES;
    
    flag = 0;
}

#pragma mark - 添加手势
/**
 *  为 picutureImgView add 手势
 */
- (void) addGestureOnPictureImageView {
    //添加左右轻扫
    UISwipeGestureRecognizer *swipeGRRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipe:)];
    swipeGRRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.pictureImageView addGestureRecognizer:swipeGRRight];
    
    UISwipeGestureRecognizer *swipeGRLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSwipe:)];
    swipeGRLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.pictureImageView addGestureRecognizer:swipeGRLeft];
}

/**
 *  Add gestures processing method
 *
 *  @param gesture     gesture
 */
- (void) doSwipe:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self lastImage];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextImage];
    }
}

/**
 *  手势实现方法
 *
 *  @return 当前图片的名字
 */
- (void)lastImage {
    int index = (_currentIndex + NUMBEROFPICTUREIMAGE - 1)%NUMBEROFPICTUREIMAGE;
    NSString *pictureImageNameIndex = [NSString stringWithFormat:@"pictureImage%d",index];
    _currentIndex = index;
    self.pictureImageView.image = [UIImage imageNamed:pictureImageNameIndex];
}

- (void)nextImage {
    int index = (_currentIndex + NUMBEROFPICTUREIMAGE + 1)%NUMBEROFPICTUREIMAGE;
    NSString *pictureImageNameIndex = [NSString stringWithFormat:@"pictureImage%d",index];
    _currentIndex = index;
    self.pictureImageView.image = [UIImage imageNamed:pictureImageNameIndex];
}

#pragma mark - 点击事件
/**
 *  segment 选择性别
 *
 *  @param sender click Index
 */
- (IBAction)segmentedChangeGender:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.segmentStr = [sender titleForSegmentAtIndex:0];
            break;
        case 1:
            self.segmentStr = [sender titleForSegmentAtIndex:1];
            break;
        case 2:
            self.segmentStr = [sender titleForSegmentAtIndex:2];
            break;
        default:
            break;
    }
}

/**
 *  清除所有输入
 *
 *  @param sender <#sender description#>
 */
- (IBAction)replaceChoice:(UIButton *)sender {
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
    self.confirmPasswordTextField.text = @"";
    self.TelTextField.text = @"";
    self.pictureImageView.image = [UIImage imageNamed:@"pictureImage1"];
}

/**
 *  注册提交 （数据持久化）
 *
 *  @param sender <#sender description#>
 */
- (IBAction)confirmSubmit:(UIButton *)sender {
    NSLog(@"**************************");
    NSLog(@"检查是否注册成功！");
    flag = 0;
    //填写的数据
    NSString *userName = self.userNameTextField.text;
    NSString *segmentStrText = self.segmentStr;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    NSString *telNum = self.TelTextField.text;
    NSString *pictureImageNameIndex = [NSString stringWithFormat:@"pictureImage%d",_currentIndex];
    
    //正则表达式 判断userName 、password 、telNum 是否符合正则表达式
    [self RegularExpressionsCheck:userName  password:password  telNum:telNum];
    //判断两次密码是否一致
    if (![confirmPassword isEqualToString:password]) {
        flag = 1;
        //输入错误弹出警告
        [self addAlertBox:@"警告" message:@"两次密码不一致" actionTitle:@"确定"];
    }
    //判断性别是否为空
    [self judgmentOfGender];
    //数据填写正确
    if (flag == 0) {
        //plist文件中的账号信息
        NSDictionary *myDictionary;
        //以当前注册的用户名为名的账号信息
        NSDictionary *myDict = [self.defaults dictionaryForKey:[NSString stringWithFormat:@"%@",userName]];
        //判断此用户是否已注册
        if ([userName isEqualToString:[myDict valueForKey:@"userName"]]) {
            [self addAlertBox:@"警告" message:@"用户已存在，请重新注册" actionTitle:@"OK"];
        } else {
            //数据持久化 （保持在Library文件下的 plist文件中）
            self.defaults = [NSUserDefaults standardUserDefaults];
            myDictionary =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:userName,segmentStrText,password,telNum,pictureImageNameIndex, nil] forKeys:[NSArray arrayWithObjects:@"userName",@"segmentStrText",@"password",@"telNum",@"pictureImageNameIndex", nil]];
            //将数据存入以用户名为名的字典中
            [self.defaults setObject:myDictionary forKey:[NSString stringWithFormat:@"%@",userName]];
            NSLog(@"*****************");
            
            //同步信息
            [self.defaults synchronize];
            NSLog(@"userName:%@",userName);
            NSLog(@"segmentStrText:%@",segmentStrText);
            NSLog(@"password:%@",password);
            NSLog(@"confirmPassword:%@",confirmPassword);
            NSLog(@"telNum:%@",telNum);
            NSLog(@"pictureImageNameIndex:%@",pictureImageNameIndex);
            
            [self addAlertBox:@"恭喜你" message:@"注册成功" actionTitle:@"登陆"];
        }
        // Documents目录
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSLog(@"path : %@", documentsPath);
    }
}

#pragma mark - 正则表达式
/**
 *  正则表达式
 *
 *  @param userName              用户名
 *  @param password              密码
 *  @param telNum                电话号码
 */
-(void)RegularExpressionsCheck:(NSString *)userName
                      password:(NSString *)password
                        telNum:(NSString *)telNum{
    [self checkRegular:userName regular:REGEX_USER_NAME message:@"用户名格式错误"];
    [self checkRegular:password regular:REGEX_PASSWORD message:@"密码格式错误"];
    [self checkRegular:telNum regular:REGEX_TELNUM message:@"电话号码格式错误"];
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

/**
 *  性别的判断
 */
- (void) judgmentOfGender {
    if (_segmentStr == NULL) {
        flag = 1;
        //输入错误弹出警告
        [self addAlertBox:@"警告" message:@"性别不能为空" actionTitle:@"确定"];
    }
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
