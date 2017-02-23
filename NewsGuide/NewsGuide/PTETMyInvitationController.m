//
//  PTETMyInvitationController.m
//  SystemTabBar
//
//  Created by zhouen on 17/2/13.
//  Copyright © 2017年 zn. All rights reserved.
//

#import "PTETMyInvitationController.h"
#import "PTETGuideView.h"

@interface PTETMyInvitationController ()<UICollectionViewDelegate,UICollectionViewDataSource,GuideViewDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PTETGuideView *guideView;

@end

static NSString *const reuserIdentifer = @"collectionCell";
@implementation PTETMyInvitationController

#pragma mark ------ Lifecycle

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setupSubview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"我的帖子";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ------ setter getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuserIdentifer];
        
        // 设置cell的大小和细节
        flowLayout.itemSize = _collectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        self.flowLayout = flowLayout;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

#pragma mark ------ Public


#pragma mark ------ Private
- (void)p_setupSubview {
    //引导菜单
    self.guideView = [PTETGuideView guideViewWithSelectColor:[UIColor purpleColor]];
    _guideView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    _guideView.delegate = self;
    _guideView.backgroundColor = [UIColor whiteColor];
    _guideView.channels = @[@"起的",@"我回的",@"我回复的",@"我的",@"回复的",@"复的"];
    [self.view addSubview:_guideView];
    
    //collectionView
    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.and.bottom.equalTo(self.view);
//        make.top.mas_equalTo(self.guideView.mas_bottom);
//    }];
}


#pragma mark ------ Protocol
- (void)guideView:(PTETGuideView *)guideView didSelectIndex:(NSUInteger)index {
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
#pragma mark ------ UITextFieldDelegate
#pragma mark ------ UITableViewDataSource
#pragma mark ------ UITableViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _guideView.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifer forIndexPath:indexPath];
    
    return cell;
    
}
#pragma mark ------ UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        [self.guideView scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        [self.guideView scrollViewDidScroll:scrollView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, self.guideView.frame.size.height + 64, self.view.frame.size.width, self.view.frame.size.height);
    self.flowLayout.itemSize = self.collectionView.bounds.size;
}

#pragma mark ------ Override


@end
