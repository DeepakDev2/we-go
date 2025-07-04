import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:we_go/common/pick_image.dart';
import 'package:we_go/common/upload_image_to_cloud.dart';
import 'package:we_go/models/post_model.dart';
import 'package:we_go/providers/user_provider.dart';
import 'package:we_go/resources/upload_methods.dart';
import 'package:we_go/widgets/custom_button.dart';
import 'package:we_go/widgets/custom_text_input_box.dart';
import 'package:we_go/widgets/show_snackbar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
    required this.roomId,
    required this.onCreatePost,
  });
  final void Function(BuildContext) onCreatePost;
  final String roomId;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postDescriptionController = TextEditingController();

  var uuid = Uuid();

  File? postImage;

  @override
  void dispose() {
    _postDescriptionController.dispose();
    super.dispose();
  }

  void setImage() async {
    final img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        postImage = img;
      });
    }
  }

  bool _isUploading = false;

  void addPost() async {
    if (postImage == null) {
      showSnackBar(context, "Try adding an image in the post");
      return;
    }
    setState(() {
      _isUploading = true;
    });
    final postImageLink = await uploadImageOnCloud(postImage!);

    if (postImageLink == null) {
      showSnackBar(context, "Upload Failed");
      setState(() {
        _isUploading = false;
      });
      return;
    }
    final user = context.read<UserProvider>().getUser();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final post = PostModel(
      postId: uuid.v4(),
      image: postImageLink,
      senderName: user!.name,
      senderId: uid,
      desctiption: _postDescriptionController.text,
      timestamp: DateTime.now(),
      likes: 0,
      roomId: widget.roomId,
    );
    final res = await UploadMethods().uploadPost(post);
    setState(() {
      _isUploading = false;
    });
    if (res != "Success") {
      showSnackBar(context, res);

      return;
    }
    widget.onCreatePost(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: setImage,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: postImage == null ? Colors.grey : Colors.transparent,
                ),
                child:
                    postImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(postImage!, fit: BoxFit.cover),
                        )
                        : Center(
                          child: Text(
                            "Add a Post Image",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: CustomTextInputBox(
                chatController: _postDescriptionController,
                hintText: "Description",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                  _isUploading
                      ? SizedBox(
                        width: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : CustomButton(onClick: addPost, text: "Post"),
            ),
          ],
        ),
      ),
    );
  }
}
