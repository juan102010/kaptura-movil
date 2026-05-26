import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/users_controller.dart';
import '../providers/users_providers.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(usersControllerProvider.notifier).loadCacheThenRemote();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(usersControllerProvider.notifier).refreshRemoteOnly();
            },
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, UsersState state) {
    if (state.loading && state.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.users.isEmpty) {
      return Center(
        child: Text(state.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (state.users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(usersControllerProvider.notifier).refreshRemoteOnly();
      },
      child: ListView.separated(
        itemCount: state.users.length,
        separatorBuilder: (_, separatorIndex) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = state.users[index];

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Text(user.identification),
            onTap: () {
              context.push('/users/${user.id}', extra: user);
            },
          );
        },
      ),
    );
  }
}
