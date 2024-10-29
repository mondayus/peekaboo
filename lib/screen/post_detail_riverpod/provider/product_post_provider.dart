import 'package:peekaboo/data/network/daangn_api.dart';
import 'package:peekaboo/entity/post/vo_product_post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final productPostProvider = AutoDisposeFutureProviderFamily<ProductPost,int>((ref, id) async {
  return await DaangnApi.getPost(id);
});
