//
//  DailyNewsTableViewCell.m
//  Burning
//
//  Created by wei_zhu on 15/7/3.
//  Copyright (c) 2015年 BurningTech. All rights reserved.
//

#import "DailyNewsTableViewCell.h"
#import "DailyNewsRichTextView.h"

@interface DailyNewsTableViewCell()

@property(nonatomic,strong)DailyNewsRichTextView *dailyNewsRichTextView;

@end

@implementation DailyNewsTableViewCell

+(CGFloat)calculateCellHeightWithSHDailyNews:(SHDailyNews *)shDialyNews{
    return [DailyNewsRichTextView calculateRichTextHeightWithSHDailyNews:shDialyNews];
}

- (void)awakeFromNib {
    // Initialization code
}

-(DailyNewsRichTextView*)dailyNewsRichTextView{
    if (_dailyNewsRichTextView==nil) {
        _dailyNewsRichTextView = [[DailyNewsRichTextView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 40)];
    }
    return _dailyNewsRichTextView;
}

-(void)setShDailyNews:(SHDailyNews *)shDailyNews{
    _shDailyNews = shDailyNews;
    _dailyNewsRichTextView.shDailyNews = shDailyNews;
}

-(void)setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.dailyNewsRichTextView];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
