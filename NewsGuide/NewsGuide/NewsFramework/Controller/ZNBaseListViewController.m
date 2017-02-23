//
//  MEHomeListViewController.m
//  mrenApp
//
//  Created by zhouen on 16/12/1.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "ZNBaseListViewController.h"


@interface ZNBaseListViewController ()
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation ZNBaseListViewController

#pragma mark ------ Lifecycle
-(instancetype)init{
    return  [super initWithCollectionViewLayout:self.layout];
}
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark ------ setter getter
- (UICollectionViewFlowLayout *)layout {
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumLineSpacing = 10;
        _layout.sectionInset  = UIEdgeInsetsMake(20, 10, 20, 10);
    }
    return _layout;
}

#pragma mark ------ Public

#pragma mark ------ Private

#pragma mark ------ Protocol
    
#pragma mark ------ UITextFieldDelegate
#pragma mark ------ UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    return cell;
}

-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
