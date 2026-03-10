import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/users_providers.dart';
import 'user_detail_page.dart';

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

  Widget _buildBody(BuildContext context, dynamic state) {
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
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final Map<String, dynamic> user = state.users[index];

          final name = user['name'] ?? 'No name';
          final email = user['email'] ?? '';
          final identification = user['identification'] ?? '';

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(name.toString()),
            subtitle: Text(email.toString()),
            trailing: Text(identification.toString()),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => UserDetailPage(user: user)),
              );
            },
          );
        },
      ),
    );
  }
}
