import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/constants.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload an image file
  Future<String> uploadImage(File file, String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error in uploadImage: $e");
      rethrow;
    }
  }

  // Upload a video file
  Future<String> uploadVideo(File file, String path) async {
    try {
      // Validate file size (max 50 MB)
      int fileSizeInBytes = await file.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      
      if (fileSizeInMB > AppConstants.maxVideoSizeMB) {
        throw Exception("Video file size exceeds maximum limit of ${AppConstants.maxVideoSizeMB} MB");
      }
      
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'video/mp4'),
      );
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error in uploadVideo: $e");
      rethrow;
    }
  }

  // Delete a file
  Future<void> deleteFile(String url) async {
    try {
      if (url.isEmpty) return;
      Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      debugPrint("Error in deleteFile: $e");
      rethrow;
    }
  }
}
