import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/localization_extension.dart';
import '../providers/customers_providers.dart';

class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoad) {
      _didLoad = true;
      Future.microtask(() {
        ref.read(customersControllerProvider.notifier).loadCacheThenRemote();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.customers),
        actions: [
          IconButton(
            tooltip: context.l10n.refresh,
            onPressed: state.loading
                ? null
                : () => ref
                      .read(customersControllerProvider.notifier)
                      .refreshRemoteOnly(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.fromCache) _InfoBanner(text: context.l10n.showingCache),
          if (state.error != null)
            _ErrorBanner(text: context.localizeError(state.error!)),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(customersControllerProvider.notifier)
                  .refreshRemoteOnly(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.customers.length,
                separatorBuilder: (_, separatorIndex) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final customer = state.customers[index];

                  return ListTile(
                    title: Text(
                      customer.displayName.isEmpty
                          ? context.l10n.unnamed
                          : customer.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      [
                        if (customer.clientType.isNotEmpty) customer.clientType,
                        if (customer.city.isNotEmpty) customer.city,
                        if (customer.id.isNotEmpty) 'ID: ${customer.id}',
                      ].join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.push(
                        '/customers/${customer.id}',
                        extra: customer,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amber.withValues(alpha: 0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.error_outline, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
