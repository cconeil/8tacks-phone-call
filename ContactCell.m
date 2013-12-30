//
//  ContactCell.m
//  Tag
//
//  Created by Billy Irwin on 11/1/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import "ContactCell.h"
#import "HomeViewController.h"

@implementation ContactCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.delta = 0;
        // Initialization code
        
//        self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 350, 40, 40)];
//        self.editBtn.backgroundColor = [UIColor blackColor];
//        [self.editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//        
    
        self.backgroundColor = [UIColor whiteColor];

        self.selectionStyle = UITableViewCellSeparatorStyleNone;

        // create views to swipe right and swipe left with images.
        self.swipeRightView = [[UIView alloc] initWithFrame:CGRectMake(-1 * kWidth, 0, kWidth, 60)];
        self.swipeRightView.backgroundColor = kClearColor;
        self.swipeLeftView = [[UIView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, 60)];
        self.swipeLeftView.backgroundColor = kClearColor;
        [self addSubview:self.swipeRightView];
        [self addSubview:self.swipeLeftView];
        
        self.swipeRightImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - 70, 0, kContactCellHeight, kContactCellHeight)];
        self.swipeLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kContactCellHeight, kContactCellHeight)];
        [self.swipeRightView addSubview:self.swipeRightImg];
        [self.swipeLeftView addSubview:self.swipeLeftImg];
        
        textImg = [UIImage imageNamed:@"tag-text.png"];
        tagImg = [UIImage imageNamed:@"tag-tag.png"];
        callImg = [UIImage imageNamed:@"tag-call.png"];
        remindImg = [UIImage imageNamed:@"tag-remind.png"];
        
        self.cfVC = [[ContactFormViewController alloc] initWithFrame:kFullOnScreen];
        self.contactForm = self.cfVC.view;
        self.cfVC.canEdit = false;
        [self addSubview:self.contactForm];
        
        self.swipeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        [self addSubview:self.swipeView];
        
//        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kHeight-60, kWidth, 30)];
//        self.backBtn.backgroundColor = [UIColor blueColor];
//        [self addSubview:self.backBtn];
        
        self.clipsToBounds = YES;
        
        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        gestureRecognizer.minimumPressDuration = 0.02;
        [self.swipeView addGestureRecognizer:gestureRecognizer];
        
        CGFloat bottomCell = 220 + self.cfVC.contactInfo.count * kContactFormCellHeight;
        
        self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bottomCell+60, kWidth/2, 60)];
        [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:kLightBlue(1) forState:UIControlStateNormal];
        //self.editBtn.backgroundColor = kLightBlue(0.7);
        [self.contactForm.tableView addSubview:self.editBtn];
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2, bottomCell+60, kWidth/2, 60)];
        [self.deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:kLightRed(1) forState:UIControlStateNormal];
        //self.deleteBtn.backgroundColor = kLightRed(0.7);
        [self.contactForm.tableView addSubview:self.deleteBtn];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)edit:(id)sender
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.contactForm renderFormForContact:self.contact andIsEditable:!self.contactForm.isEditable];
//    }];
//}


- (IBAction)call:(id)sender {
    [self.delegate call:self.contact];
}


- (void)addPhone:(NSString*)phone
{
    
}


- (void)addEmail:(NSString*)email
{
    
}


-(CGPoint)getLoc {
    return self.frame.origin;
}


-(CGFloat)getDelta:(CGPoint)p {
    self.delta += abs(p.x - touch);
    return p.x - touch;
}

#define kTextLimit 80
#define kCallLimit 200
#define kTagLimit -80
#define kRemindLimit -200
-(void)setLoc:(CGFloat)d changeImg:(BOOL)change duration:(CGFloat)t {
    CGPoint o = self.contactForm.frame.origin;
    CGSize s = self.contactForm.frame.size;
    BOOL swipingRight, swipingLeft;
    
    if (d > 0) {
        swipingRight = YES, swipingLeft = NO;
        if (d < kTextLimit) {
            self.swipeRightView.backgroundColor = kClearColor;
            if (change) self.swipeRightImg.image = textImg;
        } else if (d > kCallLimit) {
            self.swipeRightView.backgroundColor = kGreen(1); //kLightBlue(1);//d/kWidth);
            if (change) self.swipeRightImg.image = callImg;
        } else {
            self.swipeRightView.backgroundColor = kLightBlue(1);//d/kWidth * .8);
            if (change) self.swipeRightImg.image = textImg;
        }
    } else {
        swipingLeft = YES, swipingRight = NO;
      if (d > kTagLimit) {
            self.backgroundColor = [UIColor clearColor];
            if (change) self.swipeLeftImg.image = tagImg;
        } else if (d < kRemindLimit) {
            self.swipeLeftView.backgroundColor = kLightRed(1);// - (kWidth + d)/kWidth);
            if (change) self.swipeLeftImg.image = remindImg;
        } else {
            self.swipeLeftView.backgroundColor = kYellow(1);// - (kWidth + d)/kWidth)*.8);
            if (change) self.swipeLeftImg.image = tagImg;
        }
    }
    
    [UIView animateWithDuration:t animations:^{
        [self.contactForm setFrame:CGRectMake(d, o.y, s.width, s.height)];
        [self.swipeLeftView setFrame:CGRectMake(d+kWidth, 0, kWidth, kContactCellHeight)];
        [self.swipeRightView setFrame:CGRectMake(d-kWidth, 0, kWidth, kContactCellHeight)];
    }];
}

-(void)finishSwipe {
    CGPoint o = self.contactForm.frame.origin;
    if (o.x > kTextLimit) {
        [self setLoc:kWidth changeImg:NO duration:0.3];
        if (o.x < kCallLimit) {
            // text
            [self.delegate text:self.contact];
        } else {
            // call
            [self.delegate call:self.contact];
        }
    } else if (o.x < kTagLimit) {
        [self setLoc:kWidth*-1 changeImg:NO duration:0.3];
        if (o.x > kRemindLimit) {
            // tag
            [self.delegate tag:self.contact];
        } else {
            // remind
            [self.delegate remind:self.contact];
        }
        
    } else {
        [self setLoc:0.0 changeImg:NO duration:0.3];
    }

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.contactForm setFrame:CGRectMake(0, 0, self.contactForm.frame.size.width, self.contactForm.frame.size.height)];
        [self.swipeLeftView setFrame:CGRectMake(kWidth, 0, kWidth, kContactCellHeight)];
        [self.swipeRightView setFrame:CGRectMake(-1 * kWidth, 0, kWidth, kContactCellHeight)];
    });
}


- (void)swipe:(UILongPressGestureRecognizer *)longPress
{
    if (self.frame.size.height <= kContactCellHeight + 5.0) { // don't allow swipes unless smalll
        CGPoint p;
        if (longPress.state == UIGestureRecognizerStateBegan) {
            CGPoint t = [longPress locationInView:self];
            self.delta = 0;
            touch = t.x;
        } else if (longPress.state == UIGestureRecognizerStateChanged) {
            p = [longPress locationInView:self];
            [self setLoc:[self getDelta:p] changeImg:YES duration:0.0001];
        } else {
            if (self.delta < 2) {
                HomeViewController *h = (HomeViewController*)self.homeVC;
                [self.homeVC tableView:h.view.contactTableView didSelectRowAtIndexPath:self.indexPath];
            } else {
                [self finishSwipe];
            }
        }
    }
}

- (UIButton*)createButtn:(NSString*)social at:(float)x and:(float)y
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 35, 35)];
    [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", social]] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 18;
    btn.layer.masksToBounds = YES;
    //[self.detailView addSubview:btn];
    [self addSubview:btn];
    return btn;
}

- (void)renderCell:(Contact *)c
{
    self.contact = c;
    [self.cfVC renderContact:c];
    
    CGFloat bottomCell = 220 + self.cfVC.contactInfo.count * kContactFormCellHeight;
    
    self.editBtn.frame = CGRectMake(0, bottomCell+60, kWidth/2, 60);
    
    self.deleteBtn.frame = CGRectMake(kWidth/2, bottomCell+60, kWidth/2, 60);
}


@end

