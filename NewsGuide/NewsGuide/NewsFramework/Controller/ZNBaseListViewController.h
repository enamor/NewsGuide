//
//  MEHomeListViewController.h
//  mrenApp
//
//  Created by zhouen on 16/12/1.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const reuseIdentifier = @"ItemCell";

@interface ZNBaseListViewController : UICollectionViewController
@property (nonatomic, strong) NSArray *data;

-(UIColor *) randomColor;

@end
