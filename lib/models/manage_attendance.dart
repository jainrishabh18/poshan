class ManageAttendance {

  String name;
  String className;
  bool isSelected;

  ManageAttendance({required this.name, required this.className, required this.isSelected});

  @override
  String toString() {
    return 'ManageAttendance{name: $name, className: $className, isSelected: $isSelected}';
  }

  static List<ManageAttendance> list = [
    ManageAttendance(name: 'Mohit', className: 'Class-1', isSelected: false),
    ManageAttendance(name: 'Krishnendra', className: 'Class-1', isSelected: false),
    ManageAttendance(name: 'Akshat', className: 'Class-1', isSelected: false),
    ManageAttendance(name: 'Nisha', className: 'Class-1', isSelected: false),
    ManageAttendance(name: 'Rishabh', className: 'Class-1', isSelected: false),
    ManageAttendance(name: 'Naman', className: 'Class-1', isSelected: false),
  ];

}
