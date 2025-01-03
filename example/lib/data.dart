import 'package:chatview/chatview.dart';

class Data {
  static const profileImage =
      "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";
  static final messageList = {
    Message(
      id: '-1',
      content: TextMessage(text: "Day ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.read,
    ),
    Message(
      id: '-2',
      content: TextMessage(text: "2 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 2)),
      sentBy: '2',
      status: MessageStatus.read,
    ),
    Message(
      id: '-3',
      content: TextMessage(text: "3 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 3)),
      sentBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '-4',
      content: TextMessage(text: "50 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 50)),
      sentBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '1',
      content: TextMessage(text: "Hi!"),
      sentAt: DateTime.now(),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.read,
    ),
    Message(
      id: '2',
      content: TextMessage(text: "Hi!"),
      sentAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.read,
    ),
    Message(
      id: '3',
      content: TextMessage(text: "We can meet?I am free"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '4',
      content: TextMessage(text: "Can you write the time and place of the meeting?"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
    ),
    Message(
      id: '5',
      content: TextMessage(text: "That's fine"),
      sentAt: DateTime.now(),
      sentBy: '2',
      reactions: {},
      status: MessageStatus.read,
    ),
    Message(
      id: '6',
      content: TextMessage(text: "When to go ?"),
      sentAt: DateTime.now(),
      sentBy: '3',
      status: MessageStatus.read,
    ),
    Message(
      id: '7',
      content: TextMessage(text: "I guess Simform will reply"),
      sentAt: DateTime.now(),
      sentBy: '4',
      status: MessageStatus.read,
    ),
    Message(
      id: '8',
      content: TextMessage(text: "https://bit.ly/3JHS2Wl"),
      sentAt: DateTime.now(),
      sentBy: '2',
      reactions: {},
      status: MessageStatus.read,
      replyOfMsg: ReplyMessage(
        id: '4',
        sentAt: DateTime.now(),
        content: TextMessage(text: "Can you write the time and place of the meeting?"),
        sentBy: '1',
      ),
    ),
    Message(
      id: '9',
      content: TextMessage(text: "Done"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.read,
      reactions: {},
    ),
    Message(
      id: '12',
      content: TextMessage(text: "🤩🤩"),
      sentAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.read,
    ),
  };
}
