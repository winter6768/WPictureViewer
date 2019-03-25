//
//  WPictureViewer.m
//  WPictureViewer
//
//  Created by winter on 2019/3/22.
//  Copyright © 2019 winter. All rights reserved.
//

#import "WPictureViewer.h"
#import "WPictureViewerCell.h"
#import "WPictureViewerUtil.h"

@interface WPictureViewer ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/// UICollectionView
@property(nonatomic,strong)UICollectionView *myCollectionView;
/// 标题
@property(nonatomic,strong)UILabel *lab_title;
/// 图片总个数
@property(nonatomic,assign)NSInteger itemCount;
@end

@implementation WPictureViewer

#pragma mark - life cycle

#pragma mark - public methods
-(void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    self.backgroundColor = [UIColor blackColor];
    [window addSubview:self];
    [self buildSubviews];
    
    switch (self.animationType) {
        case WPictureViewerAnimationScale:
            if ([self.delegate respondsToSelector:@selector(imageViewForIndex:)]) {
                UIImageView *sourceImageView = [self.delegate imageViewForIndex:self.currentIndex];
                if (sourceImageView) {
                    [self animationShow:sourceImageView];
                }
            }
            break;
            
        case WPictureViewerAnimationAlpha:
            [self alphaShow];
            break;
            
        default:
            break;
    }
}

#pragma mark - collectionDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.itemCount = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfItems)]) {
        self.itemCount = [self.delegate numberOfItems];
    }
    return self.itemCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WPictureViewerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPictureViewerCell" forIndexPath:indexPath];
    id source = nil;
    if ([self.delegate respondsToSelector:@selector(imageSourceForIndex:)]) {
        source = [self.delegate imageSourceForIndex:indexPath.item];
    }
    cell.imageSource = source;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    WPictureViewerCell *imageCell = (WPictureViewerCell *)cell;
    [imageCell clearScale];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.myCollectionView) {
        return;
    }
    
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    if (index == self.currentIndex) {
        return;
    }
    self.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(pictureViewerIndexDidChange:)]) {
        [self.delegate pictureViewerIndexDidChange:self.currentIndex];
    }
    
    if (self.lab_title) {
        self.lab_title.text = [NSString stringWithFormat:@"%d/%d",(int)self.currentIndex + 1,(int)self.itemCount];
    }
}

#pragma mark - CustomDelegate

#pragma mark - event response
-(void)singleTap:(UITapGestureRecognizer *)tap {
    switch (self.animationType) {
        case WPictureViewerAnimationScale:
            if ([self.delegate respondsToSelector:@selector(imageViewForIndex:)]) {
                UIImageView *sourceImageView = [self.delegate imageViewForIndex:self.currentIndex];
                if (sourceImageView) {
                    [self animationHidden:sourceImageView];
                    
                } else {
                    [self removeFromSuperview];
                }
                
            } else {
                [self removeFromSuperview];
            }
            break;
            
        case WPictureViewerAnimationAlpha:
            [self alphaHidden];
            break;
            
        default:
            [self removeFromSuperview];
            break;
    }
}

-(void)doubleTap:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:tap.view];
    NSIndexPath *indexPath = [self.myCollectionView indexPathForItemAtPoint:touchPoint];
    WPictureViewerCell *cell = (WPictureViewerCell *)[self.myCollectionView cellForItemAtIndexPath:indexPath];
    [cell doubleTap:[tap locationInView:cell]];
}

#pragma mark - animation
-(void)animationShow:(UIImageView *)sourceImageView {
    self.myCollectionView.hidden = YES;
    self.lab_title.hidden = YES;
    
    UIImageView *imageNew = [UIImageView new];
    imageNew.image = sourceImageView.image;
    imageNew.contentMode = sourceImageView.contentMode;
    imageNew.clipsToBounds = YES;
    [self addSubview:imageNew];
    
    CGRect start = [sourceImageView.superview convertRect:sourceImageView.frame toView:self];
    imageNew.frame = start;
    CGRect end = [WPictureViewerUtil resizedFrameForImageSize:sourceImageView.image.size];
    
    [UIView animateWithDuration:.4 animations:^{
        imageNew.frame = end;
        
    } completion:^(BOOL finished) {
        self.lab_title.hidden = NO;
        self.myCollectionView.hidden = NO;
        [imageNew removeFromSuperview];
    }];
}

-(void)animationHidden:(UIImageView *)sourceImageView {
    UIImageView *imageNew = [UIImageView new];
    imageNew.image = sourceImageView.image;
    imageNew.contentMode = sourceImageView.contentMode;
    imageNew.clipsToBounds = YES;
    [self addSubview:imageNew];
    
    CGRect start = [WPictureViewerUtil resizedFrameForImageSize:sourceImageView.image.size];
    imageNew.frame = start;
    CGRect end = [sourceImageView.superview convertRect:sourceImageView.frame toView:self];
    
    self.myCollectionView.hidden = YES;
    self.lab_title.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:.4 animations:^{
        imageNew.frame = end;
        
    } completion:^(BOOL finished) {
        [imageNew removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)alphaShow {
    self.alpha = .1;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

-(void)alphaHidden {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = .1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - private methods
-(void)buildSubviews {
    CGRect rect = self.bounds;
    rect.origin.x -= self.itemSpace / 2.0;
    rect.size.width += self.itemSpace;
    
    UICollectionViewFlowLayout * viewLayout = [[UICollectionViewFlowLayout alloc]init];
    viewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    viewLayout.itemSize = rect.size;
    viewLayout.minimumLineSpacing = 0;
    
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:viewLayout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.exclusiveTouch = YES;
    self.myCollectionView.pagingEnabled = YES;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    self.myCollectionView.backgroundColor = [UIColor blackColor];
    [self.myCollectionView registerClass:[WPictureViewerCell class] forCellWithReuseIdentifier:@"WPictureViewerCell"];
    [self addSubview:self.myCollectionView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.myCollectionView addGestureRecognizer:singleTap];
    [self.myCollectionView addGestureRecognizer:doubleTap];
    
    
    if (self.currentIndex >= 0) {
        [self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    if (self.showIndexTitle) {
        self.lab_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
        self.lab_title.textColor = [UIColor whiteColor];
        self.lab_title.textAlignment = NSTextAlignmentCenter;
        self.lab_title.font = [UIFont systemFontOfSize:15];
        self.lab_title.text = [NSString stringWithFormat:@"%d/%d",(int)self.currentIndex + 1,(int)self.itemCount];
        [self addSubview:self.lab_title];
    }
}

#pragma mark - getters and setters

@end
