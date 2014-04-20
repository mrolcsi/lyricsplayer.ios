//
//  ViewController.h
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.03.16..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TestViewController : UIViewController <MPMediaPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnShowMediaPicker;

@end
