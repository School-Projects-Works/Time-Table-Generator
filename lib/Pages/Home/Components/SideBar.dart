// ignore_for_file: file_names

import 'package:aamusted_timetable_generator/SateManager/NavigationProvider.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideBard extends StatefulWidget {
  const SideBard({Key? key}) : super(key: key);

  @override
  State<SideBard> createState() => _SideBardState();
}

class _SideBardState extends State<SideBard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<NavigationProvider>(builder: (context, nav, child) {
      return Container(
          width: nav.sideWidth,
          height: size.height - 110,
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3))
              ]),
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 110,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    SideBarItem(
                        onTap: () {
                          if (nav.sideWidth == 60) {
                            nav.setSideWidth(200);
                          } else {
                            nav.setSideWidth(60);
                          }
                        },
                        isSelected: false,
                        title: '',
                        icon: Icons.menu),
                    const SizedBox(
                      height: 40,
                    ),
                    SideBarItem(
                        onTap: () {
                          nav.setPage(0);
                        },
                        isSelected: nav.page == 0,
                        title: 'Configurations',
                        icon: Icons.settings),
                    SideBarItem(
                        onTap: () {
                          nav.setPage(1);
                        },
                        isSelected: nav.page == 1,
                        title: 'Courses',
                        icon: Icons.menu_book_outlined),
                    SideBarItem(
                        onTap: () {
                          nav.setPage(2);
                        },
                        isSelected: nav.page == 2,
                        title: 'Classes',
                        icon: FontAwesomeIcons.chalkboardUser),
                    SideBarItem(
                        onTap: () {
                          nav.setPage(3);
                        },
                        isSelected: nav.page == 3,
                        title: 'Liberal/African',
                        icon: FontAwesomeIcons.book),
                    SideBarItem(
                        onTap: () {
                          nav.setPage(4);
                        },
                        isSelected: nav.page == 4,
                        title: 'Venues',
                        icon: FontAwesomeIcons.locationDot),
                    SideBarItem(
                        onTap: () {
                          nav.setPage(5);
                        },
                        isSelected: nav.page == 5,
                        title: 'Timetable',
                        icon: FontAwesomeIcons.table),
                    const Divider(
                      color: primaryColor,
                      thickness: 5,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Version 1.0.0',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

class SideBarItem extends StatefulWidget {
  const SideBarItem(
      {Key? key,
      required this.onTap,
      required this.isSelected,
      required this.title,
      required this.icon})
      : super(key: key);
  final VoidCallback onTap;
  final bool isSelected;
  final String title;
  final IconData icon;
  @override
  State<SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem> {
  bool onHover = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(builder: (context, nav, child) {
      return InkWell(
        onTap: widget.onTap,
        onHover: (value) {
          setState(() {
            onHover = value;
          });
        },
        child: Container(
            height: 65,
            width: nav.sideWidth,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: widget.title.isNotEmpty
                ? widget.isSelected
                    ? background
                    : onHover
                        ? Colors.black.withOpacity(0.3)
                        : Colors.transparent
                : Colors.transparent,
            child: Row(
              mainAxisAlignment: nav.sideWidth == 60
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (widget.title.isEmpty && nav.sideWidth == 200)
                  const Spacer(),
                Icon(
                  widget.icon,
                  color: widget.isSelected ? primaryColor : background,
                ),
                if (nav.sideWidth > 60)
                  const SizedBox(
                    width: 20,
                  ),
                if (nav.sideWidth > 60)
                  Text(
                    widget.title,
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.isSelected ? primaryColor : background),
                  )
              ],
            )),
      );
    });
  }
}
