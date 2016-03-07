//
//  ChatViewController.m
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/7.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import "ChatViewController.h"
#import "MyTulingHeader.h"

@interface ChatViewController ()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSTimer *timer;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ShowScrollView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changePageControl:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加scrollView
 */
- (void)ShowScrollView {
    for (int i = 0; i < 4; i++) {
        NSString *imgName = [NSString stringWithFormat:@"scrollView%d",i+1];
        UIImage *img = [UIImage imageNamed:imgName];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.scrollView addSubview:imgView];
        
    }
    // 设置scrollView的显示内容大小
    self.scrollView.contentSize = CGSizeMake(4*SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
}

- (void)changePageControl:(NSTimer *)sender {
    self.pageControl.currentPage = (self.pageControl.currentPage+1)%self.pageControl.numberOfPages;
    
    [self changeScorllViewOffSet];
}

- (void)changeScorllViewOffSet {
    self.scrollView.contentOffset = CGPointMake(self.pageControl.currentPage*SCREEN_WIDTH, 0);
}

- (IBAction)changePage:(UIPageControl *)sender {
    [self changeScorllViewOffSet];
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"scrollViewWillEndDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changePageControl:) userInfo:nil repeats:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = (self.scrollView.contentOffset.x+SCREEN_WIDTH/2)/SCREEN_WIDTH;
    self.pageControl.currentPage = page;
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
