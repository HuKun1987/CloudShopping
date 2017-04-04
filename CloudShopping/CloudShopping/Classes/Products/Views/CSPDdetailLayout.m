//
//  CSPDdetailLayout.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSPDdetailLayout.h"

@implementation CSPDdetailLayout
-(void)prepareLayout{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 1;
    self.sectionInset = UIEdgeInsetsZero;
    CGFloat itemHW = (self.collectionView.bounds.size.width - self.minimumLineSpacing - self.sectionInset.left-self.sectionInset.right) *0.5;
    self.itemSize = CGSizeMake(itemHW, itemHW*1.2);
  
}
@end
