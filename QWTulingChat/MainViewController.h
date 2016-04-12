//
//  MainViewController.h
//  QWTulingChat
//
//  Created by sq-ios25 on 16/3/5.
//  Copyright © 2016年 sq-ios25. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalCenterViewController.h"
@protocol myValuesDelegate<NSObject>

- (void) valuesOfName:(NSString*)name;

@end

@interface MainViewController : UIViewController<myValuesDelegate>{
    NSString *valuesOfName;
    NSString *valuesOFimageName;
}
@property (weak, nonatomic)id<myValuesDelegate>delegate;



@end
