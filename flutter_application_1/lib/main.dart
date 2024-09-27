import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/signin_screen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SigninScreen(),
    );
  }
}

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  final List<Map<String, dynamic>> _transactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;

  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _typeController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _dateController = TextEditingController();
    _typeController = TextEditingController();
    _noteController = TextEditingController();
  }

  void _addTransaction() {
    final double amount = double.tryParse(_amountController.text) ?? 0;
    final String date = _dateController.text;
    final String type = _typeController.text;
    final String note = _noteController.text;

    if (amount != 0 &&
        date.isNotEmpty &&
        (type == 'รายรับ' || type == 'รายจ่าย')) {
      setState(() {
        _transactions.add({
          'amount': amount,
          'date': date,
          'type': type,
          'note': note,
        });

        if (type == 'รายรับ') {
          _totalIncome += amount;
        } else {
          _totalExpense += amount;
        }
      });

      _amountController.clear();
      _dateController.clear();
      _typeController.clear();
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'จำนวน (บาท)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dateController,
              decoration:
                  const InputDecoration(labelText: 'วันที่ (DD/MM/YYYY)'),
            ),
            TextField(
              controller: _typeController,
              decoration:
                  const InputDecoration(labelText: 'ประเภท (รายรับ/รายจ่าย)'),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'โน้ต'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTransaction,
              child: const Text('บันทึก'),
            ),
            const SizedBox(height: 16),
            const Text(
              'รายการที่บันทึก',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return ListTile(
                    title: Text(
                        '${transaction['type']} - ${transaction['amount']} บาท'),
                    subtitle:
                        Text('${transaction['date']} - ${transaction['note']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('ยอดรวมรายรับ: ${_totalIncome} บาท',
                style: const TextStyle(fontSize: 18)),
            Text('ยอดรวมรายจ่าย: ${_totalExpense} บาท',
                style: const TextStyle(fontSize: 18)),
            Text('ยอดรวมสุทธิ: ${_totalIncome - _totalExpense} บาท',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
