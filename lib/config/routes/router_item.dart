class RouterItem {
  String path;
  String name;

  RouterItem({
    required this.path,
    required this.name,
  });

  static RouterItem configRoute = RouterItem(path: '/config', name: 'config');
  static RouterItem departmentRoute =
      RouterItem(path: '/department', name: 'department');
  static RouterItem lecturerRoute =
      RouterItem(path: '/lecturers', name: 'lecturers');
  static RouterItem classesRoute =
      RouterItem(path: '/classes', name: 'classes');
  static RouterItem allocationRoute =
      RouterItem(path: '/allocations', name: 'allocations');
  static RouterItem venuesRoute =
      RouterItem(path: '/venues', name: 'venues');
  static RouterItem tableRoute =
      RouterItem(path: '/table', name: 'table');
  static RouterItem helpRoute =
      RouterItem(path: '/help', name: 'help');

  static RouterItem aboutRoute =
      RouterItem(path: '/about', name: 'about');
  
  static List<RouterItem> get allRoutes => [
        configRoute,
        departmentRoute,
        lecturerRoute,
        classesRoute,
        allocationRoute,
        venuesRoute,
        tableRoute,
        helpRoute,
        aboutRoute,
      ];

  static RouterItem getRouteByPath(String fullPath) {
    return allRoutes.firstWhere((element) => element.path == fullPath);
  }
}
