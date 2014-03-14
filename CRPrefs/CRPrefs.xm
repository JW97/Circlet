#include "../CRHeaders.h"
#include <libhbangcommon/prefs/HBRootListController.h>
#include <Preferences/PSListItemsController.h>
#include <Preferences/PSListController.h>
#include <Preferences/PSTableCell.h>
#import <MessageUI/MessageUI.h>
#include <notify.h>

#define CRTINTCOLOR [UIColor colorWithWhite:0.1 alpha:1.0]

// TODO: add some hack for this in libhbangprefs
@interface CRListItemsController : PSListItemsController
@end

@implementation CRListItemsController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = CRTINTCOLOR;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.tintColor = nil;
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2{
	PSTableCell *cell = [super tableView:arg1 cellForRowAtIndexPath:arg2];

	NSDictionary *labelToColor =  @{@"Aqua"			  : UIColorFromRGB(0x7FDBFF),
									@"Black"   		  : UIColorFromRGB(0x111111),
									@"Black (Default)"   : UIColorFromRGB(0x111111),
									@"Blue"		  	: UIColorFromRGB(0x0074D9),
									@"Clear"   		  : [UIColor clearColor],
									@"Fuchsia" 		  : UIColorFromRGB(0xF012BE),
									@"Grey"			  : UIColorFromRGB(0xAAAAAA),
									@"Green"   		  : UIColorFromRGB(0x2ECC40),
									@"Lime"			  : UIColorFromRGB(0x01FF70),
									@"Maroon"  		  : UIColorFromRGB(0x85144B),
									@"Navy"			  : UIColorFromRGB(0x001F3F),
									@"Olive"   		  : UIColorFromRGB(0x3D9970),
									@"Orange" 		   : UIColorFromRGB(0xFF851B),
									@"Purple"  	  	: UIColorFromRGB(0xB10DC9),
									@"Red"			   : UIColorFromRGB(0xFF4136),
									@"Silver" 		   : UIColorFromRGB(0xDDDDDD),
									@"Teal"		  	: UIColorFromRGB(0x39CCCC),
									@"White (Default)"   : UIColorFromRGB(0xFFFFFF),
									@"Yellow" 		   : UIColorFromRGB(0xFFDC00) };

	UIView *colorThumb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
	colorThumb.backgroundColor = [labelToColor objectForKey:[[cell titleLabel] text]];
	colorThumb.layer.masksToBounds = YES;
	colorThumb.layer.cornerRadius = 10.0;
	colorThumb.layer.borderColor = [UIColor lightGrayColor].CGColor;
	colorThumb.layer.borderWidth = 1.0;

	UIGraphicsBeginImageContextWithOptions(colorThumb.bounds.size, NO, 0.0);
	[colorThumb.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[cell.imageView setImage:image];
	return cell;
}

@end

@interface CRPrefsListController : HBRootListController
@end

@implementation CRPrefsListController

+ (UIColor *)hb_tintColor {
	return CRTINTCOLOR;
}

+ (NSString *)hb_shareText {
	return @"Life has never been simpler than with #Circlet by @insanj.";
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://insanj.com/circlet"];
}

- (instancetype)init {
	self = [super init];

	if (self) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"CRPrefs" target:self] retain];
	}

	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// This is here to check for first-run (never set) specifiers.
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.circlet.plist"]];

	if (![settings objectForKey:@"signalSize"]) {
		PSSpecifier *signalSizeSpecifier = [self specifierForID:@"SignalSize"];
		[self setPreferenceValue:@(5.0) specifier:signalSizeSpecifier];
		[self reloadSpecifier:signalSizeSpecifier];
	}

	if (![settings objectForKey:@"wifiSize"]) {
		PSSpecifier *wifiSizeSpecifier = [self specifierForID:@"WifiSize"];
		[self setPreferenceValue:@(5.0) specifier:wifiSizeSpecifier];
		[self reloadSpecifier:wifiSizeSpecifier];
	}

	if (![settings objectForKey:@"batterySize"]) {
		PSSpecifier *batterySizeSpecifier = [self specifierForID:@"BatterySize"];
		[self setPreferenceValue:@(5.0) specifier:batterySizeSpecifier];
		[self reloadSpecifier:batterySizeSpecifier];
	}
}

- (void)respring {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"CRPromptRespring" object:nil];
}

- (void)twitter{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/insanj"]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=insanj"]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=insanj"]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=insanj"]];

	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/insanj"]];
}

@end

@interface CRCreditsCell : PSTableCell
@end

@implementation CRCreditsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self.textLabel.numberOfLines = 0;
	    self.textLabel.font = [UIFont systemFontOfSize:14.0];
	    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
	}

	return self;
}

@end
