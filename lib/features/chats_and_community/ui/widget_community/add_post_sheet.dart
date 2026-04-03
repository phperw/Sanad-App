import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/repo/post_repository.dart';
import '../../logic/create_post_cubit.dart';

void showAddPostSheet(BuildContext context, {required String userName}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => CreatePostCubit(getIt<PostRepository>()),
      child: _AddPostSheet(userName: userName),
    ),
  );
}

class _AddPostSheet extends StatefulWidget {
  final String userName;

  const _AddPostSheet({required this.userName, super.key});

  @override
  State<_AddPostSheet> createState() => _AddPostSheetState();
}

class _AddPostSheetState extends State<_AddPostSheet> {
  final TextEditingController _contentController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  static const int _maxChars = 300;
  static const int _maxImages = 5;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final remaining = _maxImages - _selectedImages.length;
    if (remaining <= 0) return;
    final picked = await _picker.pickMultiImage();
    if (picked.isEmpty) return;
    setState(() => _selectedImages.addAll(picked.take(remaining)));
  }

  void _removeImage(int index) =>
      setState(() => _selectedImages.removeAt(index));

  void _submit() {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;
    context.read<CreatePostCubit>().createPost(content: content);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.response.message,
                style: TextStyles.cairoBold16White(context),
                textDirection: TextDirection.rtl,
              ),
              backgroundColor: AppColors.primaryColor,
            ),
          );
        } else if (state is CreatePostFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                style: TextStyles.cairoBold16White(context),
                textDirection: TextDirection.rtl,
              ),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreatePostLoading;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w(context),
                  vertical: 16.h(context),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHandle(),
                    verticalSpace(context, height: 12),
                    _buildHeader(),
                    verticalSpace(context, height: 16),
                    _buildUserRow(),
                    verticalSpace(context, height: 16),
                    _buildTextInput(),
                    verticalSpace(context, height: 16),
                    _buildImagesSection(),
                    verticalSpace(context, height: 20),
                    _buildPublishButton(isLoading),
                    verticalSpace(context, height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40.w(context),
        height: 4.h(context),
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyles.cairoBold16DarkBlue(
              context,
            ).copyWith(color: AppColors.errorColor),
          ),
        ),
        Text('منشور جديد', style: TextStyles.cairoBold16DarkBlue(context)),
        SizedBox(width: 40.w(context)),
      ],
    );
  }

  Widget _buildUserRow() {
    return Row(
      children: [
        _buildAvatar(fullName: widget.userName),
        horizontalSpace(context, width: 8),
        Text(widget.userName, style: TextStyles.cairoBold16DarkBlue(context)),
      ],
    );
  }

  Widget _buildAvatar({required String fullName}) {
    return Container(
      width: 48.w(context),
      height: 48.h(context),
      decoration: ShapeDecoration(
        color: AppColors.lightGreenishWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2.2.w(context),
            color: AppColors.chatChipBorder,
          ),
          borderRadius: BorderRadius.circular(100.r(context)),
        ),
      ),
      child: Center(
        child: Text(
          fullName.isNotEmpty ? fullName[0].toUpperCase() : '؟',
          style: TextStyles.cairoBold16DarkBlue(
            context,
          ).copyWith(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      width: double.infinity,
      height: 190.h(context),
      padding: EdgeInsets.all(16.w(context)),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r(context)),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            controller: _contentController,
            maxLength: _maxChars,
            maxLines: null,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            buildCounter:
                (_, {required currentLength, required isFocused, maxLength}) =>
                    null,
            decoration: InputDecoration(
              hintText: 'شارك إنجازك أو تجربتك مع الفريق...',
              hintStyle: TextStyles.cairoRegular12Gray(
                context,
              ).copyWith(fontSize: 16.sp(context)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyles.cairoBold16DarkBlue(
              context,
            ).copyWith(fontWeight: FontWeight.w400),
            onChanged: (_) => setState(() {}),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Text(
              '${_contentController.text.length} / $_maxChars',
              style: TextStyles.cairoRegular12Gray(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w(context)),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r(context)),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حتى $_maxImages صور',
                style: TextStyles.cairoRegular12Gray(
                  context,
                ).copyWith(fontSize: 13.sp(context)),
              ),
              Text('إضافة صور', style: TextStyles.cairoBold16DarkBlue(context)),
            ],
          ),
          verticalSpace(context, height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: [
                if (_selectedImages.length < _maxImages) _buildAddImageButton(),
                ..._selectedImages.asMap().entries.map(
                  (e) => Padding(
                    padding: EdgeInsets.only(right: 16.w(context)),
                    child: _buildImageThumbnail(e.key, e.value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 60.w(context),
        height: 60.h(context),
        decoration: ShapeDecoration(
          color: AppColors.lightGreenishWhite,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.1, color: AppColors.chatChipBorder),
            borderRadius: BorderRadius.circular(12.r(context)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: AppColors.chatChipBorder,
              size: 24.w(context),
            ),
            SizedBox(height: 4.h(context)),
            Text(
              'إضافة',
              style: TextStyles.cairoMedium12Primary(
                context,
              ).copyWith(fontSize: 11.sp(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(int index, XFile image) {
    return SizedBox(
      width: 60.w(context),
      height: 60.h(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r(context)),
            child: Image.file(
              File(image.path),
              width: 60.w(context),
              height: 60.h(context),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: -8.h(context),
            right: -8.w(context),
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 20.w(context),
                height: 20.h(context),
                decoration: const ShapeDecoration(
                  color: AppColors.errorColor,
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 12.w(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton(bool isLoading) {
    return AppButton(
      text: isLoading ? '' : 'نشر',
      onPressed: isLoading ? () {} : _submit,
      buttonColor: AppColors.primaryColor,
      borderRadius: 12,
      boxShadow: const [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}
