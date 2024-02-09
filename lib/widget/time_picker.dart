import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  final bool isStartTime;
  final Function(DateTime)? onTimeChanged;

  const TimePicker({
    Key? key,
    required this.isStartTime,
    this.onTimeChanged,
  }) : super(key: key);

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateTime time = DateTime(2024, 2, 9, 12, 00);
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 56,
        width: (MediaQuery.of(context).size.width - 70) / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat.Hm().format(time),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    CupertinoIcons.clock,
                    size: 24,
                    color: Colors.blue,
                  ),
                ),
              ]
          ),
        ),
      ),
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: CupertinoDatePicker(
              backgroundColor: Colors.white,
              initialDateTime: time,
              onDateTimeChanged: (DateTime newTime) {
                DateFormat.Hm().format(_startTime);
                setState(() {
                  time = newTime;
                  widget.isStartTime ? _startTime = newTime : _endTime = newTime;
                  if (widget.onTimeChanged != null) {
                    widget.onTimeChanged!(newTime);
                  }
                });
              },
              // use24hFormat: true,
              mode: CupertinoDatePickerMode.time,
            ),
          ),
        );
      },
    );
  }
}