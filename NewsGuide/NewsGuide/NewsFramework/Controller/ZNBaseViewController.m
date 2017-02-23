//
//  MEHomeViewController.m
//  mrenApp
//
//  Created by zhouen on 16/12/1.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "ZNBaseViewController.h"
#import "ZNChannelView.h"


@interface ZNBaseViewController ()<ChannelViewDelegate>

@property (nonatomic, strong)   UICollectionView        *collectionView;
@property (nonatomic ,strong)   ZNChannelView           *channelView;

@end



@implementation ZNBaseViewController

#pragma mark ------ Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupSubview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ------ setter getter
- (void)setData:(NSArray *)data {
    _data = data;
    [self.collectionView reloadData];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    self.channelView.channels = _titles;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        CGFloat cY = self.channelView.frame.size.height + self.channelView.frame.origin.x;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, cY, self.view.frame.size.width, self.view.frame.size.height - cY) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        flowLayout.itemSize = _collectionView.bounds.size;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuserIdentifer];
    }
    return _collectionView;
}

- (NSMutableDictionary *)viewControllers {
    if (!_viewControllers) {
        _viewControllers =[NSMutableDictionary dictionary];
    }
    return _viewControllers;
}

- (ZNChannelView *)channelView {
    if (!_channelView) {
        _channelView = [[ZNChannelView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _channelView.delegate = self;
        _channelView.backgroundColor = [UIColor whiteColor];
    }
    return _channelView;
}


#pragma mark ------ Public


#pragma mark ------ Private
- (void)p_setupSubview {
    [self.view addSubview:self.channelView];
    self.channelView.selectColor = [UIColor blueColor];
    self.channelView.indicateLineHeight = 3.0f;
    
    
    [self.view addSubview:self.collectionView];
}


#pragma mark ------ Protocol

//点击某个分类
- (void)channelView:(ZNChannelView *)channelView didSelectIndex:(NSUInteger)index{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark ------ UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifer forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *reuseIdentify = @(indexPath.row).stringValue;
    UIViewController * vc;
    if (!self.viewControllers[reuseIdentify]) {
        vc= [[UIViewController alloc] init];
        [self addChildViewController:vc];
        [self.viewControllers setObject:vc forKey:reuseIdentify];
        
    } else {
        vc= self.viewControllers[reuseIdentify];
    }
    
    [cell addSubview:vc.view];
    return cell;
}

#pragma mark ------ UICollectionViewDelegate
#pragma mark ------ UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        [self.channelView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        [self.channelView scrollViewDidEndDecelerating:scrollView];
    }
}
@end
