import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/customers_controller.dart';
import 'customer_detail_page.dart';

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
        title: const Text('Customers'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
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
          if (state.fromCache)
            const _InfoBanner(
              text: 'Mostrando cache (offline o cargando remoto)',
            ),
          if (state.error != null) _ErrorBanner(text: state.error!),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(customersControllerProvider.notifier)
                  .refreshRemoteOnly(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.customers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c = state.customers[index];

                  final id = (c['_id'] ?? '').toString();
                  final type = (c['rad_clientType_id'] ?? '').toString();

                  // Nombre: si existe text_custName_id úsalo, sino arma con first/last
                  final custName = (c['text_custName_id'] ?? '')
                      .toString()
                      .trim();
                  final first = (c['text_firstName_id'] ?? '')
                      .toString()
                      .trim();
                  final last = (c['text_lastName_id'] ?? '').toString().trim();

                  final displayName = custName.isNotEmpty
                      ? custName
                      : [first, last].where((e) => e.isNotEmpty).join(' ');

                  // ejemplo de campo anidado "simple": city es List
                  final city = _firstStringFromList(c['text_city_id']);

                  return ListTile(
                    title: Text(
                      displayName.isEmpty ? '(Sin nombre)' : displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      [
                        if (type.isNotEmpty) type,
                        if (city != null && city.isNotEmpty) city,
                        if (id.isNotEmpty) 'ID: $id',
                      ].join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CustomerDetailPage(customer: c),
                        ),
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

  String? _firstStringFromList(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final v = value.first?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.amber.withOpacity(0.25),
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
      color: Colors.red.withOpacity(0.12),
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
