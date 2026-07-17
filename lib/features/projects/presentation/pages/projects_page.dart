import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/localization_extension.dart';
import '../controllers/projects_controller.dart';
import '../providers/projects_providers.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoad) {
      _didLoad = true;
      Future.microtask(() {
        ref.read(projectsControllerProvider.notifier).loadCacheThenRemote();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.projects),
        actions: [
          IconButton(
            tooltip: context.l10n.refresh,
            onPressed: () {
              ref.read(projectsControllerProvider.notifier).refreshRemoteOnly();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(projectsControllerProvider.notifier)
              .refreshRemoteOnly();
        },
        child: Column(
          children: [
            if (state.fromCache)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: Colors.amber.shade100,
                child: Text(
                  context.l10n.showingLocalCache,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: Colors.red.shade100,
                child: Text(
                  context.localizeError(state.error!),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            Expanded(child: _ProjectsList(state: state)),
          ],
        ),
      ),
    );
  }
}

class _ProjectsList extends StatelessWidget {
  const _ProjectsList({required this.state});

  final ProjectsState state;

  @override
  Widget build(BuildContext context) {
    if (state.loading && state.projects.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.projects.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(child: Text(context.l10n.noProjects)),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.projects.length,
      separatorBuilder: (_, separatorIndex) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final project = state.projects[index];

        return ListTile(
          title: Text(
            project.name.isEmpty ? context.l10n.unnamed : project.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.status}: '
                '${project.status.isEmpty ? context.l10n.noData : project.status}',
              ),
              Text(
                '${context.l10n.date}: '
                '${project.dateCreated.isEmpty ? context.l10n.noData : project.dateCreated}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'ID: ${project.id}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          isThreeLine: true,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.push('/projects/${project.id}', extra: project);
          },
        );
      },
    );
  }
}
