//
//  EXSettingsViewController.m
//  NewsCatalog
//
//  Created by Alex Aleshkov on 5/27/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXSettingsViewController.h"
#import "EXConsts.h"


@interface EXSettingsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *fontNames;
@property (nonatomic, strong) NSArray *fontSizes;
@end


@implementation EXSettingsViewController

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

    self.fontNames = EXFontNames();
    self.fontSizes = EXFontSizes();
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [userDefaults objectForKey:EXSettingFontName];
    NSNumber *fontSize = [userDefaults objectForKey:EXSettingFontSize];
    
    NSInteger fontNameIndex = EXFindNearestFontNameIndex(fontName);
    NSInteger fontSizeIndex = EXFindNearestFontSizeIndex(fontSize);

    [self.pickerView selectRow:fontNameIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:fontSizeIndex inComponent:1 animated:NO];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.fontNames count];
    } else {
        return [self.fontSizes count];
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 210;
    } else {
        return 80;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0) {
//        NSString *result;
//        EXFontName *fontName = [self.fontNames objectAtIndex:row];
//        result = fontName.fontDisplayName;
//        return result;
//    } else {
//        NSString *result;
//        NSNumber *fontSize = [self.fontSizes objectAtIndex:row];
//        result = [fontSize stringValue];
//        return result;
//    }
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (component == 0) {
        UILabel *result = (UILabel *)view;
        if (!result) {
            CGSize componentSize = [pickerView rowSizeForComponent:component];
            CGRect labelFrame = CGRectMake(0, 0, componentSize.width - 20 * 2, componentSize.height);
            result = [[UILabel alloc] initWithFrame:labelFrame];
            result.backgroundColor = [UIColor clearColor];
            result.textAlignment = NSTextAlignmentLeft;
        }
        
        EXFontName *fontName = [self.fontNames objectAtIndex:row];
        result.font = [UIFont fontWithName:fontName.fontName size:18];
        result.text = fontName.fontDisplayName;
        
        return result;
    } else {
        UILabel *result = (UILabel *)view;
        if (!result) {
            CGRect labelFrame = CGRectMake(0, 0, 0, 0);
            result = [[UILabel alloc] initWithFrame:labelFrame];
            result.backgroundColor = [UIColor clearColor];
            result.textAlignment = NSTextAlignmentCenter;
        }
        
        NSNumber *fontSize = [self.fontSizes objectAtIndex:row];
        result.font = [UIFont systemFontOfSize:[fontSize floatValue]];
        result.text = [fontSize stringValue];

        return result;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *result;
        EXFontName *fontName = [self.fontNames objectAtIndex:row];
        result = fontName.fontName;

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:result forKey:EXSettingFontName];
        [userDefaults synchronize];
    } else {
        NSNumber *fontSize = [self.fontSizes objectAtIndex:row];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:fontSize forKey:EXSettingFontSize];
        [userDefaults synchronize];
    }
}

@end
