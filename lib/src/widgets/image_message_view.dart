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
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart' hide Config;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
    final url = imageMessageConfig.imageUrlGetter(idMsg, image);
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
        : _ImageShell(
            idImage: image.id,
            imageUrl: url,
            image: CachedNetworkImageProvider(
              url,
              cacheManager: CacheManager(
                Config(
                  'imagesCacheManager',
                  maxNrOfCacheObjects: 1000,
                  stalePeriod: const Duration(days: 7),
                ),
              ),
              cacheKey: url,
              headers: imageMessageConfig.networkImageHeaders,
            ),
            messageContent: messageContent,
            reactions: reactions,
            isMessageBySender: isMessageBySender,
            imageMessageConfig: imageMessageConfig,
            messageReactionConfig: messageReactionConfig,
            highlightImage: highlightImage,
            highlightScale: highlightScale,
          );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String idImage;
  final ImageProvider image;

  const FullScreenImageView({
    super.key,
    required this.image,
    required this.idImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: idImage,
                  child: Image(
                    image: image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.5),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.close_rounded),
                            ),
                          ),
                        ),
                      ),
                    )),
              )
            ],
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
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: FullScreenImageView(
              idImage: idImage,
              image: image,
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
      mainAxisAlignment:
          isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => _openFullScreenImage(context),
              child: Hero(
                tag: idImage,
                child: Transform.scale(
                  scale: highlightImage ? highlightScale : 1.0,
                  alignment: isMessageBySender
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                      borderRadius: imageMessageConfig.borderRadius ??
                          BorderRadius.circular(14),
                      child: Image(
                        image: image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
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
