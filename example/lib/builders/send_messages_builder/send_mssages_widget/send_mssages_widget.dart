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
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/utils/package_strings.dart';
import 'package:chatview/src/widgets/chatui_textfield.dart';
import 'package:chatview/src/widgets/reply_message_view.dart';
import 'package:chatview/src/widgets/scroll_to_bottom_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class MySendMessageWidget extends StatefulWidget {
  const MySendMessageWidget({required this.sendMessageController});

  final SendMessageController sendMessageController;

  @override
  State<MySendMessageWidget> createState() => MySendMessageWidgetState();
}

class MySendMessageWidgetState extends State<MySendMessageWidget> {
  final GlobalKey textFieldKey = GlobalKey();
  double height = 0.0;
  Widget scrollToButton() {
    if (chatViewIW?.featureActiveConfig.enableScrollToBottomButton ?? true)
      return const Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: ScrollToBottomButton(),
        ),
      );
    return const SizedBox.shrink();
  }

  @override
  void initState() {
    super.initState();
    widget.sendMessageController.textEditingController.addListener(updateUi);
  }

  void updateUi() {
    _updateLineCount();
    // setState(() {});
  }

  void _updateLineCount() {
    final renderObj =
        (textFieldKey.currentContext?.findRenderObject() as RenderBox?);
    if (renderObj == null) {
      print("Null ignore");
      return;
    }

    // final heightPerLine = textPainter.preferredLineHeight;
    // final totalHeight = textPainter.size.height;
    // final lineCount = (totalHeight / heightPerLine).ceil();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("amount -> ${renderObj.size.height}");
      //
      final newHight = renderObj.size.height;
      if (height == newHight) return;
      height = newHight;
      widget.sendMessageController.updateMessagesListSize();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final lines = widget.sendMessageController.textEditingController.text;
    // final _newlineCount = '\n'.allMatches(lines).length;
    // print("amount -> $_newlineCount");
    print(":Cange");
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          scrollToButton(),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Colors.white.withOpacity(.8),
            ),
            key: chatViewIW?.chatTextFieldViewKey,
            padding: EdgeInsets.fromLTRB(
              bottomPadding4,
              bottomPadding4,
              bottomPadding4,
              _bottomPadding,
            ),
            child: Column(
              // alignment: Alignment.bottomCenter,
              children: [
                ValueListenableBuilder<ReplyMessage>(
                  builder: (_, state, child) {
                    final replyTitle =
                        '${PackageStrings.replyTo} ${widget.sendMessageController.replyTo}';
                    if (state.message.isNotEmpty) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                            bottom: Radius.circular(14),
                          ),
                        ),
                        margin: EdgeInsets.only(
                          bottom: 10,
                          // right: 0.4,
                          // left: 0.4,
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          leftPadding,
                          leftPadding,
                          leftPadding,
                          30,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      replyTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    onPressed:
                                        widget.sendMessageController.onCloseTap,
                                  ),
                                ],
                              ),
                              ReplyMessageView(
                                message: state,
                                // customMessageReplyViewBuilder: widget
                                //     .messageConfig
                                //     ?.customMessageReplyViewBuilder,
                                // sendMessageConfig: widget.sendMessageConfig,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  valueListenable:
                      widget.sendMessageController.replyMessageListener,
                ),
                ChatUITextField(
                  textFieldKey: textFieldKey,
                  focusNode: widget.sendMessageController.focusNode,
                  textEditingController:
                      widget.sendMessageController.textEditingController,
                  onPressed: widget.sendMessageController.onPressed,
                  sendMessageConfig: SendMessageConfiguration(
                      textFieldConfig: TextFieldConfiguration(
                    onMessageTyping: (status) {
                      /// Do with status
                      debugPrint(status.toString());
                    },
                    compositionThresholdTime: const Duration(seconds: 1),
                    textStyle: TextStyle(color: Colors.black),
                  )),
                  //widget.sendMessageConfig,
                  onRecordingComplete:
                      widget.sendMessageController.onRecordingComplete,
                  onImageSelected: widget.sendMessageController.onImageSelected,
                )
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
    // widget.sendMessageController.dispose();
    super.dispose();
  }
}

const double bottomPadding1 = 10;
const double bottomPadding2 = 22;
const double bottomPadding3 = 12;
const double bottomPadding4 = 6;
const double leftPadding = 9;
