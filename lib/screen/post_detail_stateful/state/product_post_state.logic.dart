
import 'package:peekaboo/common/cli_common.dart';
import 'package:peekaboo/entity/post/vo_product_post.dart';

import '../../../data/network/daangn_api.dart';

Future<ProductPost> requestPost(int id) async {
  await sleepAsync(400.ms);
  return await DaangnApi.getPost(id);
}