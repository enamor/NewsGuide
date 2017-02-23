//
//  ViewController.m
//  NewsGuide
//
//  Created by zhouen on 16/12/15.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = @[@"ssss",@"sssss",@"dfefefefefe",@"中华人民",@"中华人民",@"中华人民",@"中华人民",@"中华人民",@"中华人民",@"中华人民",@"中华人民"];
    self.titles = self.data;
    // Do any additional setup after loading the view, typically from a nib.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifer forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *reuseIdentify = @(indexPath.row).stringValue;
    ListViewController * vc;
    if (!self.viewControllers[reuseIdentify]) {
        vc= [[ListViewController alloc] init];
        [self addChildViewController:vc];
        [self.viewControllers setObject:vc forKey:reuseIdentify];
        
    } else {
        vc= self.viewControllers[reuseIdentify];
        [cell addSubview:vc.view];
    }
    vc.view.frame = cell.bounds;
    [cell addSubview:vc.view];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
