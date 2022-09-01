import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/models/manage_attendance.dart';

class ManageAttendanceScreen extends StatefulWidget {
  const ManageAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<ManageAttendanceScreen> createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends State<ManageAttendanceScreen> {

  List<ManageAttendance> list = ManageAttendance.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.WHITE,
        iconTheme: const IconThemeData(
          color: ConstantColors.BLACK,
        ),
        title: const Text(
          'Manage Attendance',
          style: TextStyle(
            color: ConstantColors.BLACK,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            ManageAttendance manageAttendance = list.elementAt(index);
            return Card(
              child: ListTile(
                title: Text('${manageAttendance.name}'),
                subtitle: Text('${manageAttendance.className}'),
                trailing: Checkbox(
                  value: manageAttendance.isSelected,
                  activeColor: ConstantColors.RED,
                  onChanged: (value) {
                    setState(() {
                      list.elementAt(index).isSelected = value!;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
