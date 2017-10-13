//
//  Header.h
//  小农人
//
//  Created by tomusng on 2017/9/14.
//  Copyright © 2017年 Json.tomsung. All rights reserved.
//

#ifndef Header_h
#define Header_h



//#define UdpServerHost @"123.56.193.207"
//#define TcpCustomHost @"123.56.193.207"

#define TOM_HOST @""

//图片
#define GLOBAL_HOST_P @""

//获取屏幕的宽高
#define k_WIDTH [UIScreen mainScreen].bounds.size.width
#define k_HEIGHT [UIScreen mainScreen].bounds.size.height

//注册请求
//#define KRegister @"%@/api2/EngineerShop/GetEngineerSignup?Name=%@&Mobile=%@&InviteCode=%@"


//#ifndef DQPrefixHeader_pch
//#define DQPrefixHeader_pch
//#import "Masonry.h"
/** 16进制转RGB*/
#define HEX_COLOR(x_RGB) [UIColor colorWithRed:((float)((x_RGB & 0xFF0000) >> 16))/255.0 green:((float)((x_RGB & 0xFF00) >> 8))/255.0 blue:((float)(x_RGB & 0xFF))/255.0 alpha:1.0f]


// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.


#pragma mark ----------产品搜索----------------
#define KSearch @""



#define KColorDetail @""

/**
/**获取主页信息 */
#define HomePageNews @""

#define HomePageN @""















#endif /* Header_h */
