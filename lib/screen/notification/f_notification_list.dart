import 'package:peekaboo/screen/notification/provider/notification_provider.dart';
import 'package:peekaboo/screen/notification/vo/notification_dummies.dart';
import 'package:peekaboo/screen/notification/w_notification_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationFragment extends HookConsumerWidget {
  const NotificationFragment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(notificationProvider);

    return list == null
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: notificationList
                .map((e) => NotificationItemWidget(
                      notification: e,
                      onTap: () {},
                    ))
                .toList(),
          );
  }
}
