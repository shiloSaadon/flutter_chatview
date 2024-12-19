import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

import 'send_mssages_widget/send_mssages_widget.dart';

Widget sendMessageBuilder(
  SendMessageController sendMessageController,
) {
  return MySendMessageWidget(
    sendMessageController: sendMessageController,
  );
}
