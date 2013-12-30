//
//  HomeViewController.m
//  Tag
//
//  Created by Billy Irwin on 10/26/13.
//  Copyright (c) 2013 Arbrr. All rights reserved.
//

#import "HomeViewController.h"

#define kMenuFrame(X, Y) CGRectMake(X, Y, 180, 180)

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithOnFrame:(CGRect)onFrame andOffFrame:(CGRect)offFrame {
    self = [super initWithOnFrame:onFrame andOffFrame:offFrame];
    if (self) {
        self.coverViewOpen = false;
        self.chosenRow = -1;
        self.chosenSection = -1;
        self.recentContacts = [[TagQueue alloc] initWithCapactiy:kChoiceViewNumRows * kChoiceViewNumSections];
        self.counter = 0;
        self.fullScreen = false;
        self.view.searchTF.delegate = self;
        [self.view.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self.view.contactTableView registerClass:[ContactCell class] forCellReuseIdentifier:@"ContactCell"];
        
        self.placeHolderImage = [UIImage imageNamed:@"chris.jpg"];
        
        [self viewDidLoad];
    }
    return self;
}

- (void)loadView {
    self.view = [[HomeView alloc] initWithFrame:self.offFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.contactTableView.delegate = self;
    self.view.contactTableView.dataSource = self;
    self.view.recentsView.delegate = self;
    
//    self.view.contactTableView.sectionIndexColor
//    self.view.contactTableView.sectionIndexTrackingBackgroundColo
//    self.view.contactTableView.sectionIndexBackgroundColor
    
    // make sure that we have loaded all of the contacts.
    ContactManager *cm = [ContactManager singleton];
    [cm contacts];

    [self.view.contactTableView reloadData];
    [self.view.scrollBar addTarget:self action:@selector(fastScroll:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ContactManager singleton] contacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender {
    [self tableView:self.view.contactTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.chosenRow
                                                                                          inSection:self.chosenSection]];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewHeaderHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numberOfSections = 1;
    ContactManager *cm = [ContactManager singleton];
    if (!cm.search) {
        numberOfSections = [[cm.fetchedResultsController sections] count];
    }
    NSLog(@"numberOfSectionsInTableView = %d", numberOfSections);
    return numberOfSections;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    ContactManager *cm = [ContactManager singleton];
    NSInteger numberOfRows = 0;
    if (cm.search) {
        numberOfRows = cm.searchArray.count;
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[cm.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    NSLog(@"numberOfRowsInSection = %ld", (long)numberOfRows);
    return numberOfRows;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ContactManager *cm = [ContactManager singleton];
    NSString *title = nil;
    if (!cm.search && [[cm.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[cm.fetchedResultsController sections] objectAtIndex:section];
        title = [sectionInfo name];
    }
    NSLog(@"titleForHeaderInSection = %@", title);
    return title;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    float width = tableView.frame.size.width, height = kTableViewHeaderHeight - 2.0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, kTableViewHeaderHeight)];
    
    
    //UIToolbar *blur = [[UIToolbar alloc] initWithFrame:view.frame];
    //[view addSubview:blur];
    
    if (tableView == self.view.contactTableView) {
        ContactManager *cm = [ContactManager singleton];
        if (!cm.search && cm.fetchedResultsController.sections.count > 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kTableViewHeaderLabelPadding, 2, tableView.frame.size.width, height)];
            label.text = cm.fetchedResultsController.sectionIndexTitles[section];
            float fontSize = height;
            label.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
            label.textColor = [UIColor lightBlueColor];
            view.backgroundColor = [UIColor clearColor];
            [view addSubview:label];
            return view;
        }
    }
    return view;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    ContactManager *cm = [ContactManager singleton];
    NSArray *sectionIndexTitles = nil;
    if (!cm.search && !self.fullScreen) {
        sectionIndexTitles = [cm.fetchedResultsController sectionIndexTitles];
    }
    NSLog(@"sectionIndexTitles = %@", sectionIndexTitles);
    return sectionIndexTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    ContactManager *cm = [ContactManager singleton];
    
    NSInteger section = 0;
    if (!cm.search) {
        section = [cm.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
    }
    NSLog(@"sectionForSectionIndexTitle:%@ atIndex:%d = %d", title, index, section);
    return section;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ContactManager *cm = [ContactManager singleton];
//    NSArray *rows = [cm.fetchedResultsController.sections objectAtIndex:indexPath.section];
//    if (self.fullScreen) {
//        if (indexPath.row >= rows.count) {
//            return kHeight;
//        } else if (indexPath.row == self.chosenRow && indexPath.section == self.chosenSection) {
//            return kHeight;
//        } else {
//            return kContactCellHeight;
//        }
//    } else {
//        if (indexPath.row >= rows.count) {
//            return 1;
//        }
//        return kContactCellHeight;
//    }
    
    if (self.fullScreen) {
        if (indexPath.row == self.chosenRow && indexPath.section == self.chosenSection) {
            return kHeight;
        } else {
            return kContactCellHeight;
        }
    } else {
        return kContactCellHeight;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    ContactManager *cm = [ContactManager singleton];
    
//    NSInteger lastSection = [[cm.fetchedResultsController sections] count] - 1;
//    NSArray *section = [cm.fetchedResultsController.sections objectAtIndex:indexPath.section];
//    NSInteger numRowsInSection = [section count];
    
    //handle padding underneath last few cells
//    if ((indexPath.section == lastSection && indexPath.row == numRowsInSection) || cm.search) {
//        UITableViewCell *spacer = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpaceCell"];
//        spacer.backgroundColor = [UIColor whiteColor];
//        return spacer;
//    }
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Contact *c;
    if (cm.search) {
        NSLog(@"SEARCHING");
        c = [cm.searchArray objectAtIndex:indexPath.row];
    } else {
        c = [cm.fetchedResultsController objectAtIndexPath:indexPath];
    }
    [cell renderCell:c];
    
    cell.homeVC = self;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (!c.profileImage) {
        [cell.contactForm.profileImageView placeholder:c];
    } else {
        cell.contactForm.profileImageView.image = c.profileImage;
    }
    
    if (indexPath.row == self.chosenRow && indexPath.section == self.chosenSection) {

        [cell.contactForm centerHeader];
            [cell bringSubviewToFront:cell.swipeView];
        if (indexPath.row % 3 == 0) {
            cell.contactForm.coverPhotoView.image = [UIImage imageNamed:@"ab-bg.jpg"];
        } else if (indexPath.row % 3 == 1) {
            cell.contactForm.coverPhotoView.image = [UIImage imageNamed:@"ny-bg-2.jpg"];
        } else {
            cell.contactForm.coverPhotoView.image = [UIImage imageNamed:@"bg-5.jpg"];
        }
        cell.contactForm.coverPhotoView.backgroundColor = kLightBlue(1);

        //cell.contactForm.coverPhotoView.image = [UIImage imageNamed:@"ab-bg.jpg"];
        cell.contactForm.coverPhotoView.backgroundColor = kLightBlue(1);
        cell.contactForm.tableView.userInteractionEnabled = YES;
        
    } else {
        [cell.contactForm disperseHeader];
        cell.contactForm.coverPhotoView.image = nil;
        cell.contactForm.coverPhotoView.backgroundColor = [UIColor whiteColor];
        cell.contactForm.tableView.userInteractionEnabled = NO;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.keyboardVisible) {
        [self removeAllResponder:self.view];
    }
    NSIndexPath *target;
    
    int scroll;
    int animation;
    if ((self.chosenRow == indexPath.row && self.chosenSection == indexPath.section) || self.fullScreen) {
        target = [NSIndexPath indexPathForRow:self.chosenRow inSection:self.chosenSection];
        ContactCell *cell = (ContactCell*)[self.view.contactTableView cellForRowAtIndexPath:target];
        [cell.contactForm.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.chosenRow = -1;
        self.chosenSection = -1;
        [self turnOffFullScreen];
        scroll = UITableViewScrollPositionTop;
        animation = UITableViewRowAnimationBottom;
    } else {
        scroll = UITableViewScrollPositionTop;
        animation = UITableViewRowAnimationTop;
        [self turnOnFullScreen];
        [self.parent showContactOptions];
        self.chosenRow = indexPath.row;
        self.chosenSection = indexPath.section;
        
        __block Contact *c;
        ContactManager *cm = [ContactManager singleton];
        if (cm.search) {
            c = cm.searchArray[indexPath.row];
        } else {
            c = [cm.fetchedResultsController objectAtIndexPath:indexPath];
        }
        
        [self addContactToRecents:c];
        target = indexPath;
    }
    
    NSLog(@"%i", self.coverViewOpen);
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:target] withRowAnimation:animation];
    [tableView reloadSectionIndexTitles];
    [tableView scrollToRowAtIndexPath:target
                     atScrollPosition:scroll
                             animated:!self.coverViewOpen];
    [tableView endUpdates];
}


- (IBAction)displayProfile:(id)sender {
    ProfileView *p = [[ProfileView alloc] init];
    [self.view addSubview:p];
}

- (void)moveMenu:(UILongPressGestureRecognizer *)longPress {
    UIView *menu = longPress.view.superview;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"holding menu");
    }
    
    [self.view bringSubviewToFront:menu];
    
    CGPoint loc = [longPress locationInView:self.view];
    
    [UIView animateWithDuration:0.001 animations:^(void) {
        //menu.frame = kMenuFrame(loc.x, loc.y);
        menu.frame = kMenuFrame(loc.x-90, loc.y-90);
    } completion:NULL];
    
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"let go");
        //snap to spot on screen
        //[self.view.menuView inOrOut:nil];
    }
}

- (IBAction)sortContacts:(UIButton*)sender
{
//    [[ContactManager singleton] sort:sender.tag];
    [self.view.contactTableView reloadData];
}


#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@", string);
    NSString *query = [NSString stringWithFormat:@"%@%@", self.view.searchTF.text, string];
    if ([string isEqualToString:@""]) {
        NSLog(@"backspace");
        query = [query substringToIndex:query.length-1];
    }
    query = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"%@", query);
    [[ContactManager singleton] search:query];
    [self.view.contactTableView reloadData];
    return true;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [[ContactManager singleton] search:@""];
    [self.view.contactTableView reloadData];
    return YES;
}


#pragma mark ContactCellDelegate
-(void)call:(Contact *)contact {
    NSLog(@"calling %@ %@ %@", contact.firstName, contact.lastName, contact.mobilePhone);
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", contact.mobilePhone];
    NSURL *phoneURL = [NSURL URLWithString:[phoneURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    } else {
        NSLog(@"No application for url '%@'", phoneURL);
    }
}


-(void)text:(Contact *)contact {
    NSLog(@"texting %@ %@ %@", contact.firstName, contact.lastName, contact.mobilePhone);
    NSString *phoneURLString = [NSString stringWithFormat:@"sms:%@", contact.mobilePhone];
    NSURL *phoneURL = [NSURL URLWithString:[phoneURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    } else {
        NSLog(@"No application for url '%@'", phoneURL);
    }
}

-(void)remind:(Contact *)contact {
    NSLog(@"remindgingngasdfkljsdflkajsf;");
}


-(void)tag:(Contact *)contact {
    SessionManager *sm = [SessionManager singleton];
    NSLog(@"Tagging %@ %@ %ld", contact.firstName, contact.lastName, (long)contact.serverId);
    NSDictionary *parameters = @{ @"serverId": [NSNumber numberWithInteger:contact.serverId], @"sessionId" : sm.sessionId };

    [sm POST:@"/user/tag" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Tagged %@ %@", contact.firstName, contact.lastName);
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (contact.mobilePhone) {
            [self textInsteadOfTag:contact];
        } else {
            NSLog(@"error: %@", error);
        }
    }];
}


-(void)textInsteadOfTag:(Contact *)contact {
    NSLog(@"Could not tag %@ %@, sending text message instead", contact.firstName, contact.lastName);
    NSString *phoneNumber = contact.mobilePhone;
    // Starfish DELETE
    phoneNumber = @"3306086016";
    
    NSString *message = [NSString stringWithFormat: @"You've just been tagged by %@ %@ -- download the app itms-apps://tag", contact.firstName, contact.lastName];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioAuthToken, kTwilioSID]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kTwilioSendNumber, phoneNumber, message];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:data];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error)
                               {
                                   NSLog(@"%@", error);
                               }
                           }];
}


// basically turns search off
-(void)displayAllContacts {
    ContactManager *cm = [ContactManager singleton];
    [cm search:@""];
    [self.view.contactTableView reloadData];
}

- (void)moveOnScreen {
    [super moveOnScreen];
    [self.view.contactTableView reloadData];
}

- (void)turnOnFullScreen {
    self.fullScreen = YES;
    self.view.contactTableView.scrollEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.topBar.frame = kTopBarOff;
        self.view.topBar.backgroundColor = kClearColor;
        //[(MasterViewController*)[self parent] view].menuView.frame = kMenuOffScreen;
        self.view.contactTableView.frame = kContactsShow;
    }];
}

- (void)turnOffFullScreen {
    self.fullScreen = NO;
    self.view.contactTableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.topBar.frame = kTopBarOn;
        self.view.topBar.backgroundColor = kLightBlue(1);
        //[(MasterViewController*)[self parent] view].menuView.frame = kMenuOnScreen;
        self.view.contactTableView.frame = kContactsList;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view.searchTF resignFirstResponder];
    return NO;
}

#pragma mark RecentContacts
// slides the recent contacts view onto the view from the left.
- (void)displayRecentContacts {
    [self.view showRecentsView];
    self.coverViewOpen = YES;
}

// slides the recent contacts view off the view to the left.
- (void)hideRecentContacts {
    [self.view hideRecentsView];
    self.coverViewOpen = NO;
}

// adds a contact to the recent queue and reloads the view.
-(void)addContactToRecents:(Contact *)contact {
    [self.recentContacts add:contact];
    [self.view.recentsView reload];
}

#pragma mark ChoiceView Delegate Implementation
-(UIView *)choiceView:(ChoiceView *)choiceView viewAtIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame {
    UIView *v = [[UIView alloc] initWithFrame:frame];
    float height = frame.size.height, width = frame.size.width;
    NSInteger row = [ChoiceView indexFromIndexPath:indexPath];
    
    if (row >= self.recentContacts.count) {
        return nil;
    }
    
    Contact *c = [self.recentContacts objectAtIndex:row];
    
    if (choiceView == self.view.recentsView) {
        float placeholderSize = MIN(height, width);
        float pad = (width - placeholderSize) / 2;
        float textHeight = height - placeholderSize;
        CGFloat borderWidth = 2.0;
        
        PlaceholderView *placeholder = [[PlaceholderView alloc] initWithFrame:CGRectMake(pad, 0, placeholderSize - borderWidth, placeholderSize - borderWidth)];
        placeholder.backgroundColor = [UIColor clearColor];
        placeholder.textColor = [UIColor whiteColor];
        placeholder.text = [c initials];
        placeholder.borderWidth = borderWidth;
        placeholder.borderColor = [UIColor lightBlueColor];
        [v addSubview:placeholder];
        
        if (textHeight > 20.0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - textHeight, width, textHeight)];
            label.numberOfLines = 2;
            label.text = [NSString stringWithFormat:@"%@ %@", c.firstName, c.lastName];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:@"Helvetica" size:16];
            label.adjustsFontSizeToFitWidth = YES;
            [v addSubview:label];
        }
    }
    return v;
}

-(void)choiceView:(ChoiceView *)choiceView didPressAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = [ChoiceView indexFromIndexPath:indexPath];
    if (choiceView == self.view.recentsView) {
        ContactManager *cm = [ContactManager singleton];
        Contact *c = [self.recentContacts objectAtIndex:index];
        NSIndexPath *indexPath = [cm getIndexPathForContact:c];
        [self.view.contactTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        self.chosenRow = -1;
        self.chosenSection = -1;
        [self hideRecentContacts];
        NSLog(@"row = %d, section = %d", indexPath.row, indexPath.section);

        [self tableView:self.view.contactTableView didSelectRowAtIndexPath:indexPath];
    }
}

-(CGFloat)choiceView:(ChoiceView *)choiceView getHeightForRow:(NSInteger)row {
    if (choiceView == self.view.recentsView) {
        return 110.0;
    }
    return 110.0;
}

-(void)choiceViewDidDismiss:(ChoiceView *)choiceView {
    NSLog(@"Trying to dismiss the ChoiceView");
    if (choiceView == self.view.recentsView) {
        NSLog(@"Hiding recent contacts");
        [self hideRecentContacts];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view.searchTF resignFirstResponder];
}




@end
