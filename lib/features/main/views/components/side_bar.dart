// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

class SideBar {
  BuildContext context;
  SideBar({
    required this.context,
  });
  
   List<NavigationPaneItem> getItems(){
    return [
    PaneItem(
      key: const ValueKey('/'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Config'),
      body: const SizedBox.shrink(),
      onTap: (){
        if (GoRouterState.of(context).uri.toString() != '/') {
          context.go('/');
        }
      },
    ),
    PaneItem(
      key: const ValueKey('/allocations'),
      icon: const Icon(FluentIcons.list),
      title: const Text('Allocations'),
      body: const SizedBox.shrink(),
      onTap: (){
        if (GoRouterState.of(context).uri.toString() != '/allocations') {
          context.go('/allocations');
        }
      },
    ),
    PaneItem(
      key: const ValueKey('/liberal'),
      icon: const Icon(FluentIcons.book_answers),
      title: const Text('Liberal Courses'),
      body: const SizedBox.shrink(),
      onTap: (){
        if (GoRouterState.of(context).uri.toString() != '/liberal') {
          context.go('/liberal');
        }
      },
    ),
    PaneItem(
      key: const ValueKey('/venues'),
      icon: const Icon(FluentIcons.room),
      title: const Text('Venues'),
      body: const SizedBox.shrink(),
      onTap: (){
        if (GoRouterState.of(context).uri.toString() != '/venues') {
          context.go('/venues');
        }
      },
    ),
    PaneItem(
      key: const ValueKey('/tables'),
      icon: const Icon(FluentIcons.table),
      title: const Text('Tables'),
      body: const SizedBox.shrink(),
      onTap: (){
        if (GoRouterState.of(context).uri.toString() != '/tables') {
          context.go('/tables');
        }
      },
    ),
    
  ];
   }
    

    int calculateSelectedIndex() {
    final location = GoRouterState.of(context).uri.toString();
    var list =getItems();
    int indexOriginal = list
        .where((item) => item.key != null)
        .toList()
        .indexWhere((item) => item.key == Key(location));

    if (indexOriginal == -1) {
    
      
      return list
              .where((element) => element.key != null)
              .toList()
              .length;
    } else {
      return indexOriginal;
    }
  }

 
}
