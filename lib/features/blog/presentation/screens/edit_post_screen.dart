import 'package:blog_app/core/constants/post_categories.dart';
import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/blog/domain/entities/post_entity.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_event.dart';
import 'package:blog_app/features/blog/presentation/bloc/post_crud/post_crud_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPostPage extends StatelessWidget {
  final PostEntity post;

  const EditPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostCrudBloc>(),
      child: EditPostView(post: post),
    );
  }
}

class EditPostView extends StatefulWidget {
  final PostEntity post;

  const EditPostView({super.key, required this.post});

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  String? _selectedCategory;
  String? _imagePath;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _selectedCategory = widget.post.category;
    _existingImageUrl = widget.post.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        actions: [
          BlocBuilder<PostCrudBloc, PostCrudState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state is PostCrudLoading ? null : _submitUpdate,
                child: state is PostCrudLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              );
            },
          ),
        ],
      ),
      body: BlocListener<PostCrudBloc, PostCrudState>(
        listener: (context, state) {
          if (state is PostUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post updated!'), backgroundColor: Colors.green));
            Navigator.of(context).pop(true);
          } else if (state is PostCrudError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      image: _imagePath != null
                          ? DecorationImage(image: FileImage(File(_imagePath!)), fit: BoxFit.cover)
                          : _existingImageUrl != null
                              ? DecorationImage(image: NetworkImage(_existingImageUrl!), fit: BoxFit.cover)
                              : null,
                    ),
                    child: (_imagePath == null && _existingImageUrl == null)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.grey[500]),
                              const SizedBox(height: 8),
                              Text('Add Cover Image', style: TextStyle(color: Colors.grey[500])),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  style: Theme.of(context).textTheme.titleLarge,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: kPostCategories.map((c) => DropdownMenuItem(value: c.value, child: Text(c.label))).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Content', alignLabelWithHint: true),
                  maxLines: 15,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Content is required' : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
        _existingImageUrl = null;
      });
    }
  }

  void _submitUpdate() {
    if (!_formKey.currentState!.validate()) return;
    context.read<PostCrudBloc>().add(UpdatePostEvent(
      id: widget.post.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      imagePath: _imagePath,
      category: _selectedCategory,
    ));
  }
}
