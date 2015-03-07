//
//  AboutViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MessageViewController.h"
#import "ContainerViewController.h"
#import "MessageCell.h"
#import "ThemeHeader.h"
#import "CoreDataHeaders.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "ContainerViewController.h"
#import "NetworkingController.h"
#import "ThemeHeader.h"
#import "NetworkingController.h"

#define ALERT_VIEW_TOGGLE_ON 0
#define ALERT_VIEW_TOGGLE_OFF 1

@interface MessageViewController () <UITextViewDelegate>

@end

@implementation MessageViewController

-(MessageViewController *)init
{
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self = [super initWithNibName:@"MessageView_IPhone5" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"MessageView_IPhone" bundle:nil];
    }
    self.messageViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 11, 320, 49)];

    self.title = @"About";

    self.messages = [[NSMutableArray alloc] init];
    self.keyboardIsOut = FALSE;
    self.appendingMessages = FALSE;
    
    self.lastPage = 1;
    self.findLastPage = FALSE;

    NSLog(@"***************** %f", self.view.frame.size.height - 50);
    [self.messageViewContainer setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.messageViewContainer];
    
    /*
    UIView *messageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 250, 40)];
    [messageBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [[messageBackgroundView layer] setCornerRadius:5];
    [self.sendMessageView addSubview:messageBackgroundView];
    */
    
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 255, 30)];
    self.messageTextView.delegate = self;
    [self.messageTextView setEditable:TRUE];
    [self.messageTextView setScrollEnabled:TRUE];
    [self.messageTextView setBackgroundColor:[UIColor whiteColor]];
    self.messageTextView.layer.cornerRadius = 4.0;
    self.messageTextView.clipsToBounds = YES;
    [self.messageTextView setAutoresizesSubviews:TRUE];
    self.messageTextView.font = [UIFont messageFont];
    self.messageTextView.returnKeyType = UIReturnKeyDone;
    self.messageTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.messageTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.messageTextView addObserver:self forKeyPath: @"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    self.messageTextView.contentOffset = CGPointMake(0, 5);

    [self.messageViewContainer addSubview:self.messageTextView];
    
    self.messageSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageSendButton setImage:[UIImage imageNamed:@"postMessage.png"] forState:UIControlStateNormal];
    [self.messageSendButton addTarget:self action:@selector(postMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageSendButton setFrame:CGRectMake(265, 8, 50, 35)];
    [self.messageViewContainer addSubview:self.messageSendButton];
    
    if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
    {
        [self.theTableView setFrame:CGRectMake(self.theTableView.frame.origin.x, self.theTableView.frame.origin.y, self.theTableView.frame.size.width, self.theTableView.frame.size.height - 10)];
    }
    
    //Keyboard CallBacks
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
    
    //Setting Message Type
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setMessageType:)
                                                 name: @"messageTypeChanged"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(viewWillAppear:)
                                                 name: @"messageViewWillAppear"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"switchedToMessages" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMessageAddressed:) name:@"toggleMessageAddressed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:nil selector:@selector(showSelectedMessage:) name:NOTIFICATOIN_FINISHED_GETTING_MESSAGE_BY_ID object:nil];

    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.theTableView addSubview:refreshControl];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    if(self.messages.count == 0)//self.pinIDToShow == nil)
    {
        self.findLastPage = TRUE;
        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [hud setLabelText:@"Finding Messages"];
        
        [[OperationController shared] fetchLatestMessagesWithCurrentMessages:self.messages
                                                                     success:^(NSMutableSet *newMessages) {
                                                                         [hud hide:TRUE];
                                                                         [theCoreDataController saveContext];
                                                                         [self.theTableView reloadData];
                                                                     } andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                         [hud hide:TRUE];
                                                                         
                                                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                                                         message:@"Could not connect to server"
                                                                                                                        delegate:nil
                                                                                                               cancelButtonTitle:@"Ok"
                                                                                                               otherButtonTitles:nil, nil];
                                                                         [alert show];
                                                                     }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking Delegates
-(void)getMessageByAppendingPageForScrolling
{
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [hud setLabelText:@"Finding Messages"];
    
    if(self.findLastPage == TRUE)
    {
        
    }
    else
    {
        self.lastPage++;
        [[OperationController shared] fetchMessagesForPage:self.lastPage
                                           currentMessages:self.messages
                                                   success:^(NSMutableSet *messages) {
                                                       [theCoreDataController saveContext];
                                                   } andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                                       message:@"Could not connect to server"
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"Ok"
                                                                                             otherButtonTitles:nil, nil];
                                                       [alert show];
                                                   }];
    }
}

-(IBAction)postMessage:(id)sender
{
    self.currentMessageType = MESSAGE_TYPE_4_NETWORK_TYPE;
    
    NSString *msg = [[self.messageTextView.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]componentsJoinedByString:@" "];
    
    self.findLastPage = TRUE;
    
    [[OperationController shared] sendNewMessage:msg
                                            type:self.currentMessageType
                                         success:^{
                                             [[OperationController shared] fetchLatestMessagesWithCurrentMessages:self.messages
                                                                                                          success:^(NSMutableSet *newMessages) {
                                                                                                              [theCoreDataController saveContext];
                                                                                                          } andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                                              
                                                                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                                                                                              message:@"Could not connect to server"
                                                                                                                                                             delegate:nil
                                                                                                                                                    cancelButtonTitle:@"Ok"
                                                                                                                                                    otherButtonTitles:nil, nil];
                                                                                                              [alert show];
                                                                                                          }];
                                             [self.theTableView reloadData];
                                         } andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                             message:@"Could not connect to server"
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"Ok"
                                                                                   otherButtonTitles:nil, nil];
                                             [alert show];
                                         }];
}

#pragma mark - Refresh Controls

- (void)refresh:(UIRefreshControl *)refreshControl {
    self.findLastPage = TRUE;
    [[OperationController shared] fetchNewestMessages:self.messages
                                              success:^(NSMutableSet *newMessages) {
                                                  [theCoreDataController saveContext];
#warning RELOAD TABLE HERE?
                                              } andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                                  message:@"Could not connect to server"
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"Ok"
                                                                                        otherButtonTitles:nil, nil];
                                                  [alert show];
                                              }];

    [refreshControl endRefreshing];
}

#pragma mark - TABLE VIEW DATA SOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellID";
    
    UITableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Message *msg = [self.messages objectAtIndex:indexPath.row];
    
    if (cell != nil)
    {
        for(UIView *subview in cell.contentView.subviews)
        {
            [subview removeFromSuperview];
        }
        
        if(indexPath.row % 2 == 0)
        {
            if(indexPath.row == 0)
            {
                [((MessageCell *)cell) updateCellWithMessage:msg isBackwards:TRUE isFirst:TRUE andResueIdentifier:CellIdentifier];
            }
            else
            {
                [((MessageCell *)cell) updateCellWithMessage:msg isBackwards:TRUE isFirst:FALSE andResueIdentifier:CellIdentifier];
            }
        }
        else
        {
            if(indexPath.row == 0)
            {
                [((MessageCell *)cell) updateCellWithMessage:msg isBackwards:FALSE isFirst:TRUE andResueIdentifier:CellIdentifier];
            }
            else
            {
                [((MessageCell *)cell) updateCellWithMessage:msg isBackwards:FALSE isFirst:FALSE andResueIdentifier:CellIdentifier];
            }
        }
    }
    else
    {
        if(indexPath.row % 2 == 0)
        {
            if(indexPath.row == 0)
            {
                cell = [[MessageCell alloc] initWithMessage:msg isBackwards:TRUE isFirst:TRUE andResueIdentifier:CellIdentifier];
            }
            else
            {
                cell = [[MessageCell alloc] initWithMessage:msg isBackwards:TRUE isFirst:FALSE andResueIdentifier:CellIdentifier];
            }
        }
        else
        {
            if(indexPath.row == 0)
            {
                cell = [[MessageCell alloc] initWithMessage:msg isBackwards:FALSE isFirst:TRUE andResueIdentifier:CellIdentifier];
            }
            else
            {
                cell = [[MessageCell alloc] initWithMessage:msg isBackwards:FALSE isFirst:FALSE andResueIdentifier:CellIdentifier];
            }
        }
    }
    

    
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

#pragma - TABLE VIEW DELEGATE

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [self.messages objectAtIndex:indexPath.row];
    
    CGSize size;
    if([msg.messageType isEqualToString:MESSAGE_TYPE_3_NETWORK_NAME] || [msg.messageType isEqualToString:MESSAGE_TYPE_3_NETWORK_NAME] || [msg.messageType isEqualToString:MESSAGE_TYPE_2_NETWORK_NAME])
    {
        size = [[msg message] sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
        size.height += + 20 + 6;
        //return size;
    }
    else
    {
        size = [[msg message] sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX)];
        size.height += + 20 + 6;
        //return size;
    }
    
    if(indexPath.row == 0)
    {
        return size.height + 25 + 20;
    }
    else
    {
        return size.height + 5 + 20;
    }
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    
}
 
 */

#pragma mark - UITextField Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id) object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"contentSize"] && object == self.messageTextView)
    {
        CGSize oldContentSize = [[change objectForKey: NSKeyValueChangeOldKey] CGSizeValue];
        float heightDiff = self.messageTextView.contentSize.height - oldContentSize.height;

        if(heightDiff != 0)
        {
            VoidBlock animationBlock =
            ^{
                //Reposition Post Button
                CGRect newFrame = self.messageSendButton.frame;
                newFrame.origin.y += (heightDiff / 2);
                [self.messageSendButton setFrame:newFrame];
                
                //Reposition MessageBackground
                CGRect newFrame4 = self.messageViewContainer.frame;
                newFrame4.origin.y -= heightDiff;
                newFrame4.size.height += heightDiff;
                [self.messageViewContainer setFrame:newFrame4];
                
                //Reposition Textfield
                CGRect newFrame2 = self.messageTextView.frame;
                newFrame2.size.height += heightDiff;
                [self.messageTextView setFrame:newFrame2];
                
                //Reposition TableView
                CGRect newFrame3 = self.theTableView.frame;
                newFrame3.size.height -= heightDiff;
                [self.theTableView setFrame:newFrame3];
            };
            
            [UIView animateWithDuration: 0.25 animations: animationBlock];
        }
    }
    
    NSLog(@"OBSERVER: %f", self.messageViewContainer.frame.size.height);
    
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [self.messageTextView resignFirstResponder];
        return FALSE;
    }
    else if(textView.text.length > 140)
    {
        if([string isEqualToString:@""] && range.length == 1)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return TRUE;
    }
}

#pragma mark - Message Methods

-(void)sortMessages
{
    [self.messages sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:YES]]];
}

-(NSIndexPath *)findIndexOfMessage:(Message *)message
{
    NSInteger row = 0;
    for(Message *tempMessage in self.messages)
    {
        if([tempMessage isEqual:message])
            return [[NSIndexPath alloc] initWithIndex:row];
        else
            row++;
    }
    
    NSException *exception = [[NSException alloc] initWithName:@"Could not find message" reason:@"" userInfo:nil];
    [exception raise];
    return nil;
}

-(IBAction)setMessageType:(NSNotification *)notificationRecieved
{
    NSLog(@"Messag - Message: Setting Message Type = %@", notificationRecieved.object);
    self.currentMessageType = notificationRecieved.object;
}

-(void)showSelectedMessage:(Message *)message
{
    NSLog(@"Message - Message: Found Selected Message On Current Page");
    [self sortMessages];
    NSIndexPath *path = [self findIndexOfMessage:message];
    
    [self.theTableView reloadData];
    [self.theTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:FALSE];
    
    [self performSelector:@selector(showMessageFadeOverlay:) withObject:path afterDelay:.3];
}

-(IBAction)showMessageFadeOverlay:(NSIndexPath *)indexOfSelectedMessage
{
    NSLog(@"Message - Message: Removing Message Fade Overlay");
    VoidBlock animate = ^
    {
        for(int i = 0; i < self.messages.count; i++)
        {
            if(i != indexOfSelectedMessage.row)
            {
                MessageCell *cell = (MessageCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell.contentView setAlpha:0];
            }
        }
    };
    
    self.pinIDToShow = nil;
    //Perform Animations
    [UIView animateWithDuration:.25 animations:animate];
    
    [self performSelector:@selector(removeMessageFadeOverlay:) withObject:indexOfSelectedMessage afterDelay:1.25];
}

-(IBAction)removeMessageFadeOverlay:(NSIndexPath *)indexOfSelectedMessage
{
    NSLog(@"Message - Message: Removing Message Fade Overlay");
    VoidBlock animate = ^
    {
        for(int i = 0; i < self.messages.count; i++)
        {
            if(i != indexOfSelectedMessage.row)
            {
                MessageCell *cell = (MessageCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell.contentView setAlpha:1];
            }
        }
    };
    
    self.pinIDToShow = nil;
    //Perform Animations
    [UIView animateWithDuration:.25 animations:animate];
}

#pragma mark - KEYBOARD CALL BACKS
-(IBAction)keyboardWillShow:(id)sender
{
    NSLog(@"Action - Message: Keyboard Will Show");
    
    self.keyboardIsOut = TRUE;
    
    //Shift Subviews For Keyboard
    CGRect currentTableFrame = self.theTableView.frame;
    NSLog(@"message container height: %f", self.messageViewContainer.frame.size.height);
    currentTableFrame.size.height = (((self.view.frame.size.height - self.theTableView.frame.origin.y) - self.messageViewContainer.frame.size.height) - 165);
    [self.theTableView setFrame:currentTableFrame];
    
    CGRect currentMessageFrame = self.messageViewContainer.frame;
    currentMessageFrame.origin.y = self.view.frame.size.height - self.messageViewContainer.frame.size.height - 165;
    [self.messageViewContainer setFrame:currentMessageFrame];
}
 
-(IBAction)keyboardWillHide:(id)sender
{
    NSLog(@"Action - Message: Keyboard Will Hide");
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    self.keyboardIsOut = FALSE;
    
    //Shift Subviews For Keyboard
    CGRect currentTableFrame = self.theTableView.frame;
    currentTableFrame.size.height = (self.view.frame.size.height - self.theTableView.frame.origin.y) - self.messageViewContainer.frame.size.height;
    [self.theTableView setFrame:currentTableFrame];
    
    CGRect currentMessageViewFrame = self.messageViewContainer.frame;
    currentMessageViewFrame.origin.y = self.view.frame.size.height - self.messageViewContainer.frame.size.height;
    [self.messageViewContainer setFrame:currentMessageViewFrame];
}

#pragma mark - Toggle Message Validity
-(void)toggleMessageAddressed:(NSNotification *)notification
{
    NSLog(@"Action - Message: Toggling Message Addressed. Message,");
    Message *msg = notification.object;
    self.toggledMessageRef = msg;
    
    NSLog(@"--- Data - Message: %@", self.toggledMessageRef);
    if(msg.addressed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MESSAGE_VIEW_ALERT_CONFIRMATION_TITLE message:MESSAGE_VIEW_ALERT_CONFIRMATION_MESSAGE_UNADDRESSED delegate:self cancelButtonTitle:MESSAGE_VIEW_ALERT_CONFIRMATION_NO otherButtonTitles:MESSAGE_VIEW_ALERT_CONFIRMATION_YES, nil];
        alert.tag = ALERT_VIEW_TOGGLE_OFF;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MESSAGE_VIEW_ALERT_CONFIRMATION_TITLE message:MESSAGE_VIEW_ALERT_CONFIRMATION_MESSAGE_ADDRESSED delegate:self cancelButtonTitle:MESSAGE_VIEW_ALERT_CONFIRMATION_NO otherButtonTitles:MESSAGE_VIEW_ALERT_CONFIRMATION_YES, nil];
        alert.tag = ALERT_VIEW_TOGGLE_ON;
        [alert show];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;

    float reload_distance = 10;
    if(y > h + reload_distance && self.nextPageURL != nil && self.appendingMessages == FALSE)
    {
        self.appendingMessages = TRUE;
        
        [self showMoreMessagesAlert];
        NSLog(@"Action - Message: Scrolled To End Of List, Loading Next Page Wit URL: %@", self.nextPageURL);
        [self getMessageByAppendingPageForScrolling];
    }
}

-(void)showMoreMessagesAlert
{
    if(self.moreMessagesAlertView == nil)
    {
        self.moreMessagesAlertView = [[UIView alloc] initWithFrame:CGRectMake(5, (self.view.frame.size.height / 2) - 15, 310, 30)];
        [self.moreMessagesAlertView.layer setCornerRadius:5];
        [self.moreMessagesAlertView.layer setBorderWidth:2];
        [self.moreMessagesAlertView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.moreMessagesAlertView.frame.size.width, self.moreMessagesAlertView.frame.size.height)];
        [alertLabel setText:@"Scroll Down For More Messages"];
        [alertLabel setBackgroundColor:[UIColor clearColor]];
        [alertLabel setTextAlignment:NSTextAlignmentCenter];
        [self.moreMessagesAlertView addSubview:alertLabel];
    }
    
    [self.moreMessagesAlertView setAlpha:0];
    [self.view addSubview:self.moreMessagesAlertView];
    
    //Animate Block
    VoidBlock animate = ^
    {
        [self.moreMessagesAlertView setAlpha:1];
    };
    
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(hideMoreMessagesAlert) withObject:nil afterDelay:2];
}

-(void)hideMoreMessagesAlert
{
    //Animate Block
    VoidBlock animate = ^
    {
        [self.moreMessagesAlertView setAlpha:0];
    };
    
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(removeMoreMessagesAlert) withObject:nil afterDelay:.3];
}

-(void)removeMoreMessagesAlert
{
    [self.moreMessagesAlertView removeFromSuperview];
}
#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL changesMade = FALSE;
    if(alertView.tag == ALERT_VIEW_TOGGLE_ON)
    {
        if(buttonIndex == 1)
        {
            NSLog(@"Action - Message: Toggled Message To Be NOT ADDRESSED!");
            changesMade = TRUE;
            
            self.toggledMessageRef.addressed = @TRUE;
        }
        else
        {
            NSLog(@"Action - Message: Cancled Message Addressed Toggle");
        }
    }
    else if(alertView.tag == ALERT_VIEW_TOGGLE_OFF)
    {
        if(buttonIndex == 1)
        {
            NSLog(@"Action - Message: Toggled Message To Be ADDRESSED!");
            changesMade = TRUE;
            
            self.toggledMessageRef.addressed = @FALSE;
        }
        else
        {
            NSLog(@"Action - Message: Cancled Message Addressed Toggle");
        }
    }
    
    [theCoreDataController saveContext];
    
    if(changesMade != FALSE)
    {
        [[OperationController shared] updateMessage:self.toggledMessageRef
                                            success:^{
                                                [self.theTableView reloadData];
                                            } andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                self.toggledMessageRef.addressed = @(!self.toggledMessageRef.addressed.boolValue);
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                                message:@"Could not connect to server"
                                                                                               delegate:nil
                                                                                      cancelButtonTitle:@"Ok"
                                                                                      otherButtonTitles:nil, nil];
                                                [alert show];
                                            }];
    }
}

@end
