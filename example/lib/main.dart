import 'package:chatview/chatview.dart';
import 'package:example/builders/message_wrpper_builder/message_wrpper_builder.dart';
import 'package:example/builders/send_messages_builder/send_messages_builder.dart';
import 'package:example/data.dart';
import 'package:example/models/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Example());
}

class Pusher extends StatelessWidget {
  const Pusher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ChatScreen())),
            child: const Text('Push')),
      ),
    );
  }
}

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chat UI Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xffEE5366),
          colorScheme:
              ColorScheme.fromSwatch(accentColor: const Color(0xffEE5366)),
        ),
        home: const Pusher());
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  final _chatController = ChatController(
    initialMessageList: Data.messageList,
    scrollController: ScrollController(),
    currentUser: ChatUser(
      id: '1',
      name: 'Flutter',
      profilePhoto: Data.profileImage,
    ),
    otherUsers: {
      ChatUser(
        id: '2',
        name: 'Simform',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '3',
        name: 'Jhon',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '4',
        name: 'Mike',
        profilePhoto: Data.profileImage,
      ),
      ChatUser(
        id: '5',
        name: 'Rich',
        profilePhoto: Data.profileImage,
      ),
    },
  );

  void _showHideTypingIndicator() {
    _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
  }

  void receiveMessage() async {
    // _chatController.addMessage(
    //   Message(
    //     id: DateTime.now().toString(),
    //     message: 'I will schedule the meeting.',
    //     createdAt: DateTime.now(),
    //     sentBy: '2',
    //   ),
    // );
    await Future.delayed(const Duration(milliseconds: 500));
    _chatController.addReplySuggestions([
      const SuggestionItemData(text: 'Thanks.'),
      const SuggestionItemData(text: 'Thank you very much.'),
      const SuggestionItemData(text: 'Great.')
    ]);
  }

  final GlobalKey appBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _chatController.chatViewStateNotifier.value = ChatViewState.hasMessages;
    return ChatView(
      chatController: _chatController,
      onSendTap: _onSendTap,
      loadMoreData: () async {
        _chatController.addMessages(Data.messageList);
      },
      featureActiveConfig: const FeatureActiveConfig(
        lastSeenAgoBuilderVisibility: true,
        receiptsBuilderVisibility: true,
        enableScrollToBottomButton: true,
        //
        enableCurrentUserProfileAvatar: false,
        enableOtherUserProfileAvatar: false,
        enableOtherUserName: false,
        enableReplySnackBar: false,

        //
      ),
      scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
        backgroundColor: theme.textFieldBackgroundColor,
        border: Border.all(
          color: isDarkTheme ? Colors.transparent : Colors.grey,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.themeIconColor,
          weight: 10,
          size: 30,
        ),
      ),
      chatViewStateConfig: ChatViewStateConfiguration(
        loadingWidgetConfig: ChatViewStateWidgetConfiguration(
          widget: const Text("cewoijgerjo"),
          loadingIndicatorColor: theme.outgoingChatBubbleColor,
        ),
        onReloadButtonTap: () {},
      ),
      typeIndicatorConfig: TypeIndicatorConfiguration(
        flashingCircleBrightColor: theme.flashingCircleBrightColor,
        flashingCircleDarkColor: theme.flashingCircleDarkColor,
      ),
      appBarConfiguration:
          AppBarConfiguration(extendListBelowAppbar: true, key: appBarKey),
      appBar: ChatViewAppBar(
        key: appBarKey,
        elevation: theme.elevation,
        backGroundColor: theme.appBarColor,
        profilePicture: Data.profileImage,
        backArrowColor: theme.backArrowColor,
        chatTitle: "Chat view",
        chatTitleTextStyle: TextStyle(
          color: theme.appBarTitleTextStyle,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0.25,
        ),
        userStatus: "online",
        userStatusTextStyle: const TextStyle(color: Colors.grey),
        actions: [
          IconButton(
            onPressed: _onThemeIconTap,
            icon: Icon(
              isDarkTheme
                  ? Icons.brightness_4_outlined
                  : Icons.dark_mode_outlined,
              color: theme.themeIconColor,
            ),
          ),
          IconButton(
            tooltip: 'Toggle TypingIndicator',
            onPressed: _showHideTypingIndicator,
            icon: Icon(
              Icons.keyboard,
              color: theme.themeIconColor,
            ),
          ),
          IconButton(
            tooltip: 'Simulate Message receive',
            onPressed: receiveMessage,
            icon: Icon(
              Icons.supervised_user_circle,
              color: theme.themeIconColor,
            ),
          ),
        ],
      ),
      chatBackgroundConfig: ChatBackgroundConfiguration(
        backgroundImage:
            'https://st5.depositphotos.com/35914836/63482/i/450/depositphotos_634821438-stock-photo-beautiful-sunset-sea.jpg',
        sortEnable: true,
        messageTimeIconColor: theme.messageTimeIconColor,
        messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
        defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
          speratorBuilder: (day) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.2),
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
          textStyle: TextStyle(
            color: theme.chatHeaderColor,
            fontSize: 17,
          ),
        ),
        backgroundColor: theme.backgroundColor,
      ),
      sendMessageBuilder: sendMessageBuilder,
      // sendMessageBuilder: (onSendTap, onReplyCallback, onReplyCloseCallback,
      //         replyMessageBuilder) =>
      //     Container(
      //   color: Colors.red,
      // ),
      sendMessageConfig: SendMessageConfiguration(
        imagePickerIconsConfig: ImagePickerIconsConfiguration(
          cameraIconColor: theme.cameraIconColor,
          galleryIconColor: theme.galleryIconColor,
        ),
        replyMessageColor: theme.replyMessageColor,
        defaultSendButtonColor: theme.sendButtonColor,
        replyDialogColor: theme.replyDialogColor,
        replyTitleColor: theme.replyTitleColor,
        textFieldBackgroundColor: theme.textFieldBackgroundColor,
        closeIconColor: theme.closeIconColor,
        textFieldConfig: TextFieldConfiguration(
          onMessageTyping: (status) {
            /// Do with status
            debugPrint(status.toString());
          },
          compositionThresholdTime: const Duration(seconds: 1),
          textStyle: TextStyle(color: theme.textFieldTextColor),
        ),
        micIconColor: theme.replyMicIconColor,
        voiceRecordingConfiguration: VoiceRecordingConfiguration(
          backgroundColor: theme.waveformBackgroundColor,
          recorderIconColor: theme.recordIconColor,
          waveStyle: WaveStyle(
            showMiddleLine: false,
            waveColor: theme.waveColor ?? Colors.white,
            extendWaveform: true,
          ),
        ),
      ),
      chatBubbleConfig: ChatBubbleConfiguration(
        outgoingChatBubbleConfig: ChatBubble(
          linkPreviewConfig: LinkPreviewConfiguration(
            backgroundColor: theme.linkPreviewOutgoingChatColor,
            bodyStyle: theme.outgoingChatLinkBodyStyle,
            titleStyle: theme.outgoingChatLinkTitleStyle,
          ),
          receiptsWidgetConfig: const ReceiptsWidgetConfig(
              showReceiptsIn: ShowReceiptsIn.lastMessage),
          color: theme.outgoingChatBubbleColor,
        ),
        inComingChatBubbleConfig: ChatBubble(
          linkPreviewConfig: LinkPreviewConfiguration(
            linkStyle: TextStyle(
              color: theme.inComingChatBubbleTextColor,
              decoration: TextDecoration.underline,
            ),
            backgroundColor: theme.linkPreviewIncomingChatColor,
            bodyStyle: theme.incomingChatLinkBodyStyle,
            titleStyle: theme.incomingChatLinkTitleStyle,
          ),
          textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
          onMessageRead: (message) {
            /// send your message reciepts to the other client
            debugPrint('Message Read');
          },
          senderNameTextStyle:
              TextStyle(color: theme.inComingChatBubbleTextColor),
          color: theme.inComingChatBubbleColor,
        ),
      ),
      replyPopupConfig: ReplyPopupConfiguration(
        backgroundColor: theme.replyPopupColor,
        buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
        topBorderColor: theme.replyPopupTopBorderColor,
      ),
      reactionPopupConfig: ReactionPopupConfiguration(
        shadow: BoxShadow(
          color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
          blurRadius: 20,
        ),
        backgroundColor: theme.reactionPopupColor,
      ),
      messageConfig: MessageConfiguration(
        customMessageWrapperBuilder: messageWrapperBuilder,
        messageReactionConfig: MessageReactionConfiguration(
          backgroundColor: theme.messageReactionBackGroundColor,
          borderColor: theme.messageReactionBackGroundColor,
          reactedUserCountTextStyle:
              TextStyle(color: theme.inComingChatBubbleTextColor),
          reactionCountTextStyle:
              TextStyle(color: theme.inComingChatBubbleTextColor),
          reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
            backgroundColor: theme.backgroundColor,
            reactedUserTextStyle: TextStyle(
              color: theme.inComingChatBubbleTextColor,
            ),
            reactionWidgetDecoration: BoxDecoration(
              color: theme.inComingChatBubbleColor,
              boxShadow: [
                BoxShadow(
                  color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                  offset: const Offset(0, 20),
                  blurRadius: 40,
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        imageMessageConfig: ImageMessageConfiguration(
          imageUrlGetter: (idMsg, img) => 'you_construct_your_url_here',
          networkImageHeaders: {},
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          shareIconConfig: ShareIconConfiguration(
            defaultIconBackgroundColor: theme.shareIconBackgroundColor,
            defaultIconColor: theme.shareIconColor,
          ),
        ),
      ),
      profileCircleConfig: const ProfileCircleConfiguration(
          bottomPadding: 0,
          padding: EdgeInsets.zero,
          profileImageUrl: Data.profileImage,
          circleRadius: 10),
      repliedMessageConfig: RepliedMessageConfiguration(
        displyeReply: false,
        backgroundColor: theme.repliedMessageColor,
        verticalBarColor: theme.verticalBarColor,
        repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
          enableHighlightRepliedMsg: true,
          highlightColor: Colors.pinkAccent.shade100,
          highlightScale: 1.1,
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.25,
        ),
        replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
      ),
      swipeToReplyConfig: SwipeToReplyConfiguration(
        replyIconColor: theme.swipeToReplyIconColor,
      ),
      replySuggestionsConfig: ReplySuggestionsConfig(
        itemConfig: SuggestionItemConfig(
          decoration: BoxDecoration(
            color: theme.textFieldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.outgoingChatBubbleColor ?? Colors.white,
            ),
          ),
          textStyle: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        onTap: (item) => _onSendTap(TextMessage(text: item.text), null),
      ),
    );
  }

  void _onSendTap(
    MessageContent content,
    ReplyMessage? replyMessage,
  ) {
    _chatController.addMessage(
      UserMessage<MessageContent>(
        id: DateTime.now().toString(),
        idGroup: '1',
        sentAt: DateTime.now(),
        sentBy: _chatController.currentUser.id,
        replyOfMsg: replyMessage,
        content: content,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.setMessageStatus(
          _chatController.initialMessageList.last.asUserMsg!,
          MessageStatus.undelivered);
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.setMessageStatus(
          _chatController.initialMessageList.last.asUserMsg!,
          MessageStatus.delivered);
    });
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}
