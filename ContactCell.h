//
//  ContactCell.h
//  Tag
//
//  Created by Billy Irwin on 11/1/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactFormViewController.h"


@protocol ContactCellDelegate <NSObject>

-(void)call:(Contact *)contact;
-(void)text:(Contact *)contact;
-(void)tag:(Contact *)contact;
-(void)remind:(Contact *)contact;

@end


@interface ContactCell : UITableViewCell {
    CGFloat touch;
    UIImage *textImg, *tagImg, *callImg, *remindImg;
}

//@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *swipeRightView;
@property (strong, nonatomic) UIView *swipeLeftView;
@property (nonatomic) CGFloat delta;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *swipeView;
@property (weak, nonatomic) id homeVC;
@property (weak, nonatomic) ContactFormView *contactForm;
@property (strong, nonatomic) ContactFormViewController *cfVC;


@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIButton *editBtn;

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) UIImageView *swipeRightImg;
@property (strong, nonatomic) UIImageView *swipeLeftImg;

@property (nonatomic) int height;
@property (weak, nonatomic) Contact *contact;

- (void)renderCell:(Contact*)c;


@end
