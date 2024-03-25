import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme/theme.dart';
import '../usecase/condition.dart';

class IncompleteDataPage extends ConsumerStatefulWidget {
  const IncompleteDataPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IncompleteDataPageState();
}

class _IncompleteDataPageState extends ConsumerState<IncompleteDataPage> {
  @override
  Widget build(BuildContext context) {
    var conditions = IncompleteConditions(ref: ref);
    return Container(
      color: Colors.grey.withOpacity(.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Incomplete Data'.toUpperCase(),
                style: getTextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (conditions.allocationExists() == false)
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.warning,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No Allocation Data (Class,Clourses,Lecturers) available',
                                        style: getTextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //description of thw warning
                                      Text(
                                        'Please navigate to the alocaiton page and import allocation sheets for all departments',
                                        style: getTextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!conditions.venueExists())
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.warning,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No Venue Data available',
                                        style: getTextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //description of thw warning
                                      Text(
                                        'Please navigate to the venue page and import venue data',
                                        style: getTextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!conditions.configExists())
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.warning,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No Configuration Data available',
                                        style: getTextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //description of thw warning
                                      Text(
                                        'Please navigate to the configuration page and create a configuration',
                                        style: getTextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!conditions.oneStudyModeExists())
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * .5,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.warning,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No Study Mode Data available',
                                        style: getTextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //description of thw warning
                                      Text(
                                        'Please navigate to the configuration page and create a study mode',
                                        style: getTextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!conditions.regularLibConfigExists())
                          Container(
                              margin: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * .5,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.warning,
                                      size: 60,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Missing Liberal Config for Regular',
                                            style: getTextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        //description of thw warning./database
                                        Text(
                                            'Please navigate to the configuration page and selecte day and period for liberal courses for regular students',
                                            style: getTextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ))
                                  ])),
                        if (!conditions.eveningLibConfigExists())
                          Container(
                              margin: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * .5,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.warning,
                                      size: 60,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Missing Liberal Config for Evening',
                                            style: getTextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        //description of thw warning
                                        Text(
                                            'Please navigate to the configuration page and selecte day and period for liberal courses for evening students',
                                            style: getTextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ))
                                  ])),
                        if (!conditions.specialVenuesFixed())
                          Container(
                              margin: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * .5,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.warning,
                                      size: 60,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Special Venues not fixed',
                                            style: getTextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        //description of thw warning
                                        Text(
                                            'Some Courses require special venues, Navigate to the courses page and locate all courses with red highlight and selecte venues for them',
                                            style: getTextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ))
                                  ])),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
