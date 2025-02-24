import 'package:chatview/chatview.dart';

class Data {
  static const profileImage =
      "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";
  static final messageList = <MessageBase>{
    SystemMessage(
      id: '-7868543',
      idGroup: '1',
      content: TextMessage(text: "System message!!!!!!"),
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UserMessage(
      id: '-1',
      idGroup: '1',
      content: TextMessage(text: "Day ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '-2',
      idGroup: '1',
      content: TextMessage(text: "2 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 2)),
      sentBy: '2',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '-3',
      idGroup: '1',
      content: TextMessage(text: "3 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 3)),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '-4',
      idGroup: '1',
      content: TextMessage(text: "50 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 50)),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '1',
      idGroup: '1',
      content: TextMessage(text: "Hi!"),
      sentAt: DateTime.now(),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '2',
      idGroup: '1',
      content: TextMessage(text: "Hi!"),
      sentAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '3',
      idGroup: '1',
      content: TextMessage(text: "We can meet?I am free"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '4',
      idGroup: '1',
      content:
          TextMessage(text: "Can you write the time and place of the meeting?"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '5',
      idGroup: '1',
      content: TextMessage(text: "That's fine"),
      sentAt: DateTime.now(),
      sentBy: '2',
      reactions: {},
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '6',
      idGroup: '1',
      content: TextMessage(text: "When to go ?"),
      sentAt: DateTime.now(),
      sentBy: '3',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '7',
      idGroup: '1',
      content: TextMessage(text: "I guess Simform will reply"),
      sentAt: DateTime.now(),
      sentBy: '4',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '8',
      idGroup: '1',
      content: TextMessage(text: "https://bit.ly/3JHS2Wl"),
      sentAt: DateTime.now(),
      sentBy: '2',
      reactions: {},
      status: MessageStatus.delivered,
      replyOfMsg: ReplyMessage(
        id: '4',
        sentAt: DateTime.now(),
        idGroup: '1',
        content: TextMessage(
            text: "Can you write the time and place of the meeting?"),
        sentBy: '2',
      ),
    ),
    UserMessage(
      id: '9',
      idGroup: '1',
      content: TextMessage(text: "Done"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.delivered,
      reactions: {},
    ),
    UserMessage(
      id: '12',
      idGroup: '1',
      content: TextMessage(text: "🤩🤩"),
      sentAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '-100',
      idGroup: '1',
      content: TextMessage(text: "Day ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '-200',
      idGroup: '1',
      content: TextMessage(text: "2 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 2)),
      sentBy: '2',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '-300',
      idGroup: '1',
      content: TextMessage(text: "3 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 3)),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '-400',
      idGroup: '1',
      content: TextMessage(text: "50 Days ago"),
      sentAt: DateTime.now().subtract(const Duration(days: 50)),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '100',
      idGroup: '1',
      content: TextMessage(text: "Hi!"),
      sentAt: DateTime.now(),
      sentBy: '1', // userId of who sends the message
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '200',
      idGroup: '1',
      content: TextMessage(text: "Hi!"),
      sentAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '300',
      idGroup: '1',
      content: TextMessage(text: "We can meet?I am free"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '400',
      idGroup: '1',
      content:
          TextMessage(text: "Can you write the time and place of the meeting?"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '500',
      idGroup: '1',
      content: TextMessage(text: "That's fine"),
      sentAt: DateTime.now(),
      sentBy: '2',
      reactions: {},
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '600',
      idGroup: '1',
      content: TextMessage(text: "When to go ?"),
      sentAt: DateTime.now(),
      sentBy: '3',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '700',
      idGroup: '1',
      content: TextMessage(text: "I guess Simform will reply"),
      sentAt: DateTime.now(),
      sentBy: '4',
      status: MessageStatus.delivered,
    ),
    UserMessage(
      id: '800',
      idGroup: '1',
      content: TextMessage(text: "https://bit.ly/3JHS2Wl"),
      sentAt: DateTime.now(),
      sentBy: '2',
      reactions: {},
      status: MessageStatus.delivered,
      replyOfMsg: ReplyMessage(
        id: '400',
        sentAt: DateTime.now(),
        idGroup: '1',
        content: TextMessage(
            text: "Can you write the time and place of the meeting?"),
        sentBy: '2',
      ),
    ),
    UserMessage(
      id: '900',
      idGroup: '1',
      content: TextMessage(text: "Done"),
      sentAt: DateTime.now(),
      sentBy: '1',
      status: MessageStatus.delivered,
      reactions: {},
    ),
    UserMessage(
      id: '1200',
      idGroup: '1',
      content: TextMessage(text: "🤩🤩"),
      sentAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.delivered,
    ),
  };
}
