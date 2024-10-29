import 'package:peekaboo/common/cli_common.dart';
import 'package:peekaboo/data/network/result/api_error.dart';
import 'package:peekaboo/entity/dummies.dart';
import 'package:peekaboo/screen/notification/vo/notification_dummies.dart';
import 'package:peekaboo/screen/notification/vo/vo_notification.dart';

import '../../entity/post/vo_product_post.dart';
import '../simple_result.dart';

class DaangnApi {
  static Future<SimpleResult<List<DaangnNotification>, ApiError>> getNotification() async {
    await sleepAsync(500.ms);
    return SimpleResult.success(notificationList);
  }

  static Future<ProductPost> getPost(int id) async {
    await sleepAsync(500.ms);
    return ProductPost(
        simpleProductPost: post1,
        content: '깨끗하게 잘 쓰던 물건이에요.'
            '잘 쓰면 좋겠습니다.'
            '감사합니다.');
  }
}
