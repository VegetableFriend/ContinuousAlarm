//
//  VFContinuousAlarmTableViewCell.m
//  ContinuousAlarm
//
//  Created by HaopengLi on 9/20/22.
//

#import "VFContinuousAlarmTableViewCell.h"

@implementation VFContinuousAlarmTableViewCell

- (void)setModel:(AlarmModel *)model {
    _model = model;
    
    self.textLabel.text = model.time.description;
}

@end
