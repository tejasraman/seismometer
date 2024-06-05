library earthquake_detection.globals;
import 'apikeys.dart' as apikeys;

var samples = 0;

final Map<String, dynamic> responseBody = {
  "app_id": "${apikeys.ONESIGNAL_APPID}",
  "contents": {
    "en": "There is currently a high risk of an earthquake"
  },
  "included_segments": ["Total Subscriptions"],
  "headings": {
    "en": "SEVERE EARTHQUAKE ALERT"
  },
  "android_accent_color": "FFFF0000",
  "android_channel_id": "${apikeys.CHANNEL_ID}"
};

const SEND_NOT = false;