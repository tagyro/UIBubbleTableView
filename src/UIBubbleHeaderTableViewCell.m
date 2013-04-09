//
//  UIBubbleHeaderTableViewCell.m
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import "UIBubbleHeaderTableViewCell.h"

@interface UIBubbleHeaderTableViewCell ()

@property (nonatomic, retain) UILabel *label;

@end

@implementation UIBubbleHeaderTableViewCell

@synthesize label = _label;
@synthesize date = _date;

+ (CGFloat)height
{
    return 28.0;
}

- (void)setDate:(NSDate *)value
{
    
    if (!self.label)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
        self.label.font = regular14;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.shadowOffset = CGSizeMake(0, 1);
        self.label.shadowColor = textNormalColor;
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH"];
    
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"HH:mm"];
    
    NSDate *today = [NSDate date];
    int currentHour = [df stringFromDate:today].intValue;
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSHourCalendarUnit fromDate:value toDate:today options:0];
    int messageHour = [df stringFromDate:value].intValue;
    
    if (comp.day<1 && (currentHour>=messageHour) ) {
        //[dateFormatter setDateFormat:@"EEEE, HH:mm"];
        self.label.text = [NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"today", nil),[time stringFromDate:value]];
        return;
    } else if (comp.day<2 || (comp.day<1 && currentHour<messageHour)) {
        self.label.text = [NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"yesterday", nil),[time stringFromDate:value]];
        return;
    } else if (comp.day<7) {
        [dateFormatter setDateFormat:@"EEEE, HH:mm"];
    }
    
    NSString *text = [dateFormatter stringFromDate:value];
    //[dateFormatter release];
    self.label.text = text;
    
}



@end
