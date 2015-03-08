//
//  NetworkingConstants.h
//  GreenUpVt
//
//  Created by Jordan Rouille on 5/31/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#ifndef GreenUpVt_NetworkingConstants_h
#define GreenUpVt_NetworkingConstants_h

#define THEME_UPLOAD_QUEUE_LENGTH 5

#warning UPDATE BASE URL HERE AND ENDPOINT URLS
#define THEME_BASE_URL @"http://greenupapi.xenonapps.com/api/"
#define THEME_API_PORT 80

#define THEME_HEAT_MAP_RELATIVE_URL @"heatmap"
#define THEME_COMMENTS_RELATIVE_URL @"comments"
#define THEME_PINS_RELATIVE_URL @"pins"
#define THEME_MESSAGES_RELATIVE_URL @"comments"
#define THEME_HOME_MESSAGES_RELATIVE_URL @"welcome"


//ALERTS
#define ALERT_COULD_NOT_GET_MESSAGE_BY_ID @"We were unable to find the message you are looking for"
#define ALERT_COULD_NOT_GET_MESSAGES @"We were unable to get messages, please make sure you have a network connection"
#define ALERT_COULD_NOT_POST_MESSAGE @"We were unable to post your message, please make sure you have a network connection"

#define ALERT_COULD_NOT_GET_HEAT_MAP_DATA @"We were unable to get any heat map data, please make sure you have a network connection"

//------------ DO NOT CHANGE -------------
//NOTIFICATIONS
#define NOTIFICATOIN_FINISHED_GETTING_MESSAGE_BY_ID @"finishedGettingMessageByID"
#define NOTIFICATOIN_FINISHED_GETTING_MESSAGES @"finishedGettingMessages"

#define NOTIFICATOIN_FINISHED_GETTING_HEAT_MAP_DATA @"finishedGettingHeatMapData"
#define NOTIFICATOIN_FINISHED_GETTING_HEAT_MAP_DATA @"finishedGettingHeatMapData"
#define NOTIFICATOIN_FINISHED_GETTING_HEAT_MAP_DATA @"finishedGettingHeatMapData"
//------------ DO NOT CHANGE -------------


#endif
