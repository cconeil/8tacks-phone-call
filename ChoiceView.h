//
//  ChoiceView.h
//  Tag
//
//  Created by Chris O'Neil on 12/5/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Components.h"



@interface ChoiceView : UIView {
    NSMutableArray *gestures;
    float paddingHeight, paddingWidth, height, width;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UILabel *titleLabel;
@property (weak, nonatomic) id delegate;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIToolbar *blur;

-(void)reload;
-(void)empty;

+(NSIndexPath *)indexPathFromIndex:(NSInteger)i;
+(NSInteger)indexFromIndexPath:(NSIndexPath *)indexPath;

@end


// ChoiceViewDelegate Protocol
@protocol ChoiceViewDelegate <NSObject>

-(UIView *)choiceView:(ChoiceView *)choiceView viewAtIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame;
-(void)choiceView:(ChoiceView *)choiceView didPressAtIndexPath:(NSIndexPath *)indexPath;
-(void)choiceViewDidDismiss:(ChoiceView *)choiceView;
-(CGFloat)choiceView:(ChoiceView *)choiceView getHeightForRow:(NSInteger)row;

@end