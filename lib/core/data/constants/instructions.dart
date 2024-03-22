final List<String> classInstructions = [
  'Please do NOT change the HEADINGS of the columns or the order of the columns',
  'Please do not change the sheet name or the order of the sheets',
  'Enter the DEPARTMENT name in cell next to the cell with "Department" as heading. eg. "Information Technology Education"\n NB: Department name should be the same for on all sheets sheets',
  'NB: If a class has a disabled student, enter "Yes" in the hasDisabled column, else enter "No"',
  'CLASS CODE are the short names of the classes. eg. ITE 100A, CAT 2B, MNG 300A, ACC 2D, etc.\nClass size should be a number.',
  'Please enter the level of the class. eg. 100, 200, 300, 400. Enter Masters for masters classes and repeat the same for all classes with the same level',
];
final List<String> courseInstructions = [
  'Please do not change the headings of the columns or the order of the columns',
  'Please do not change the sheet name or the order of the sheets',
  'Enter the Department name in cell next to the cell with "Department" as heading. eg. "Information Technology Education"\n NB: Department name should be the same on all the sheets',
  'NB: If a course requires a SPECIAL VENUE such as Computer Lab, Wood lab, etc. Enter the type of venue in the special venue column. eg. "Computer Lab", "Wood Lab", etc. If not, leave the cell empty',
  'Please enter the level of the class. eg. 100, 200, 300, 400. Enter Masters for masters classes and repeat the same for all classes with the same level',
  'NB: Feel Free to repeat a course if the course is taught by more than one lecturer. Just make sure the course code and course title are the same and specify the classes the lecturer teaches in the Lecturer Classes column. eg. ITE 100A, ITE 100B, ITE 100C',
  'NOTE: For a Lecturer, make sure they matches a class code in the classes sheet. eg. (ITE 100A, ITE 100B, ITE 100C).And seperate the classes with a comma. eg. ITE 100A, ITE 100B, ITE 100C',
];

//generate for me instructions for the venue excel sheet
final List<String> venueInstructions = [
  'Please do not change the headings of the columns or the order of the columns',
  'Please do not change the sheet name or the order of the sheets',
  'NB: If a venue has a disabled access, enter "Yes" in the DisabilityAccess column, else enter "No"',
  'NB: If a venue is a special venue such as Computer Lab, Wood lab, etc. Enter "Yes" in the isSpecial/Lab column, else enter "No"',
  'Please enter the capacity of the venue. eg. 50, 100, 200, 300, 400, etc.',
  'Please enter the name of the venue. eg. "Computer Lab", "Wood Lab", "NFB FF1", "ROB 25", etc.',
];

//generate for me instructions for the liberal course excel sheet
final List<String> liberalInstructions = [
  'Please do not change the headings of the columns or the order of the columns',
  'Please do not change the sheet name or the order of the sheets',
  'Specify the lecturer ID and lecturer name for the course. ',
];
