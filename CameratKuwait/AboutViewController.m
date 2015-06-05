//
//  AboutViewController.m
//  twitterExampleIII
//
//  Created by Housein Jouhar on 6/15/13.
//  Copyright (c) 2013 MacBook. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY"];
    
    _rightsLabel.text = [@"جميع الحقوق محفوظة للمطورين العرب " stringByAppendingFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    
    float appVer = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
    
    _verLabel.text = [@"الإصدار:" stringByAppendingFormat:@" %.1f",appVer];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isAbout"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isAbout"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self hideTabBar:self.tabBarController];
    }
}

- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+49.f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+49.f)];
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        tabbarcontroller.tabBar.hidden = YES;
    }];
}

- (IBAction)followUs:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.tapbots.tweetbot3:///user_profile/ArabDevs"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.tapbots.tweetbot3:///user_profile/ArabDevs"]];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/ArabDevs"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/ArabDevs"]];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=ArabDevs"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=ArabDevs"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/ArabDevs"]];
    }
}

- (IBAction)ourApps:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/sa/artist/musaed-alazmi/id662172394"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
