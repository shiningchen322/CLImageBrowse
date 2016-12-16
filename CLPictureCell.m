//
//  CLPictureCell.m
//  CLImageBrowse
//
//  Created by Shining on 2016/12/16.
//  Copyright © 2016年 Shining. All rights reserved.
//

#import "CLPictureCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

// 屏幕宽高
#define kWidth   ([UIScreen mainScreen].bounds.size.width)
#define kHeight  ([UIScreen mainScreen].bounds.size.height)

//图片缩放比例
#define kMinZoomScale 1.0f
#define kMaxZoomScale 3.0f

@interface CLPictureCell ()

@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation CLPictureCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:_scrollView];
    
    _picImageV = [[UIImageView alloc]init];
    _picImageV.userInteractionEnabled = NO;
    [_scrollView addSubview:_picImageV];
    
}

- (UILongPressGestureRecognizer *)longPress
{
    if(_longPress == nil){
        _longPress =  [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    }
    return _longPress;
}

- (UITapGestureRecognizer *)singleTap
{
    if(_singleTap == nil){
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        [_singleTap requireGestureRecognizerToFail:_doubleTap];
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

#pragma mark 长按
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    if([self.cellDelegate respondsToSelector:@selector(pictureLongPressAction:)]){
        [self.cellDelegate pictureLongPressAction:recognizer];
    }
}

#pragma mark 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    
    if([self.cellDelegate respondsToSelector:@selector(pictureCollectionViewSingleTap)]){
        [self.cellDelegate pictureCollectionViewSingleTap];
    }
}

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    
    CGPoint touchPoint = [recognizer locationInView:self];
    if (_scrollView.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + _scrollView.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + _scrollView.contentOffset.y;//需要放大的图片的Y点
        [_scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [_scrollView setZoomScale:1.0 animated:YES]; //还原
    }
    
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    CGPoint imgF = [self.picImageV convertPoint:point fromView:self];
    if([self.picImageV pointInside:imgF withEvent:event]){
        return self.picImageV;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _picImageV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    _picImageV.center = [self centerOfScrollViewContent:scrollView];
    
}

- (void)setImageWithURL:(NSString *)urlStr
{
    
    [_scrollView setZoomScale:1.0 animated:YES];
    _picImageV.frame = CGRectMake(0, 0,kWidth, kHeight);
    //移除图片上的手势
    [_picImageV removeGestureRecognizer:self.doubleTap];
    [_picImageV removeGestureRecognizer:self.singleTap];
    [_picImageV removeGestureRecognizer:self.longPress];
    
    __weak typeof(self)weakSelf = self;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (!image) {
            return ;
        }
        
        weakSelf.picImageV.contentMode = UIViewContentModeScaleAspectFit;
        
        CGSize imageSize = image.size;
        //图片首次出现在屏幕上的宽和高
        CGFloat oldWidth = kWidth;
        CGFloat oldHeight = kWidth*imageSize.height/imageSize.width;

        _picImageV.frame = CGRectMake(0, 0,oldWidth, oldHeight);
        _scrollView.contentSize = CGSizeMake(kWidth, kHeight);

        _picImageV.center = [self centerOfScrollViewContent:_scrollView];
        
        if (image) {
            self.picImageV.userInteractionEnabled = YES;
            [_picImageV addGestureRecognizer:self.doubleTap];
            [_picImageV addGestureRecognizer:self.singleTap];
            [_picImageV addGestureRecognizer:self.longPress];
        }
        
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = kMaxZoomScale;
    _scrollView.minimumZoomScale = kMinZoomScale;
    
}

- (void)configCellDataWithPictureImage:(NSString *)imageURL {
    
    [self setImageWithURL:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1481867581&di=4d5d7b1daede15a4425f18651434f9b4&src=http://img0.ilvxing.com/item/201410/10/5437b5643e7a8.jpg"];
    
    
}


+ (NSString *)reuseId {
    return @"CLPictureCellId";
}

@end
