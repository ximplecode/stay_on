import 'package:flutter/material.dart';
import '../models/plan.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({super.key});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  DateTimeRange? _range;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3, 1, 1),
      lastDate: DateTime(now.year + 3, 12, 31),
      initialDateRange:
          _range ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 7)),
          ),
      helpText: '계획 기간 선택',
    );
    if (picked != null) {
      setState(() => _range = picked);
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_range == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('계획 기간을 선택해 주세요.')));
      return;
    }
    final plan = Plan(
      name: _nameCtrl.text.trim(),
      start: DateUtils.dateOnly(_range!.start),
      end: DateUtils.dateOnly(_range!.end),
    );
    Navigator.of(context).pop(plan); // ✅ 생성한 Plan을 반환
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('계획 등록')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: '계획명',
                    hintText: '예) 매일 30분 러닝',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '계획명을 입력해 주세요.';
                    if (v.trim().length > 50) return '50자 이내로 입력해 주세요.';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: const Text('계획 기간'),
                  subtitle: Text(
                    _range == null
                        ? '기간을 선택해 주세요.'
                        : '${_fmt(_range!.start)} ~ ${_fmt(_range!.end)}',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                  trailing: FilledButton.tonal(
                    onPressed: _pickRange,
                    child: const Text('기간 선택'),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('등록'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
