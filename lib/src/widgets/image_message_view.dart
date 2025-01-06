// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'dart:convert';
import 'dart:io';

import 'package:chatview/chatview.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/models.dart';
import 'package:flutter/material.dart';

import 'share_icon.dart';

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({
    Key? key,
    required this.idMsg,
    required this.messageContent,
    required this.isMessageBySender,
    required this.imageMessageConfig,
    this.messageReactionConfig,
    this.highlightImage = false,
    this.highlightScale = 1.2,
    this.reactions = const {},
  }) : super(key: key);

  final String idMsg;
  final ImageMessage messageContent;
  final Set<Reaction> reactions;
  final bool isMessageBySender;
  final ImageMessageConfiguration imageMessageConfig;
  final MessageReactionConfiguration? messageReactionConfig;
  final bool highlightImage;
  final double highlightScale;

  ChatImage get image => messageContent.image;

  @override
  Widget build(BuildContext context) {
    return image.file != null
        ? _ImageShell(
            idImage: image.id,
            imageUrl: image.file!.path,
            image: FileImage(File(image.file!.path)),
            messageContent: messageContent,
            reactions: reactions,
            isMessageBySender: isMessageBySender,
            imageMessageConfig: imageMessageConfig,
            messageReactionConfig: messageReactionConfig,
            highlightImage: highlightImage,
            highlightScale: highlightScale,
          )
        : FutureBuilder(
            future: imageMessageConfig.remoteUrlGetter(idMsg, image),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                return _ImageShell(
                  idImage: image.id,
                  imageUrl: snapshot.requireData,
                  image: NetworkImage(snapshot.requireData),
                  messageContent: messageContent,
                  reactions: reactions,
                  isMessageBySender: isMessageBySender,
                  imageMessageConfig: imageMessageConfig,
                  messageReactionConfig: messageReactionConfig,
                  highlightImage: highlightImage,
                  highlightScale: highlightScale,
                );
              }
              // Is this loading state???
              return const CircularProgressIndicator();
            },
          );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final String idImage;

  const FullScreenImageView({Key? key, required this.imageUrl, required this.idImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: idImage,
            child: (() {
              if (imageUrl.isUrl) {
                return Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                );
              } else if (imageUrl.fromMemory) {
                return Image.memory(
                  base64Decode(imageUrl.substring(imageUrl.indexOf('base64') + 7)),
                  fit: BoxFit.contain,
                );
              } else {
                return Image.file(
                  File(imageUrl),
                  fit: BoxFit.contain,
                );
              }
            }()),
          ),
        ),
      ),
    );
  }
}

class _ImageShell extends StatelessWidget {
  final String idImage;
  final String imageUrl;
  final ImageProvider image;
  final ImageMessage messageContent;
  final Set<Reaction> reactions;
  final bool isMessageBySender;
  final ImageMessageConfiguration imageMessageConfig;
  final MessageReactionConfiguration? messageReactionConfig;
  final bool highlightImage;
  final double highlightScale;
  const _ImageShell({
    Key? key,
    required this.idImage,
    required this.imageUrl,
    required this.image,
    required this.messageContent,
    required this.reactions,
    required this.isMessageBySender,
    required this.imageMessageConfig,
    required this.messageReactionConfig,
    required this.highlightImage,
    required this.highlightScale,
  }) : super(key: key);

  Widget get iconButton => ShareIcon(
        shareIconConfig: imageMessageConfig.shareIconConfig,
        imageUrl: imageUrl,
      );

  void _openFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          print("egrwrw");
          return FadeTransition(
            opacity: animation,
            child: FullScreenImageView(
              idImage: idImage,
              imageUrl: imageUrl,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => _openFullScreenImage(context),
              child: Hero(
                tag: idImage,
                child: Transform.scale(
                  scale: highlightImage ? highlightScale : 1.0,
                  alignment: isMessageBySender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: imageMessageConfig.padding ?? EdgeInsets.zero,
                    margin: imageMessageConfig.margin ??
                        EdgeInsets.only(
                          top: 6,
                          right: isMessageBySender ? 6 : 0,
                          left: isMessageBySender ? 0 : 6,
                          bottom: reactions.isNotEmpty ? 15 : 0,
                        ),
                    height: imageMessageConfig.height ?? 200,
                    width: imageMessageConfig.width ?? 150,
                    child: ClipRRect(
                      borderRadius: imageMessageConfig.borderRadius ?? BorderRadius.circular(14),
                      child: Image(
                        image: image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // if (message.reaction.reactions.isNotEmpty)
            //   ReactionWidget(
            //     isMessageBySender: isMessageBySender,
            //     reaction: message.reaction,
            //     messageReactionConfig: messageReactionConfig,
            //   ),
          ],
        ),
        if (!isMessageBySender && !imageMessageConfig.hideShareIcon) iconButton,
      ],
    );
  }
}
