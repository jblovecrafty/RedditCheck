//
//  RedditFetchSubRedditViewController.h
//  RedditFetch
//
//  Created by Joe Jones on 1/12/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedditFetchSubRedditViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@property (strong, nonatomic) IBOutlet UISegmentedControl *storyNumberSegment;

@property (weak, nonatomic) IBOutlet UILabel *versionNumber;

@end
