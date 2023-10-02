final List<String> academicYears = [
  '2022/2023',
  '2023/2024',
  '2024/2025',
  '2025/2026'
];
final List<String> levelList = [
  '100',
  '200',
  '300',
  '400',
  'Masters',
];
final listOfTime = [
  '6:00 AM',
  '6:30 AM',
  '7:00 AM',
  '7:30 AM',
  '8:00 AM',
  '8:30 AM',
  '9:00 AM',
  '9:30 AM',
  '10:00 AM',
  '10:30 AM',
  '11:00 AM',
  '11:30 AM',
  '12:00 PM',
  '12:30 PM',
  '1:00 PM',
  '1:30 PM',
  '2:00 PM',
  '2:30 PM',
  '3:00 PM',
  '3:30 PM',
  '4:00 PM',
  '4:30 PM',
  '5:00 PM',
  '5:30 PM',
  '6:00 PM',
  '6:30 PM',
  '7:00 PM',
  '7:30 PM',
  '8:00 PM',
  '8:30 PM',
];

final List<String> daysList = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

final List<String> periodList = [
  'Period 1',
  'Period 2',
  'Period 3',
  'Period 4',
  'Break'
];

final List<String> classHeader = [
  'Level',
  'Class Code',
  'Class Size',
  'Study Mode',
  'hasDisabled (Yes/No)'
];
final List<String> courseAllocationHeader = [
  'Code',
  'Course Title',
  'Level',
  'Lecturer',
  'Credit Hours',
  'Special Venue'
];

final List<String> liberalAllocationHeader = [
  'Code',
  'Course Title',
  'Lecturer',
];
final List<String> venueHeader = [
  'Venue',
  'Capacity',
  'isSpecial (Yes/No)',
  'isDisability Friendly (Yes/No)',
];

final classInstructions = [
  'Please do not change the headings of the columns or the order of the columns',
  'Please do not change the sheet name or the order of the sheets',
  'Enter the Department name in cell next to the cell with "Department" as heading. eg. "Information Technology Education"\n NB: Department name should be the same for both classes and allocations sheets',
  'NB: If a class has a disabled student, enter "Yes" in the hasDisabled column, else enter "No"',
  'Class Code are the short names of the classes. eg. ITE 100A, CAT 2B, MNG 300A, ACC 2D, etc.\nClass size should be a number.',
  'Please Study Mode should be either "Regular","Weekend" ,"Evening" or "Sandwich". Repeat the same for all classes with the same study mode',
  'Please enter the level of the class. eg. 100, 200, 300, 400. Enter Masters for masters classes and repeat the same for all classes with the same level',
];
final courseInstructions = [
  'Please do not change the headings of the columns or the order of the columns',
  'Please do not change the sheet name or the order of the sheets',
  'Enter the Department name in cell next to the cell with "Department" as heading. eg. "Information Technology Education"\n NB: Department name should be the same for both classes and allocations sheets',
  'NB: If a course requires a special venue such as Computer Lab, Wood lab, etc. Enter the type of venue in the special venue column. eg. "Computer Lab", "Wood Lab", etc. If not, leave the cell empty',
  'Please enter the level of the class. eg. 100, 200, 300, 400. Enter Masters for masters classes and repeat the same for all classes with the same level',
  'NB: If a course is lectured by more than One lecturer, enter the names of the lecturers separated by a comma and put in bracket the classes they teach. ',
  'Note: the class should be the class code which matches a class code in the classes sheet. eg. (ITE 100A, ITE 100B, ITE 100C).\n Eg. Dr. Joshua Dagadu(A-D),Mr. Oliver Buansi(E-I),etc.'
];
