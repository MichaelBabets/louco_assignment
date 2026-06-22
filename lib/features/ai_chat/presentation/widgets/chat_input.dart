import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_theme.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.onSubmit});

  final ValueChanged<String> onSubmit;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSubmit(text);
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final safeArea = MediaQuery.paddingOf(context).bottom;
    final bottomPad = keyboard > 0 ? 10.0 : safeArea + 10.0;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPad),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 6,
                top: 4,
                bottom: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderColor, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: context.l10n.aiChatInputHint,
                        hintStyle: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _submit(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 11),
                  _InputTrailingButton(
                    asset: 'assets/icons/micro.svg',
                    onTap: () {},
                  ),
                  const SizedBox(width: 11),
                  if (_hasText)
                    _SendButton(onTap: _submit)
                  else
                    _InputTrailingButton(
                      asset: 'assets/icons/speach.svg',
                      onTap: () {},
                    ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputTrailingButton extends StatelessWidget {
  const _InputTrailingButton({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.chipBackground,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xFF28292B),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.rotate(
            angle: -36.75 * pi / 180,
            child: const Icon(
              Icons.send,
              color: AppColors.textPrimary,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
