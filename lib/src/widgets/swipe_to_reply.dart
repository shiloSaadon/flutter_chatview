/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reply_icon.dart';

class SwipeToReply extends StatefulWidget {
  const SwipeToReply({
    Key? key,
    required this.onSwipe,
    required this.child,
    this.isMessageByCurrentUser = true,
  }) : super(key: key);

  /// Provides callback when user swipes chat bubble from left side.
  final VoidCallback onSwipe;

  /// Allow user to set widget which is showed while user swipes chat bubble.
  final Widget child;

  /// A boolean variable that indicates if the message is sent by the current user.
  ///
  /// This is `true` if the message is authored by the sender (the current user),
  /// and `false` if it is authored by someone else.
  final bool isMessageByCurrentUser;

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply> {
  double paddingValue = 0;
  double trackPaddingValue = 0;
  double initialTouchPoint = 0;
  bool isCallBackTriggered = false;
  bool startFeddback = false;

  late bool isMessageByCurrentUser = widget.isMessageByCurrentUser;

  final paddingLimit = 50;
  final double replyIconSize = 25;
  final double replyPadding = 15;

  @override
  Widget build(BuildContext context) {
    return !(chatViewIW?.featureActiveConfig.enableSwipeToReply ?? true)
        ? widget.child
        : GestureDetector(
            onHorizontalDragStart: (details) =>
                initialTouchPoint = details.globalPosition.dx,
            onHorizontalDragEnd: (details) => setState(
              () {
                _onHorizontalDragEnd(details);
                paddingValue = 0;
                isCallBackTriggered = false;
              },
            ),
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            child: Stack(
              alignment: isMessageByCurrentUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              fit: StackFit.passthrough,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: replyPadding),
                  child: ReplyIcon(
                    replyIconSize: replyIconSize,
                    animationValue:
                        paddingValue > (replyIconSize + replyPadding)
                            ? (paddingValue) / (paddingLimit)
                            : 0.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: isMessageByCurrentUser ? paddingValue : 0,
                    start: isMessageByCurrentUser ? 0 : paddingValue,
                  ),
                  child: widget.child,
                ),
              ],
            ),
          );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // Apply feedback
    if (paddingValue >= paddingLimit && !startFeddback) {
      startFeddback = true;
      HapticFeedback.lightImpact();
    }
    // Release the feedback key
    if (startFeddback && paddingValue < (paddingLimit - 10)) {
      startFeddback = false;
    }

    // Handle other logic
    final swipeDistance = isMessageByCurrentUser
        ? (initialTouchPoint - details.globalPosition.dx)
        : (details.globalPosition.dx - initialTouchPoint);

    if (swipeDistance >= 0 && trackPaddingValue < paddingLimit) {
      setState(() {
        paddingValue = swipeDistance;
      });
    }
    // else if (paddingValue >= paddingLimit) {
    //   // if (!isCallBackTriggered) {
    //   //   widget.onSwipe();
    //   //   isCallBackTriggered = true;
    //   // }
    // } else {
    //   setState(() {
    //     paddingValue = 0;
    //   });
    // }
    trackPaddingValue = swipeDistance;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Handle other logic
    if (paddingValue >= paddingLimit) {
      if (!isCallBackTriggered) {
        widget.onSwipe();
        isCallBackTriggered = true;
      }
    }
  }
}
