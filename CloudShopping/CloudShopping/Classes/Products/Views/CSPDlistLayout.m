//
//  CSPDlistLayout.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSPDlistLayout.h"
CGFloat itemHeight = 87;
@implementation CSPDlistLayout
- (void)prepareLayout{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsZero;
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right, itemHeight);

}
@end
