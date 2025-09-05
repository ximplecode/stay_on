import 'package:flutter/material.dart';
import '../models/plan.dart';
import 'add_plan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Plan> _plans = [];

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _addPlan() async {
    final result = await Navigator.of(
      context,
    ).push<Plan>(MaterialPageRoute(builder: (_) => const AddPlanPage()));
    if (result != null) {
      setState(() => _plans.add(result));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('계획이 등록되었습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body:
          _plans.isEmpty
              ? Center(
                child: Text(
                  '아직 등록된 계획이 없어요.\n오른쪽 아래 + 버튼으로 추가해 보세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (_, i) {
                  final p = _plans[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text('${_fmt(p.start)} ~ ${_fmt(p.end)}'),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: _plans.length,
              ),
      floatingActionButton: FloatingActionButton(
        tooltip: '계획 추가',
        onPressed: _addPlan, // ✅ + 버튼 → 등록 페이지 오픈
        child: const Icon(Icons.add),
      ),
    );
  }
}
