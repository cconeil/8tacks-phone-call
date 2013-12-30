//
//  ChoiceView.m
//  Tag
//
//  Created by Chris O'Neil on 12/5/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import "ChoiceView.h"

@implementation ChoiceView


-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    if (self) {
        [self setParams];
        [self style];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setParams];
        [self style];
    }
    return self;
}


-(void)style {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingWidth, paddingHeight / 6, kWidth - 2 * paddingWidth, paddingHeight / 2)];
    self.titleLabel.text = @"Recent Contacts";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:paddingHeight / 4];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    self.blur = [[UIToolbar alloc] initWithFrame:self.bounds];
    self.blur.barStyle = UIBarStyleBlackTranslucent;
    self.blur.alpha = 1;
    [self insertSubview:self.blur atIndex:0];
}


-(void)setParams {
    gestures = [NSMutableArray arrayWithCapacity:kChoiceViewNumRows * kChoiceViewNumSections];
    float fWidth = self.frame.size.width, fHeight = self.frame.size.height;
    
    paddingHeight = fHeight * .2; // 20% padding on the top and bottom
    paddingWidth = fWidth * .075; // 10% padding on either side
    width = (kWidth - paddingWidth * 4) / kChoiceViewNumRows;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedBackground:)];
    [self addGestureRecognizer:tap];
}


// touched the background (not one of the views)
-(IBAction)touchedBackground:(id)sender {
    [self.delegate choiceViewDidDismiss:self];
}


// empty all of the views except for the titleLabel and the blur
// remove all of the current gestures as well.
-(void)empty {
    for (UIView *subview in self.subviews) {
        if (subview == self.blur || subview == self.titleLabel) {
            continue;
        }
        [subview removeFromSuperview];
    }
    gestures = [NSMutableArray arrayWithCapacity:kChoiceViewNumRows * kChoiceViewNumSections];
}


// reload the data in the view
-(void)reload {
    [self empty];
    CGRect r;
    r.size.width = width;
    r.origin.x = paddingWidth;
    r.origin.y = paddingHeight;
    
    int tot = 0;
    for (int i = 0; i < kChoiceViewNumRows; i++) {
        height = [self.delegate choiceView:self getHeightForRow:(NSInteger)i];
        r.size.height = height;
        for (int j = 0; j < kChoiceViewNumSections; j++) {
            [self addButton:r buttonNumber:tot];
            r.origin.x += (width + paddingWidth);
            tot++;
        }
        r.origin.x = paddingWidth;
        r.origin.y += (height + paddingHeight / 10);
    }
}


-(void)addButton:(CGRect)frame buttonNumber:(NSInteger)i {
    UIView *view = [self.delegate choiceView:self viewAtIndexPath:[ChoiceView indexPathFromIndex:i] withFrame:frame];
    if (view) {
        // add the gestures
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [view addGestureRecognizer:tap];
        [gestures insertObject:tap atIndex:i];
        [self addSubview:view];
    }
}


// fired when any of the gesture recognizers attached to people are tapped.
-(void)tapped:(UITapGestureRecognizer *)tap {
    NSInteger numChoices = kChoiceViewNumRows * kChoiceViewNumSections;
    for (NSInteger i = 0; i < numChoices; i++) {
        
        if (tap == [self->gestures objectAtIndex:i]) {
            NSIndexPath *indexPath = [ChoiceView indexPathFromIndex:i];
            [self.delegate choiceView:self didPressAtIndexPath:indexPath];
            return;
        }
    }
}


// converts an an integer (like index of an array) into an indexPath
+(NSIndexPath *)indexPathFromIndex:(NSInteger)i {
    int section = i % kChoiceViewNumSections;
    NSInteger row = i / kChoiceViewNumRows;
    return [NSIndexPath indexPathForRow:row inSection:section];
}


// converts an indexPath into an index (like index of an array)
+(NSInteger)indexFromIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section, row = indexPath.row;
    return section + row * kChoiceViewNumSections;
}

@end
