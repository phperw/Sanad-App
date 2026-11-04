import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../admin_router.dart';
import '../data/admin_services.dart';

class _AdminSection {
  final String key;
  final String title;
  final IconData icon;

  const _AdminSection(this.key, this.title, this.icon);
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const _sections = [
    _AdminSection('dashboard', 'الرئيسية', Icons.dashboard_outlined),
    _AdminSection('volunteers', 'المتطوعون', Icons.groups_outlined),
    _AdminSection('campaigns', 'الحملات', Icons.campaign_outlined),
    _AdminSection('tasks', 'المهام', Icons.task_alt_outlined),
    _AdminSection('joinRequests', 'طلبات الانضمام', Icons.person_add_alt),
    _AdminSection('reports', 'التقارير', Icons.fact_check_outlined),
    _AdminSection('emergencies', 'الطوارئ', Icons.emergency_outlined),
    _AdminSection('accounts', 'حسابات الإدارة', Icons.admin_panel_settings),
    _AdminSection('audit', 'سجل التدقيق', Icons.history),
  ];

  int _selectedIndex = 0;
  bool _loading = false;
  String? _error;
  Map<String, dynamic> _dashboard = {};
  List<Map<String, dynamic>> _records = [];
  int _page = 1;
  int? _taskId;
  final Map<String, TextEditingController> _formControllers = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  _AdminSection get _section => _sections[_selectedIndex];

  Future<void> _load({bool nextPage = false}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
      if (!nextPage) {
        _page = 1;
        _records = [];
      }
    });

    final section = _section.key;
    final result = switch (section) {
      'dashboard' => await AdminServices.repository.dashboard(),
      'joinRequests' =>
        _taskId == null
            ? null
            : await AdminServices.repository.missionRequests(
                _taskId!,
                page: _page,
              ),
      _ => await AdminServices.repository.loadSection(section, page: _page),
    };

    if (!mounted) return;
    if (result == null) {
      setState(() => _loading = false);
      return;
    }

    switch (result) {
      case Success(:final data):
        if (section == 'dashboard') {
          setState(() {
            _dashboard = _asMap(data['dashboard']) ?? data;
            _loading = false;
          });
        } else {
          final records = _extractRecords(data, section);
          setState(() {
            _records = nextPage ? [..._records, ...records] : records;
            _loading = false;
          });
        }
      case Failure(:final error):
        setState(() {
          _error = error.message;
          _loading = false;
        });
    }
  }

  List<Map<String, dynamic>> _extractRecords(
    Map<String, dynamic> response,
    String section,
  ) {
    final preferredKeys = switch (section) {
      'volunteers' => ['volunteers'],
      'campaigns' => ['campaigns'],
      'tasks' => ['tasks'],
      'joinRequests' => ['joinRequests'],
      'reports' => ['reports'],
      'emergencies' => ['incidents'],
      'accounts' => ['accounts', 'admins'],
      'audit' => ['auditLogs'],
      _ => const <String>[],
    };
    for (final key in preferredKeys) {
      final values = response[key];
      if (values is List) {
        return values.whereType<Map>().map(_stringMap).toList();
      }
    }
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return _extractRecords(data, section);
    }
    return const [];
  }

  Map<String, dynamic>? _asMap(Object? value) =>
      value is Map ? _stringMap(value) : null;

  Map<String, dynamic> _stringMap(Map value) =>
      value.map((key, value) => MapEntry(key.toString(), value));

  Future<void> _selectSection(int index) async {
    setState(() {
      _selectedIndex = index;
      _error = null;
      _records = [];
    });
    if (_sections[index].key == 'joinRequests') {
      final controller = TextEditingController();
      final selectedTaskId = await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('طلبات الانضمام'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'رقم المهمة'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null && value > 0) Navigator.pop(context, value);
              },
              child: const Text('عرض الطلبات'),
            ),
          ],
        ),
      );
      controller.dispose();
      if (selectedTaskId == null || !mounted) return;
      _taskId = selectedTaskId;
    }
    await _load();
  }

  Future<String?> _askReason({required bool isRequired}) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isRequired ? 'سبب الرفض / الملاحظة' : 'سبب الرفض (اختياري)',
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'اكتب السبب',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (isRequired && text.length < 3) return;
              Navigator.pop(context, text);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _decideRecord(
    Map<String, dynamic> record, {
    required bool approve,
  }) async {
    final id = _asInt(record['id']);
    if (id == null) return;
    final section = _section.key;
    String? reason;
    if (!approve) {
      reason = await _askReason(isRequired: section == 'reports');
      if (reason == null) return;
    }

    final result = switch (section) {
      'reports' => await AdminServices.repository.decideReport(
        reportId: id,
        approve: approve,
        reason: reason,
      ),
      'joinRequests' =>
        _taskId == null
            ? null
            : await AdminServices.repository.decideJoinRequest(
                taskId: _taskId!,
                requestId: id,
                approve: approve,
                reason: reason,
              ),
      _ => null,
    };
    if (!mounted || result == null) return;
    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(approve ? 'تم قبول الطلب' : 'تم تسجيل الرفض')),
        );
        await _load();
      case Failure(:final error):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  int? _asInt(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value');

  Future<void> _createEntry() async {
    final section = _section.key;
    final fields = switch (section) {
      'accounts' => ['fullName', 'email', 'password'],
      'campaigns' => [
        'title',
        'description',
        'startDate',
        'endDate',
        'locationId',
      ],
      'tasks' => ['title', 'description', 'campaignId', 'date', 'locationId'],
      _ => const <String>[],
    };
    if (fields.isEmpty) return;

    _formControllers
      ..clear()
      ..addEntries(
        fields.map((field) => MapEntry(field, TextEditingController())),
      );
    final body = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة ${_section.title}'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: fields
                  .map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: _formControllers[field],
                        obscureText: field == 'password',
                        keyboardType:
                            ['locationId', 'campaignId'].contains(field)
                            ? TextInputType.number
                            : TextInputType.text,
                        decoration: InputDecoration(
                          labelText: field,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final values = <String, dynamic>{};
              for (final field in fields) {
                final value = _formControllers[field]!.text.trim();
                if (value.isEmpty) return;
                values[field] = ['locationId', 'campaignId'].contains(field)
                    ? int.tryParse(value)
                    : value;
              }
              if (values.values.any((value) => value == null)) return;
              Navigator.pop(context, values);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
    for (final controller in _formControllers.values) {
      controller.dispose();
    }
    _formControllers.clear();
    if (body == null || !mounted) return;

    final result = switch (section) {
      'accounts' => await AdminServices.repository.createAdminAccount(
        fullName: body['fullName'] as String,
        email: body['email'] as String,
        password: body['password'] as String,
      ),
      'campaigns' => await AdminServices.repository.createCampaign(body),
      'tasks' => await AdminServices.repository.createTask(body),
      _ => null,
    };
    if (!mounted || result == null) return;
    switch (result) {
      case Success():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تمت الإضافة بنجاح')));
        await _load();
      case Failure(:final error):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _approveMission(Map<String, dynamic> record) async {
    final taskId = _asInt(record['id']);
    if (taskId == null) return;
    final result = await AdminServices.repository.updateMissionApproval(
      taskId: taskId,
      status: 'APPROVED',
    );
    if (!mounted) return;
    switch (result) {
      case Success():
        await _load();
      case Failure(:final error):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _updateIncident(
    Map<String, dynamic> record,
    String status,
  ) async {
    final incidentId = _asInt(record['id']);
    if (incidentId == null) return;
    final requiresNotes = {
      'RESOLVED',
      'CLOSED',
      'CANCELLED',
      'FALSE_ALARM',
    }.contains(status);
    final notes = requiresNotes
        ? await _askReason(isRequired: true)
        : await _askReason(isRequired: false);
    if (notes == null) return;
    final result = await AdminServices.repository.changeEmergencyStatus(
      incidentId: incidentId,
      status: status,
      notes: notes.isEmpty ? null : notes,
    );
    if (!mounted) return;
    switch (result) {
      case Success():
        await _load();
      case Failure(:final error):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  String _recordTitle(Map<String, dynamic> record) {
    for (final key in [
      'title',
      'fullName',
      'name',
      'email',
      'description',
      'id',
    ]) {
      final value = record[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return 'عنصر';
  }

  String _recordSubtitle(Map<String, dynamic> record) {
    final status = record['status'] ?? record['state'];
    final id = record['id'];
    if (status != null && id != null) return 'رقم $id • $status';
    if (status != null) return status.toString();
    return id == null ? '' : 'رقم $id';
  }

  Widget _sectionNavigation({required bool wide}) {
    if (wide) {
      return NavigationRail(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectSection,
        labelType: NavigationRailLabelType.all,
        destinations: _sections
            .map(
              (section) => NavigationRailDestination(
                icon: Icon(section.icon),
                label: Text(section.title),
              ),
            )
            .toList(),
      );
    }
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _sections.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => ChoiceChip(
          avatar: Icon(_sections[index].icon, size: 18),
          label: Text(_sections[index].title),
          selected: index == _selectedIndex,
          onSelected: (_) => _selectSection(index),
        ),
      ),
    );
  }

  Widget _dashboardContent() {
    final stats = _asMap(_dashboard['statistics']) ?? _dashboard;
    final entries = stats.entries.where((entry) => entry.value is num).toList();
    if (entries.isEmpty) {
      return const Center(child: Text('لا توجد إحصائيات متاحة'));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 560
            ? 3
            : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final item = entries[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.key,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${item.value}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _recordsContent() {
    if (_records.isEmpty) {
      return const Center(child: Text('لا توجد بيانات في هذه القائمة'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _records.length + 1,
      itemBuilder: (context, index) {
        if (index == _records.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : () {
                      _page++;
                      _load(nextPage: true);
                    },
              icon: const Icon(Icons.expand_more),
              label: const Text('تحميل المزيد'),
            ),
          );
        }
        final record = _records[index];
        final reviewable =
            _section.key == 'reports' || _section.key == 'joinRequests';
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ExpansionTile(
            leading: CircleAvatar(child: Text('${record['id'] ?? '•'}')),
            title: Text(_recordTitle(record)),
            subtitle: Text(_recordSubtitle(record)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  const JsonEncoder.withIndent('  ').convert(record),
                  textDirection: TextDirection.ltr,
                ),
              ),
              if (reviewable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _decideRecord(record, approve: true),
                          icon: const Icon(Icons.check),
                          label: const Text('قبول'),
                        ),
                      ),
                      if (_section.key == 'tasks')
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: OutlinedButton.icon(
                              onPressed: () => _approveMission(record),
                              icon: const Icon(Icons.verified_outlined),
                              label: const Text('اعتماد المهمة'),
                            ),
                          ),
                        ),
                      if (_section.key == 'emergencies')
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              for (final status in [
                                'ACKNOWLEDGED',
                                'IN_PROGRESS',
                                'RESOLVED',
                              ])
                                OutlinedButton(
                                  onPressed: () =>
                                      _updateIncident(record, status),
                                  child: Text(status),
                                ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _decideRecord(record, approve: false),
                          icon: const Icon(Icons.close),
                          label: const Text('رفض'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await AdminServices.repository.logout();
    } finally {
      if (mounted) context.go(AdminRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      appBar: AppBar(
        title: Text(_section.title),
        actions: [
          IconButton(
            tooltip: 'إعادة تحميل',
            onPressed: _loading ? null : () => _load(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'تسجيل الخروج',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (!wide)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _sectionNavigation(wide: false),
            ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                if (wide) _sectionNavigation(wide: true),
                if (wide) const VerticalDivider(width: 1),
                Expanded(
                  child: _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_off_outlined, size: 44),
                                const SizedBox(height: 12),
                                Text(_error!, textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: () => _load(),
                                  child: const Text('إعادة المحاولة'),
                                ),
                                if (_error!.contains('صلاحية') ||
                                    _error!.contains('الجلسة'))
                                  TextButton(
                                    onPressed: _logout,
                                    child: const Text('تسجيل الدخول مجددًا'),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : _section.key == 'dashboard'
                      ? _dashboardContent()
                      : _recordsContent(),
                ),
              ],
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
        ],
      ),
      floatingActionButton: _section.key == 'joinRequests'
          ? FloatingActionButton.extended(
              onPressed: () => _selectSection(_selectedIndex),
              icon: const Icon(Icons.search),
              label: const Text('اختيار مهمة'),
            )
          : {'accounts', 'campaigns', 'tasks'}.contains(_section.key)
          ? FloatingActionButton.extended(
              onPressed: _createEntry,
              icon: const Icon(Icons.add),
              label: Text('إضافة ${_section.title}'),
            )
          : null,
    );
  }
}
