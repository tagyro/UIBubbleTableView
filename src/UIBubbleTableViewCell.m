//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;
@property (nonatomic, retain) UILabel *textView;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImage = nil;
    self.avatarImage = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImage)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];        
#endif
        //
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = 220;//self.data.view.frame.size.width;
    CGFloat height = self.data.height;
    CGFloat x = (type == BubbleTypeSomeoneElse) ? 10 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right-10;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    self.showAvatar = YES ? self.data.type==BubbleTypeSomeoneElse : NO;
    if (self.showAvatar)
    {
        //
        [self.avatarImage removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
        //
        [self.avatarImage setImageWithURL:[NSURL URLWithString:self.data.photo] placeholderImage:[UIImage imageNamed:self.data.placeholder]];
        //
        self.avatarImage.layer.cornerRadius = 0.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:1].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
        self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 8 : self.frame.size.width - 57;
        CGFloat avatarY = 0;//self.frame.size.height - 50;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        [self addSubview:self.avatarImage];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == BubbleTypeSomeoneElse) x += 54;
        if (type == BubbleTypeMine) x -= 54;
        //
    }
    //
    [self.customView removeFromSuperview];
    self.customView = [[UIView alloc] init];
    self.customView.frame = CGRectMake(0, 0 /*y + self.data.insets.top*/, 320, height);
    //
    [self.customView addSubview:self.bubbleImage];
    [self.customView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
    //
    [self addSubview:self.customView];
    //
    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"assets/messages/bubbleSomeone"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];

    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"assets/messages/bubbleMine"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    }
    //
    self.bubbleImage.frame = CGRectMake(x, 0, width + self.data.insets.left + self.data.insets.right, MAX(height,50));
    //
    if (!self.textView) {
        self.textView = [[UILabel alloc] init];
        [self.bubbleImage addSubview:self.textView];
    }
    
    //self.textView = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 220, self.data.height-5)];
    [self.textView setFrame:CGRectMake(10, 3, 220, self.data.height-5)];
    self.textView.numberOfLines = 0;
    self.textView.lineBreakMode = NSLineBreakByWordWrapping;
    self.textView.text = @"";
    self.textView.text = self.data.text;
    self.textView.font = medium17;
    self.textView.textColor = textNormalColor;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.textView.textAlignment = NSTextAlignmentLeft;
    //
    self.bubbleImage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    //
    if (self.isEditing) {
        self.avatarImage.alpha = 0;
    } else {
        self.avatarImage.alpha = 1;
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    self.avatarImage.alpha = 0;
    if (editing) {
        [UIView animateWithDuration:.3 animations:^{
            self.avatarImage.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            self.avatarImage.alpha = 1;
        }];
    }
    //
    [super setEditing:editing animated:animated];
}

-(void)willTransitionToState:(UITableViewCellStateMask)state {
    if (state == 3 || state == 2) {
        [UIView animateWithDuration:.3 animations:^{
            CGRect frame = self.bubbleImage.frame;
            frame.size.width =  220 + self.data.insets.left + self.data.insets.right - 80;
            self.bubbleImage.frame = frame;
            //
            frame = CGRectMake(10, 3, 220-80, self.data.height-5);
            self.textView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            CGRect frame = self.bubbleImage.frame;
            frame.size.width =  220 + self.data.insets.left + self.data.insets.right;
            self.bubbleImage.frame = frame;
            //
            frame = CGRectMake(10, 3, 220, self.data.height-5);
            self.textView.frame = frame;
        }];
    }
    [super willTransitionToState:state];
}


@end
