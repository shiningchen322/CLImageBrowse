//
//  CLPictureViewController.m
//  CLImageBrowse
//
//  Created by Shining on 2016/12/16.
//  Copyright © 2016年 Shining. All rights reserved.
//

#import "CLPictureViewController.h"
#import "CLPictureCell.h"
#import "Masonry.h"

// 屏幕宽高
#define kWidth   ([UIScreen mainScreen].bounds.size.width)
#define kHeight  ([UIScreen mainScreen].bounds.size.height)


@interface CLPictureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CLPictureCellDelegate>



@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isHideNav;


@end

@implementation CLPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewLayout];
    
    _isHideNav = NO;
    
    [self.collectionView reloadData];
    
}


- (void)viewLayout {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kWidth, kHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"CLPictureCell" bundle:nil] forCellWithReuseIdentifier:[CLPictureCell reuseId]];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-62);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

//调用保存到相册方法
- (void)saveToAblumActionWithIndex:(NSIndexPath *)index{
    
    CLPictureCell *cell =
    (CLPictureCell *)[_collectionView cellForItemAtIndexPath:index];
    UIImageWriteToSavedPhotosAlbum(cell.picImageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//保存到相册的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if(error != NULL){
        //保存图片失败
//        [self.view showNoticeViewWithTitle:nil message:ZLString(@"poster_save_failed") duration:0];
        NSLog(@"保存图片失败");
        
    }else{
        //保存图片成功
//        [self.view showNoticeViewWithTitle:nil message:ZLString(@"poster_save_success") duration:0];
        NSLog(@"保存图片成功");
    }
}

#pragma mark - CLPictureCellDelegate
- (void)pictureCollectionViewSingleTap
{
    _isHideNav  = !_isHideNav;
    
    //隐藏或显示导航栏
    [UIView animateWithDuration:0.2 animations:^{

        self.navigationController.navigationBar.alpha = _isHideNav? 0 : 1;
       
    }];
}

//图片长按方法
- (void)pictureLongPressAction:(UILongPressGestureRecognizer *)longPressGesture {
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPressGesture locationInView:_collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *saveToAlbum = [UIAlertAction actionWithTitle:@"Save it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveToAblumActionWithIndex:indexPath];
            }];
            [alertController addAction:saveToAlbum];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancel];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CLPictureCell reuseId] forIndexPath:indexPath];
    cell.cellDelegate = self;
    
    [cell configCellDataWithPictureImage:nil];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
