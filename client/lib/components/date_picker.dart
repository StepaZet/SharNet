import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State providers for managing selected date range
final startDateProvider = StateProvider<DateTime>(
    (ref) => DateTime.now().subtract(const Duration(days: 180)));
final endDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class DatePicker extends ConsumerStatefulWidget {
  final List<Future<void> Function(WidgetRef)> subscribers;

  const DatePicker({super.key, this.subscribers = const []});

  @override
  ConsumerState<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<DatePicker> {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0,
      right: 10.0,
      height: 40,
      child: FloatingActionButton(
        heroTag: 'datePicker',
        backgroundColor: Colors.white,
        child: const Icon(Icons.date_range, color: Colors.blue),
        onPressed: () => _showDateRangePicker(context, ref),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context, WidgetRef ref) {
    double baseSizeWidth = MediaQuery.of(context).size.width;
    double baseSizeHeight = MediaQuery.of(context).size.height;

    final startDate = ref.read(startDateProvider);
    final endDate = ref.read(endDateProvider);

    DateTime startDateValue = startDate;
    DateTime endDateValue = endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date Range'),
          content: SizedBox(
            height: baseSizeHeight * 0.5,
            width: baseSizeWidth * 0.8,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  final range = args.value;
                  startDateValue = range.startDate;
                  endDateValue = range.endDate;
                }
              },
              selectionMode: DateRangePickerSelectionMode.extendableRange,
              initialSelectedRange: PickerDateRange(startDate, endDate),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => {
                ref.read(startDateProvider.notifier).state = startDateValue,
                ref.read(endDateProvider.notifier).state = endDateValue,

                Future.wait(widget.subscribers.map((subscriber) => subscriber(ref))),

                Navigator.pop(context),
              }
            ),
          ],
        );
      },
    );
  }
}
