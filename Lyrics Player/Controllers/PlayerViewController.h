//
//  PlayerViewController.h
//  Lyrics Player
//
//  Created by Matusinka Roland on 2014.04.20..
//  Copyright (c) 2014 Matusinka Roland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "SongList.h"

@interface PlayerViewController : UIViewController

@property (strong, nonatomic) SongList *songlist;
@property (strong, nonatomic) Song *currentSong;

@end
