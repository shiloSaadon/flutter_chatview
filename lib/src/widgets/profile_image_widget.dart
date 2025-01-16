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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/data_models/chat_user.dart';
import '../values/enumeration.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    this.user,
    this.circleRadius,
  });

  /// Allow user to set radius of circle avatar.
  final double? circleRadius;

  final ChatUser? user;

  String? get imageUrl => user?.profilePhoto;

  @override
  Widget build(BuildContext context) {
    final radius = (circleRadius ?? 20) * 2;
    return ClipRRect(
      borderRadius: BorderRadius.circular(circleRadius ?? 20),
      child: imageUrl == null || imageUrl!.isEmpty
          ? _defaultWidget(context, radius)
          : switch (user!.imageType) {
              ImageType.asset => Image.asset(
                  imageUrl!,
                  height: radius,
                  width: radius,
                  fit: BoxFit.cover,
                  errorBuilder: user?.assetImageErrorBuilder ?? _errorWidget,
                ),
              ImageType.network => CachedNetworkImage(
                  imageUrl: imageUrl!,
                  height: radius,
                  width: radius,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: user?.networkImageProgressIndicatorBuilder,
                  errorWidget: user?.networkImageErrorBuilder ?? _networkImageErrorWidget,
                ),
              ImageType.base64 => Image.memory(
                  base64Decode(imageUrl!),
                  height: radius,
                  width: radius,
                  fit: BoxFit.cover,
                  errorBuilder: user?.assetImageErrorBuilder ?? _errorWidget,
                ),
            },
    );
  }

  Widget _networkImageErrorWidget(BuildContext context, String url, Object error) {
    return const Center(
      child: Icon(
        Icons.error_outline,
        size: 18,
      ),
    );
  }

  Widget _errorWidget(BuildContext context, Object error, StackTrace? stackTrace) {
    return const Center(
      child: Icon(
        Icons.error_outline,
        size: 18,
      ),
    );
  }

  Widget _defaultWidget(BuildContext context, double radius) {
    assert(user?.noImageUrlBuilder != null);
    return SizedBox.square(
      dimension: radius,
      child: user!.noImageUrlBuilder!(context),
    );
  }
}
