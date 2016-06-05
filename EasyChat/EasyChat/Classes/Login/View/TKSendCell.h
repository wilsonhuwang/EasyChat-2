//
//  TKSendCell.h
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDK.h"

@interface TKSendCell : UITableViewCell
@property (nonatomic, strong) EMMessage *message;
// 计算cell高度
@property (nonatomic, assign) CGFloat cellHeight;
@end
