//
//  HomeViewController.h
//  Tag
//
//  Created by Billy Irwin on 10/26/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeView.h"
#import "CHActivityEllipses.h"
#import "ContactCell.h"
#import "Contact.h"
#import "ProfileView.h"
#import "MasterViewController.h"
#import "Constants.h"
#import "BaseViewController.h"
#import "UIColor+Tag.h"
#import "TagQueue.h"
#import "PlaceholderView.h"

@interface HomeViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ContactCellDelegate, ChoiceViewDelegate>

@property (strong, nonatomic) HomeView *view;
@property (strong, nonatomic) TagQueue *recentContacts;
@property (nonatomic) int chosenRow;
@property (nonatomic) int chosenSection;
@property (nonatomic) unsigned int counter;
@property (nonatomic) BOOL fullScreen;
@property (nonatomic) BOOL coverViewOpen;
@property (strong, nonatomic) UIImage *placeHolderImage;

- (void)displayRecentContacts;
- (void)hideRecentContacts;

@end
