//
//  UIBaseViewController.h
//  QingYanFuYanWo
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CNPPopupController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "ZSXAlertLabel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "LeanCloudFeedback.h"
#import "UMSocial.h"
#import "UMSocialScreenShoter.h"
#import "Reachability.h"

@interface UIBaseViewController : UIViewController

- (void)initWithRightBarButton:(NSString *)title AndBackImageName:(NSString *)backImageName AndTarget:(id)target Andselector:(SEL)selector;

- (void)initWithLeftBarButton:(NSString *)title AndBackImageName:(NSString *)backImageName AndTarget:(id)target Andselector:(SEL)selector;

-(void)setNavigationTitle:(NSString *)title;

- (void)initWithBackBarButton;

- (void)initWithShareBarButton;

- (void) dimissAlert:(UIAlertView *)alert;

- (void) onLeftBackClick;
@end
