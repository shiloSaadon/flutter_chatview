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
import 'dart:io' if (kIsWeb) 'dart:html';

import 'package:chatview/chatview.dart';
import 'package:chatview/src/controller/send_message_controller.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/utils/package_strings.dart';
import 'package:chatview/src/widgets/chatui_textfield.dart';
import 'package:chatview/src/widgets/reply_message_view.dart';
import 'package:chatview/src/widgets/scroll_to_bottom_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({
    Key? key,
    required this.sendMessageController,
    this.sendMessageConfig,
    this.sendMessageBuilder,
    this.messageConfig,
    this.replyMessageBuilder,
  }) : super(key: key);

  ///
  final SendMessageController sendMessageController;

  /// Provides configuration for text field appearance.
  final SendMessageConfiguration? sendMessageConfig;

  /// Allow user to set custom text field.
  final SendMessageWithReturnWidget? sendMessageBuilder;

  /// Provides configuration of all types of messages.
  final MessageConfiguration? messageConfig;

  /// Provides a callback for the view when replying to message
  final CustomViewForReplyMessage? replyMessageBuilder;

  @override
  State<SendMessageWidget> createState() => SendMessageWidgetState();
}

class SendMessageWidgetState extends State<SendMessageWidget> {
  // final _textEditingController = TextEditingController();
  // final ValueNotifier<ReplyMessage> _replyMessage =
  //     ValueNotifier(const ReplyMessage());

  // ReplyMessage get replyMessage => _replyMessage.value;
  // final _focusNode = FocusNode();

  // ChatUser? get repliedUser => replyMessage.replyTo.isNotEmpty
  //     ? chatViewIW?.chatController.getUserFromId(replyMessage.replyTo)
  //     : null;

  // String get _replyTo => replyMessage.replyTo == currentUser?.id
  //     ? PackageStrings.you
  //     : repliedUser?.name ?? '';

  // ChatUser? currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Init current user
    if (chatViewIW != null) {
      widget.sendMessageController.currentUser =
          chatViewIW!.chatController.currentUser;
    }

    // Init replaied user
    widget.sendMessageController.repliedUser = widget
            .sendMessageController.replyMessage.replyTo.isNotEmpty
        ? chatViewIW?.chatController
            .getUserFromId(widget.sendMessageController.replyMessage.replyTo)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final scrollToBottomButtonConfig =
        chatListConfig.scrollToBottomButtonConfig;
    return widget.sendMessageBuilder != null
        ? widget.sendMessageBuilder!(widget.sendMessageController)
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // This has been added to prevent messages from being
                // displayed below the text field
                // when the user scrolls the message list.
                // Positioned(
                //   right: 0,
                //   left: 0,
                //   bottom: 0,
                //   child: Container(
                //     height: MediaQuery.of(context).size.height /
                //         ((!kIsWeb && Platform.isIOS) ? 24 : 28),
                //     color:
                //         chatListConfig.chatBackgroundConfig.backgroundColor ??
                //             Colors.white,
                //   ),
                // ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (chatViewIW?.featureActiveConfig
                              .enableScrollToBottomButton ??
                          true)
                        Align(
                          alignment: scrollToBottomButtonConfig
                                  ?.alignment?.alignment ??
                              Alignment.bottomCenter,
                          child: Padding(
                            padding: scrollToBottomButtonConfig?.padding ??
                                EdgeInsets.zero,
                            child: const ScrollToBottomButton(),
                          ),
                        ),
                      Container(
                        color: chatListConfig
                                .chatBackgroundConfig.backgroundColor ??
                            Colors.white,
                        key: chatViewIW?.chatTextFieldViewKey,
                        padding: EdgeInsets.fromLTRB(
                          bottomPadding4,
                          bottomPadding4,
                          bottomPadding4,
                          _bottomPadding,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ValueListenableBuilder<ReplyMessage>(
                              builder: (_, state, child) {
                                final replyTitle =
                                    "${PackageStrings.replyTo} ${widget.sendMessageController.replyTo}";
                                if (state.message.isNotEmpty) {
                                  return widget.replyMessageBuilder
                                          ?.call(context, state) ??
                                      Container(
                                        decoration: BoxDecoration(
                                          color: widget.sendMessageConfig
                                                  ?.textFieldBackgroundColor ??
                                              Colors.white,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(14),
                                          ),
                                        ),
                                        margin: const EdgeInsets.only(
                                          bottom: 17,
                                          right: 0.4,
                                          left: 0.4,
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                          leftPadding,
                                          leftPadding,
                                          leftPadding,
                                          30,
                                        ),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 2),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: widget.sendMessageConfig
                                                    ?.replyDialogColor ??
                                                Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      replyTitle,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: widget
                                                                .sendMessageConfig
                                                                ?.replyTitleColor ??
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.25,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    constraints:
                                                        const BoxConstraints(),
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: widget
                                                              .sendMessageConfig
                                                              ?.closeIconColor ??
                                                          Colors.black,
                                                      size: 16,
                                                    ),
                                                    onPressed: widget
                                                        .sendMessageController
                                                        .onCloseTap,
                                                  ),
                                                ],
                                              ),
                                              ReplyMessageView(
                                                message: state,
                                                customMessageReplyViewBuilder:
                                                    widget.messageConfig
                                                        ?.customMessageReplyViewBuilder,
                                                sendMessageConfig:
                                                    widget.sendMessageConfig,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                              valueListenable: widget
                                  .sendMessageController.replyMessageListener,
                            ),
                            ChatUITextField(
                              focusNode: widget.sendMessageController.focusNode,
                              textEditingController: widget
                                  .sendMessageController.textEditingController,
                              onPressed: widget.sendMessageController.onPressed,
                              sendMessageConfig: widget.sendMessageConfig,
                              onRecordingComplete: widget
                                  .sendMessageController.onRecordingComplete,
                              onImageSelected:
                                  widget.sendMessageController.onImageSelected,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  double get _bottomPadding => (!kIsWeb && Platform.isIOS)
      ? (widget.sendMessageController.focusNode.hasFocus
          ? bottomPadding1
          : View.of(context).viewPadding.bottom > 0
              ? bottomPadding2
              : bottomPadding3)
      : bottomPadding3;

  @override
  void dispose() {
    widget.sendMessageController.dispose();
    super.dispose();
  }
}
