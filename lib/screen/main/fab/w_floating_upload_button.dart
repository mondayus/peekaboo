
import 'package:peekaboo/common/cli_common.dart';
import 'package:peekaboo/common/common.dart';
import 'package:peekaboo/screen/main/fab/w_floating_upload_button.riverpod.dart';
import 'package:peekaboo/screen/main/s_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widget/animated_width_collapse.dart';
import '../../write/s_write.dart';

class FloatingUploadButton extends ConsumerWidget {
  static const height = 100.0;

  FloatingUploadButton({super.key});

  final duration = 300.ms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floatingButtonState = ref.watch(floatingButtonStateProvider);
    final isExpanded = floatingButtonState.isExpanded;
    final isSmall = floatingButtonState.isSmall;
    final isHided = floatingButtonState.isHided;

    return AnimatedOpacity(
      opacity: isHided ? 0 : 1,
      duration: duration,
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: !isExpanded,
            child: AnimatedContainer(
              duration: duration,
              color: isExpanded ? Colors.black.withOpacity(0.4) : Colors.transparent,
            ),
          ),
          IgnorePointer(
            ignoring: isHided,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IgnorePointer(
                      ignoring: !isExpanded,
                      child: AnimatedOpacity(
                        opacity: isExpanded ? 1 : 0,
                        duration: duration,
                        child: Column(
                          children: [
                            Tap(
                              onTap: () {
                                Nav.push(const WriteScreen());
                              },
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(right: 15, bottom: 10),
                                decoration: BoxDecoration(
                                    color: context.appColors.floatingActionLayer,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.add),
                                    Text('업로드'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tap(
                      onTap: () async {
                       // ref.read(floatingButtonStateProvider.notifier).toggleMenu();
                        Nav.push(const WriteScreen());
                      },
                      child: AnimatedContainer(
                        duration: duration,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                            color: isExpanded
                                ? context.appColors.floatingActionLayer
                                : const Color(0xffff791f),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedRotation(
                                turns: isExpanded ? 0.125 : 0,
                                duration: duration,
                                child: const Icon(Icons.add)),
                            AnimatedWidthCollapse(
                              visible: !isSmall,
                              duration: duration,
                              child: ''.text.make(),
                            )
                          ],
                        ),
                      ),
                    ).pOnly(
                        bottom: MainScreenState.bottomNavigationBarHeight +
                            context.viewPaddingBottom +
                            10,
                        right: 20),
                  ],
                )),
          )
        ],
      ),
    );
  }

}