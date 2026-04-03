import 'package:blog_app/core/di/injection_container.dart';
import 'package:blog_app/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/profile/profile_state.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_event.dart';
import 'package:blog_app/features/auth/presentation/bloc/session/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => sl<ProfileBloc>(), child: const ProfileView());
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          } else if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated'), backgroundColor: Colors.green));
          } else if (state is ProfilePictureUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile picture updated'), backgroundColor: Colors.green));
          } else if (state is AccountDeleted) {
            context.read<SessionBloc>().add(const CheckAuthStatusEvent());
          }
        },
        child: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, sessionState) {
            if (sessionState is! Authenticated) return const Center(child: Text('Not authenticated'));
            final user = sessionState.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null && context.mounted) {
                        context.read<ProfileBloc>().add(UploadProfilePictureEvent(filePath: image.path));
                      }
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                      child: user.photoUrl == null ? const Icon(Icons.camera_alt, size: 40) : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(user.displayName ?? 'User', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(user.email, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 32),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                    onTap: () => context.read<SessionBloc>().add(const SignOutEvent()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Account'),
                          content: const Text('Are you sure? This action cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                context.read<ProfileBloc>().add(const DeleteAccountEvent());
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
