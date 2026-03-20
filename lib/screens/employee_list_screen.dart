// lib/screens/employee_list_screen.dart

import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import '../widgets/employee_list_tile.dart';
import '../main.dart';
import 'employee_detail_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late Future<List<Employee>> _employeesFuture;
  final EmployeeService _service = EmployeeService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name' | 'salary' | 'age'

  @override
  void initState() {
    super.initState();
    _employeesFuture = _service.fetchEmployees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _employeesFuture = _service.fetchEmployees();
    });
  }

  List<Employee> _filtered(List<Employee> all) {
    var list = all.where((e) =>
        e.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (_sortBy == 'salary') {
      list.sort((a, b) => b.salary.compareTo(a.salary));
    } else if (_sortBy == 'age') {
      list.sort((a, b) => a.age.compareTo(b.age));
    } else {
      list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = EmployeeApp.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Directory',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          // ── Sort button ─────────────────────────────────────────────────
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort',
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (_) => [
              _sortItem('name',   'Sort by Name',   Icons.sort_by_alpha),
              _sortItem('salary', 'Sort by Salary', Icons.attach_money),
              _sortItem('age',    'Sort by Age',    Icons.cake_outlined),
            ],
          ),
          // ── Theme toggle ─────────────────────────────────────────────────
          IconButton(
            onPressed: () => appState?.toggleTheme(),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: FutureBuilder<List<Employee>>(
        future: _employeesFuture,
        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Loading employees…',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 15)),
                ],
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.wifi_off_rounded,
                          size: 52, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    const Text('Could not load employees',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade500)),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final all = snapshot.data ?? [];
          final employees = _filtered(all);

          return Column(
            children: [
              // ── Stats banner ─────────────────────────────────────────────
              _StatsBanner(employees: all),

              // ── Search bar ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search employees…',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF1A2236)
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              // ── Sort chip row ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Text('${employees.length} employees',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13)),
                    const Spacer(),
                    _SortChip(label: 'Name',   value: 'name',   current: _sortBy, onTap: (v) => setState(() => _sortBy = v)),
                    const SizedBox(width: 6),
                    _SortChip(label: 'Salary', value: 'salary', current: _sortBy, onTap: (v) => setState(() => _sortBy = v)),
                    const SizedBox(width: 6),
                    _SortChip(label: 'Age',    value: 'age',    current: _sortBy, onTap: (v) => setState(() => _sortBy = v)),
                  ],
                ),
              ),

              // ── List ──────────────────────────────────────────────────────
              Expanded(
                child: employees.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 52, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text('No results for "$_searchQuery"',
                                style: TextStyle(color: Colors.grey.shade500)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 20),
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return EmployeeListTile(
                            employee: employee,
                            index: index,
                            onTap: () => Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, anim, __) =>
                                    EmployeeDetailScreen(employee: employee),
                                transitionsBuilder: (_, anim, __, child) {
                                  return FadeTransition(
                                    opacity: anim,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.05, 0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                          parent: anim,
                                          curve: Curves.easeOut)),
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  PopupMenuItem<String> _sortItem(String val, String label, IconData icon) {
    return PopupMenuItem(
      value: val,
      child: Row(
        children: [
          Icon(icon, size: 18,
              color: _sortBy == val
                  ? Theme.of(context).colorScheme.primary
                  : null),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(
                  fontWeight: _sortBy == val
                      ? FontWeight.bold
                      : FontWeight.normal)),
        ],
      ),
    );
  }
}

// ── Stats Banner ──────────────────────────────────────────────────────────────
class _StatsBanner extends StatelessWidget {
  final List<Employee> employees;
  const _StatsBanner({required this.employees});

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final avgSalary = employees.map((e) => e.salary).reduce((a, b) => a + b) /
        employees.length;
    final maxSalary =
        employees.map((e) => e.salary).reduce((a, b) => a > b ? a : b);
    final avgAge =
        employees.map((e) => e.age).reduce((a, b) => a + b) / employees.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A2A4A), const Color(0xFF0F1E38)]
              : [const Color(0xFF1976D2), const Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _stat('👥', '${employees.length}', 'Total'),
          _divider(),
          _stat('💰', '\$${avgSalary.toStringAsFixed(0)}', 'Avg Salary'),
          _divider(),
          _stat('🏆', '\$${maxSalary.toStringAsFixed(0)}', 'Max Salary'),
          _divider(),
          _stat('🎂', avgAge.toStringAsFixed(1), 'Avg Age'),
        ],
      ),
    );
  }

  Widget _stat(String emoji, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: Colors.white.withOpacity(0.2),
      );
}

// ── Sort Chip ─────────────────────────────────────────────────────────────────
class _SortChip extends StatelessWidget {
  final String label, value, current;
  final ValueChanged<String> onTap;

  const _SortChip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    final color = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
