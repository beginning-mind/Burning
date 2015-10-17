//
//  TakePhotoViewController.m
//  Burning
//
//  Created by wei_zhu on 15/6/3.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "BurningNavControl.h"
#import "BuringTabBarController.h"
#import "PubShowPhotoCollectionViewCell.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import <STAlertView/STAlertView.h>
#import "XHImageViewer.h"

@interface TakePhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate>

//@property (strong,nonatomic) XHPhotographyHelper* photographyHelper;

@property(strong,nonatomic)STAlertView *alertView;

@end

static NSString* photoCellIndentifier=@"takePhotocell";

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.showTabbar = NO;
    [self setNavgationBar];
    
    [self initTextView];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing =3.0f;
    layout.minimumLineSpacing = 3.0f;
    layout.sectionInset =UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionViewPhotos.collectionViewLayout = layout;
    [self.collectionViewPhotos registerClass:[PubShowPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCellIndentifier];
    self.collectionViewPhotos.dataSource = self;
    self.collectionViewPhotos.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavgationBar{
    [self.navigationItem setTitle:@"发布"];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(publishClick:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)callCameraAndPhoto{

    UIAlertView *uiAlertView= [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"拍照",@"从相册选择", nil];
    [uiAlertView show];
}

-(void)initTextView{
    self.texViewComment.delegate = self;
    self.texViewComment.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.texViewComment.layer.borderWidth = 0.6f;
    self.texViewComment.layer.cornerRadius = 6.0f;
}

#pragma  mark alterViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex ==1) {
            //删除选择图片
            self.selectPhotos = nil;
            [self.collectionViewPhotos reloadData];
        }
    }
    else{
        if (buttonIndex ==1) {
            //相机拍摄
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = NO;//设置可编辑
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];//进入照相界面
        }
        else if(buttonIndex ==2){
            //手机相册
            MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
            // 默认显示相册里面的内容SavePhotos
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.minCount = 1;
            [pickerVc show];
            __weak typeof(self) weakSelf = self;
            pickerVc.callBack = ^(NSArray *assets){
                //添加返回图片代码
                for(MLSelectPhotoAssets *asset in assets){
                    //                UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                    [self.selectPhotos addObject:asset.originImage];
                }
                [self.collectionViewPhotos reloadData];
            };
        }
    }
}

#pragma mark UIIMagePickerControlDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self.selectPhotos addObject:image];
    [self.collectionViewPhotos reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -action
-(void)publishClick:(UIButton*)button{
    if(self.texViewComment.text.length!=0 || self.selectPhotos.count!=0){
        WEAKSELF
        [weakSelf showProgress];
        weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
        [weakSelf runInGlobalQueue:^{
            NSError* error;
            
            [weakSelf.lcDataHelper publishWithContent:self.texViewComment.text images:self.selectPhotos error:&error];
            [weakSelf runInMainQueue:^{
                [weakSelf hideProgress];
                weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                if(error==nil){
                    
                    if ([_takePhotoViewControllerDelegate respondsToSelector:@selector(refresh)]) {
                        [_takePhotoViewControllerDelegate refresh];
                    }
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakSelf alertError:error];
                }
            }];
        }];
    }else{
        [self alert:@"请完善内容"];
    }
}

-(void)back:(UIButton*)button{
  self.alertView = [[STAlertView alloc]initWithTitle:nil message:@"确定退出本次编辑吗?" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" cancelButtonBlock:^{
  } otherButtonBlock:^{
      [self.navigationController popViewControllerAnimated:YES];
  }];
    [self.alertView show];
}

#pragma mark -Propertys

-(NSMutableArray*)selectPhotos{
    if(_selectPhotos==nil){
        _selectPhotos=[NSMutableArray array];
    }
    return _selectPhotos;
}

#pragma mark -UICollectionView dataSource Delegat
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.selectPhotos.count==1){
        return self.selectPhotos.count;
    }else{
        return self.selectPhotos.count+1;
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PubShowPhotoCollectionViewCell* cell=(PubShowPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:photoCellIndentifier forIndexPath:indexPath];
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if(indexPath.row==self.selectPhotos.count){
        cell.photoImageView.image=[UIImage imageNamed:@"PublisAddBtn"];
        cell.photoImageView.highlightedImage=[UIImage imageNamed:@"PublisAddBtnHL"];
        return cell;
    }else{
        cell.photoImageView.image=self.selectPhotos[indexPath.row];
        cell.photoImageView.highlightedImage=nil;
        
        //delete button
        UIButton *deleteButton  = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)-24, 0, 24, 24)];
        [deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:deleteButton];
        return cell;
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==_selectPhotos.count){
        [self.texViewComment resignFirstResponder];
        [self callCameraAndPhoto];
    }
    else{
            PubShowPhotoCollectionViewCell* photoCell=(PubShowPhotoCollectionViewCell*)[self.collectionViewPhotos cellForItemAtIndexPath:indexPath];
        
            NSArray* visibleCells=self.collectionViewPhotos.visibleCells;
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"indexPath" ascending:YES];
            visibleCells = [visibleCells sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
            NSMutableArray* imageViews=[NSMutableArray array];
            [visibleCells enumerateObjectsUsingBlock:^(PubShowPhotoCollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
        
                [imageViews addObject:cell.photoImageView];
        
            }];
            XHImageViewer* imageViewer=[[XHImageViewer alloc] init];
            [imageViewer showWithImageViews:imageViews selectedView:imageViews[indexPath.row]];
        
//        MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
//        [browserVc setValue:@(YES) forKeyPath:@"isEditing"];
//        browserVc.photos = self.collectionView.selectAsstes;
//        browserVc.selectsIndexPath = self.collectionView.selectsIndexPath;
//        [self.navigationController pushViewController:browserVc animated:YES];
//        MLSelectPhotoAssets *curPhotoAssets = [[MLSelectPhotoAssets alloc]init];
    }
}

#pragma mark UICollectionView FLowLayout Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize finalSize = CGSizeMake(([SVGloble shareInstance].globleWidth-39.0)/4.0, 80);
    return finalSize;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.texViewComment resignFirstResponder];
}

#pragma UITextView Delegate
-(void)textViewDidChange:(UITextView*) textView {
    if (self.texViewComment.text.length ==0) {
        self.placeholderLabel.text = @"说点什么吧";
    }else {
        self.placeholderLabel.text = @"";
    }
}

#pragma mark action
-(void)deleteBtnClick:(UIButton*)button{
    UIAlertView *alterView =[[UIAlertView alloc]initWithTitle:nil message:@"确定删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alterView.tag = 1001;
    [alterView show];
}


@end
