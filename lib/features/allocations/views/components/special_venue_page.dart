import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme.dart';
import '../../../../core/widget/custom_input.dart';
import '../../../venues/data/venue_model.dart';
import '../../data/courses/courses_model.dart';
import 'provider/venue_selection_provider.dart';

class SpecialVenueSelect extends ConsumerStatefulWidget {
  const SpecialVenueSelect(this.id, {super.key});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpecialVenueSelectState();
}

class _SpecialVenueSelectState extends ConsumerState<SpecialVenueSelect> {
  List<VenueModel> specialVenues = [];
  List<VenueModel> selectedVenues = [];
  List<VenueModel> selectingVeneus = [];
  List<VenueModel> removingVenues = [];
  CourseModel selectedCourse = CourseModel();
  @override
  void initState() {
    //wait for widget to build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var venues = ref.watch(venuesDataProvider);
      var sv =
          venues.where((element) => element.isSpecialVenue ?? false).toList();
      var courses = ref.watch(coursesDataProvider);
      setState(() {
        specialVenues = sv;
        selectedCourse = courses.firstWhere(
            (element) => element.id == widget.id,
            orElse: () => CourseModel());
        if (selectedCourse.id != null && selectedCourse.venues != null) {
          for (var venue in selectedCourse.venues!) {
            selectedVenues.add(
                specialVenues.firstWhere((element) => element.name == venue));
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //back button
                      CustomButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          radius: 10,
                          text: 'Back',
                          icon: Icons.arrow_back,
                          onPressed: () {
                            context.pop();
                          }),
                      const SizedBox(width: 20),
                      Text(
                        'Special Venues Selection'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 4,
                    height: 15,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        text: 'Select special venues for: ',
                        style:
                            getTextStyle(fontSize: 19, color: Colors.black45),
                        children: [
                          TextSpan(
                            text: selectedCourse.title,
                            style: getTextStyle(
                                color: primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 4,
                    height: 15,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.68,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Column(
                            children: [
                              Text(
                                'Available Special Venues',
                                style: getTextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: CustomTextFields(
                                  suffixIcon: const Icon(Icons.search),
                                  hintText: 'Search Venues',
                                  onChanged: (value) {
                                    //search for through special venues
                                    var venues = ref.watch(venuesDataProvider);
                                    var sv = venues
                                        .where((element) =>
                                            element.isSpecialVenue ?? false)
                                        .toList();
                                    setState(() {
                                      if (value.isEmpty) {
                                        specialVenues = sv;
                                        return;
                                      }
                                      specialVenues = sv
                                          .where((element) => element.name!
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: specialVenues.length,
                                          itemBuilder: (context, index) {
                                            var venue = specialVenues[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: !selectedVenues
                                                      .contains(venue)
                                                  ? fluent.Checkbox(
                                                      content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child:
                                                            Text(venue.name!),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (value ?? false) {
                                                            selectingVeneus
                                                                .add(venue);
                                                          } else {
                                                            selectingVeneus
                                                                .remove(venue);
                                                          }
                                                        });
                                                      },
                                                      checked: selectingVeneus
                                                          .contains(venue),
                                                    )
                                                  : fluent.Checkbox(
                                                      style: fluent
                                                          .CheckboxThemeData(
                                                        checkedDecoration: fluent
                                                                .ButtonState
                                                            .all(const fluent
                                                                .BoxDecoration(
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                      content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child:
                                                            Text(venue.name!),
                                                      ),
                                                      onChanged: null,
                                                      checked: selectingVeneus
                                                          .contains(venue),
                                                    ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                            icon: const Icon(
                              Icons.compare_arrows_sharp,
                              size: 40,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                //remove selecting venues from special venues
                                // specialVenues = specialVenues
                                //     .where((element) =>
                                //         !selectingVeneus.contains(element))
                                //     .toList();
                                //remove removing venues from selected venues
                                selectedVenues = selectedVenues
                                    .where((element) =>
                                        !removingVenues.contains(element))
                                    .toList();
                                //add selecting venues to selected venues
                                selectedVenues.addAll(selectingVeneus);
                                //add removing venues to special venues
                                specialVenues.addAll(removingVenues);
                                //clear selecting venues
                                selectingVeneus.clear();
                                //clear removing venues
                                removingVenues.clear();
                              });
                            }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.68,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Column(
                            children: [
                              const Text('Selected Venues',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: selectedVenues.length,
                                          itemBuilder: (context, index) {
                                            var venue = selectedVenues[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: fluent.Checkbox(
                                                style: fluent.CheckboxThemeData(
                                                  checkedDecoration:
                                                      fluent.ButtonState.all(
                                                          const fluent
                                                              .BoxDecoration(
                                                              color:
                                                                  Colors.red)),
                                                ),
                                                content: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(venue.name!),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value ?? false) {
                                                      removingVenues.add(venue);
                                                    } else {
                                                      removingVenues
                                                          .remove(venue);
                                                    }
                                                  });
                                                },
                                                checked: removingVenues
                                                    .contains(venue),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              if (selectedVenues.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomButton(
                                      text: 'Save Venues',
                                      onPressed: () {
                                        CustomDialog.showInfo(
                                            message:
                                                'Are you sure you want to save the selected venues?',
                                            buttonText: 'Yes| Save',
                                            onPressed: () {
                                              ref
                                                  .read(specialVenueProvider
                                                      .notifier)
                                                  .saveVenues(
                                                      ref: ref,
                                                      venues: selectedVenues,
                                                      course: selectedCourse,context: context);
                                            });
                                      }),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
