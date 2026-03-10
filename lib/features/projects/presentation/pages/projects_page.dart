import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/projects_controller.dart';
import '../providers/projects_providers.dart';
import 'project_detail_page.dart';

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
        title: const Text('Projects'),
        actions: [
          IconButton(
            tooltip: 'Refrescar',
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
                child: const Text(
                  'Mostrando datos desde caché local.',
                  style: TextStyle(fontSize: 13),
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
                child: Text(state.error!, style: const TextStyle(fontSize: 13)),
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
        children: const [
          SizedBox(height: 120),
          Center(child: Text('No hay proyectos disponibles.')),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.projects.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final project = state.projects[index];

        final id = (project['_id'] ?? '').toString();
        final name = (project['text_nameProject_id'] ?? 'Sin nombre')
            .toString();
        final status = (project['text_stateProject_id'] ?? 'Sin estado')
            .toString();
        final date = (project['date_dateCreateProject_id'] ?? 'Sin fecha')
            .toString();

        return ListTile(
          title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Estado: $status'),
              Text(
                'Fecha: $date',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'ID: $id',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          isThreeLine: true,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProjectDetailPage(project: project),
              ),
            );
          },
        );
      },
    );
  }
}
