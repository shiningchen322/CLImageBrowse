//
//  ViewController.m
//  CLImageBrowse
//
//  Created by Shining on 2016/12/16.
//  Copyright © 2016年 Shining. All rights reserved.
//

#import "ViewController.h"
#import "CLPictureViewController.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *checkButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _checkButton = [[UIButton alloc]initWithFrame:CGRectMake( 50, 200, 200, 200)];
    _checkButton.backgroundColor = [UIColor redColor];
    [_checkButton setTitle:@"Click Here" forState:UIControlStateNormal];
    [_checkButton addTarget:self action:@selector(checkPicturesAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkButton];
    
    
    
}

- (void)checkPicturesAction {

    CLPictureViewController *pictureVC = [[CLPictureViewController alloc]init];
    [self.navigationController pushViewController:pictureVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
