//
//  ViewController.m
//  NKTrimmingController
//
//  Created by t-tazoe on 2015/07/01.
//  Copyright (c) 2015年 nanoka____. All rights reserved.
//

#import "ViewController.h"
#import "NKTrimmingController.h"

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,NKTrimmingControllerDelegate>
@end


/*========================================================
 ; ViewController
 ========================================================*/
@implementation ViewController{
    UIImageView *imageView;
}

/*--------------------------------------------------------
 ; dealloc : 解放
 ;      in :
 ;     out :
 --------------------------------------------------------*/
-(void)dealloc
{
    imageView = nil;
}

/*--------------------------------------------------------
 ; viewDidLoad : 初回Viewが読み込まれた時
 ;          in :
 ;         out :
 --------------------------------------------------------*/
-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, self.view.frame.size.height-50-10-10-[UIApplication sharedApplication].statusBarFrame.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    UIButton *naviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    naviButton.frame = CGRectMake((self.view.frame.size.width/2-110)/2, self.view.frame.size.height-50-10, 110, 50);
    naviButton.titleLabel.numberOfLines = 2;
    naviButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [naviButton setTitle:@"UINavigation\nController" forState:UIControlStateNormal];
    [naviButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [naviButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [naviButton addTarget:self action:@selector(naviButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:naviButton];
    
    UIButton *modalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modalButton.frame = CGRectMake(self.view.frame.size.width/2+(self.view.frame.size.width/2-110)/2, self.view.frame.size.height-50-10, 110, 50);
    modalButton.titleLabel.numberOfLines = 2;
    modalButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [modalButton setTitle:@"UIView\nController" forState:UIControlStateNormal];
    [modalButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [modalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [modalButton addTarget:self action:@selector(modalButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modalButton];
}

/*--------------------------------------------------------
 ; naviButtonTaped : ボタンが押された
 ;              in : (UIButton *)button
 ;             out :
 --------------------------------------------------------*/
-(void)naviButtonTaped:(UIButton *)button
{
    // インタフェース使用可能なら
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
        // UIImageControllerの初期化
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.allowsEditing = NO;
        [self presentViewController:ipc animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can not use the PhotoLibrary"
                                                        message:@"フォトライブラリが使用できません。"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

/*--------------------------------------------------------
 ; modalButtonTaped : ボタンが押された
 ;               in : (UIButton *)button
 ;              out :
 --------------------------------------------------------*/
-(void)modalButtonTaped:(UIButton *)button
{
    NKTrimmingController *oTrimmingController = [[NKTrimmingController alloc] initWithImage:[UIImage imageNamed:@"sample"] delegate:self];
    [self presentViewController:oTrimmingController animated:YES completion:nil];
}

/*========================================================
 ; UIImagePickerControllerDelegate
 ========================================================*/
/*--------------------------------------------------------
 ; didFinishPickingMediaWithInfo : ライブラリの画像が選択された
 ;                            in : (UIImagePickerController *)picker
 ;                               : (NSDictionary *)info
 ;                           out :
 --------------------------------------------------------*/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 選択したイメージをimageにセットする
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NKTrimmingController *oTrimmingController = [[NKTrimmingController alloc] initWithImage:image delegate:self];
    [picker pushViewController:oTrimmingController animated:YES];
}

/*--------------------------------------------------------
 ; imagePickerControllerDidCancel : ライブラリのキャンセルボタンが押された
 ;                             in : (UIImagePickerController *)picker
 ;                            out :
 --------------------------------------------------------*/
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // フォトライブラリを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*========================================================
 ; UIImagePickerControllerDelegate
 ========================================================*/
/*--------------------------------------------------------
 ; didFinishTrimmingImage : 画像がトリミングされた
 ;                     in : (NKTrimmingController *)trimming
 ;                        : (UIImage *)image
 ;                    out :
 --------------------------------------------------------*/
-(void)trimmingController:(NKTrimmingController *)trimming didFinishTrimmingImage:(UIImage *)image
{
    //トリミング画像を判定
    imageView.image = image;
    //トリミングを開いたフォトライブラリを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*--------------------------------------------------------
 ; NKTrimmingControllerDidCancel : トリミングのキャンセルボタンが押された
 ;                          in : (NKTrimmingController *)trimming
 ;                         out :
 --------------------------------------------------------*/
-(void)trimmingControllerDidCancel:(NKTrimmingController *)trimming
{
    //トリミングを閉じる
    [trimming dismissViewControllerAnimated:YES completion:nil];
}

@end
