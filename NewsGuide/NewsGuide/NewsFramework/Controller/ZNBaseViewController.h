//
//  MEHomeViewController.h
//  mrenApp
//
//  Created by zhouen on 16/12/1.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZNChannelView;

static NSString *const reuserIdentifer = @"collectionCell";

@interface ZNBaseViewController : UIViewController<
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (nonatomic, readonly) ZNChannelView *channelView;

@property (nonatomic ,strong)   NSMutableDictionary     *viewControllers;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *data;
@end
