import 'package:cached_network_image/cached_network_image.dart';
import 'package:peekaboo/common/common.dart';
import 'package:peekaboo/entity/post/vo_simple_product_post.dart';
import 'package:peekaboo/screen/post_detail_riverpod/s_post_detail_with_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductPostItem extends StatelessWidget {
  final SimpleProductPost post;

  const ProductPostItem(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: () {
       // context.go('/main/localLife/${post.id}', extra: post);

        Nav.push(
            PostDetailScreenWithRiverpod(
              post.id,
              simpleProductPost: post,
            ),
            durationMs: 400, navAni: NavAni.Fade);
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: '${post.id}_${post.product.images[0]}',
                  child: CachedNetworkImage(
                    imageUrl: post.product.images[0],
                    width: 300,
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      timeago
                          .format(post.createdTime, locale: context.locale.languageCode)
                          .text
                          .color(context.appColors.lessImportant)
                          .make(),
                      const Width(10),
                      Hero(tag: '${post.id}_title', child: Material(
                        type: MaterialType.transparency,
                        child: post.title.text.size(17).bold.make())),
                    ]
                  ),


                ],
              ),)
            ],
          ).p(15),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined),
                  post.chatCount.text.make(),
                ],
              ),
            ),
          ).p(12)
        ],
      ),
    );
  }
}
