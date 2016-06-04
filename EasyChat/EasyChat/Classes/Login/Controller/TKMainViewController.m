//
//  TKMainViewController.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKMainViewController.h"
#import "TKBaseNavigationController.h"
#import "TKConverseListController.h"
#import "TKFriendListController.h"
#import "TKRelasxedViewController.h"

@interface TKMainViewController ()
@end

@implementation TKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChildrenControllers];
}

// 添加子控制器
- (void)setupChildrenControllers
{
    [self addChildViewController:[[TKConverseListController alloc] init] imageName:@"tabBar_me_icon" selectedImageName:@"tabBar_me_click_icon" withTilte:@"消息"];
    [self addChildViewController:[[TKFriendListController alloc] init] imageName:@"tabBar_friendTrends_icon" selectedImageName:@"tabBar_friendTrends_click_icon" withTilte:@"好友"];
    [self addChildViewController:[[TKRelasxedViewController alloc] init] imageName:@"tabBar_new_icon" selectedImageName:@"tabBar_new_click_icon" withTilte:@"休闲"];
}

- (void)addChildViewController:(UIViewController *)childController imageName:(NSString *)imageName selectedImageName:(NSString *)selecedImageName withTilte:(NSString *)title
{
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selecedImageName];
    childController.title = title;
    TKBaseNavigationController *nav = [[TKBaseNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}
@end
