import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';
import '../../providers/community_provider.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/common/user_avatar.dart';

class CreatePostScreen extends StatefulWidget {
  final String? attachedRunId;

  const CreatePostScreen({super.key, this.attachedRunId});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  final List<File> _selectedMedia = [];
  final List<String> _mediaTypes = []; // 'image' or 'video'
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia({required bool isVideo}) async {
    try {
      if (isVideo) {
        final XFile? video = await _picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: AppConstants.maxVideoDurationSeconds),
        );
        if (video != null) {
          final file = File(video.path);
          final sizeInMB = file.lengthSync() / (1024 * 1024);
          if (sizeInMB > AppConstants.maxVideoSizeMB) {
            _showError('Video must be under ${AppConstants.maxVideoSizeMB}MB');
            return;
          }
          setState(() {
            _selectedMedia.add(file);
            _mediaTypes.add('video');
          });
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 80,
        );
        if (images.isNotEmpty) {
          setState(() {
            for (var img in images) {
              _selectedMedia.add(File(img.path));
              _mediaTypes.add('image');
            }
          });
        }
      }
    } catch (e) {
      _showError('Failed to select media. Please try again.');
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
      _mediaTypes.removeAt(index);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedMedia.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final communityProvider = Provider.of<CommunityProvider>(context, listen: false);
      await communityProvider.createPost(
        content,
        _selectedMedia,
        _mediaTypes,
        attachedRunId: widget.attachedRunId,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      _showError('Failed to create post. Please try again.');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userModel;
    final contentLength = _contentController.text.length;
    final isOverLimit = contentLength > AppConstants.maxPostCharacters;
    final canSubmit = (contentLength > 0 || _selectedMedia.isNotEmpty) && !isOverLimit && !_isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create Post', style: AppTextStyles.bodyLg),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: canSubmit ? _submitPost : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentNeon,
                foregroundColor: AppColors.backgroundPrimary,
                disabledBackgroundColor: AppColors.borderMuted,
                disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                ),
              ),
              child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundPrimary))
                : Text('Post', style: TextStyle(fontWeight: FontWeight.bold, color: canSubmit ? AppColors.backgroundPrimary : Colors.white70)),
            ),
          ),
        ],
      ),
      body: user == null ? const SizedBox() : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      UserAvatar(
                        username: user.username,
                        imageUrl: user.profilePicUrl.isNotEmpty ? user.profilePicUrl : null,
                        size: 40,
                      ),
                      const SizedBox(width: AppConstants.stackSm),
                      Text(
                        user.username,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.stackMd),
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    maxLength: AppConstants.maxPostCharacters,
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                      border: InputBorder.none,
                      counterText: '', // Hide default counter
                    ),
                  ),
                  
                  if (_selectedMedia.isNotEmpty)
                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(top: AppConstants.stackMd),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedMedia.length,
                        itemBuilder: (context, index) {
                          final file = _selectedMedia[index];
                          final isVideo = _mediaTypes[index] == 'video';
                          
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                                  color: AppColors.backgroundSurface,
                                  image: isVideo ? null : DecorationImage(
                                    image: FileImage(file),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: isVideo ? const Center(child: Icon(Icons.videocam, color: Colors.white, size: 32)) : null,
                              ),
                              Positioned(
                                top: 4,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () => _removeMedia(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    
                  if (widget.attachedRunId != null)
                    Container(
                      margin: const EdgeInsets.only(top: AppConstants.stackMd),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSurface,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(color: AppColors.accentNeon.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_run, color: AppColors.accentNeon),
                          const SizedBox(width: 8),
                          Text('Run Attached', style: AppTextStyles.labelMd.copyWith(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Bottom Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.gutter, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.backgroundSurface)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image_outlined, color: AppColors.accentNeon),
                    onPressed: () => _pickMedia(isVideo: false),
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam_outlined, color: AppColors.accentNeon),
                    onPressed: () => _pickMedia(isVideo: true),
                  ),
                  const Spacer(),
                  Text(
                    '$contentLength/${AppConstants.maxPostCharacters}',
                    style: AppTextStyles.labelSm.copyWith(
                      color: isOverLimit ? Colors.redAccent : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
