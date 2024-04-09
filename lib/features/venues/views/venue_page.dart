import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/table/data/models/custom_table_columns_model.dart';
import 'package:aamusted_timetable_generator/features/main/provider/main_provider.dart';
import 'package:aamusted_timetable_generator/features/venues/data/venue_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../config/theme/theme.dart';
import '../../../core/widget/custom_dialog.dart';
import '../../../core/widget/custom_input.dart';
import '../../../core/widget/table/data/models/custom_table_rows_model.dart';
import '../../../core/widget/table/widgets/custom_table.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../providers/venue_provider.dart';
import 'edit_venue.dart';

class VenuePage extends ConsumerStatefulWidget {
  const VenuePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VenuePageState();
}

class _VenuePageState extends ConsumerState<VenuePage> {
  @override
  Widget build(BuildContext context) {
    final venues = ref.watch(venueProvider);
    final venuesNotifier = ref.read(venueProvider.notifier);
    var tableTextStyle = getTextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
    return Container(
        color: Colors.grey.withOpacity(.1),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: [
                        Text('Available Venues'.toUpperCase(),
                            style: getTextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        CustomButton(
                            icon: fluent.FluentIcons.import,
                            color: Colors.green,
                            radius: 10,
                            text: 'Import Venues',
                            onPressed: () {
                              ref
                                  .read(venueDataImportProvider.notifier)
                                  .importData(ref);
                            }),
                        const SizedBox(width: 10),
                        CustomButton(
                            icon: fluent.FluentIcons.file_template,
                            radius: 10,
                            text: 'Download Template',
                            onPressed: () {
                              ref
                                  .read(venueDataImportProvider.notifier)
                                  .downloadTemplate();
                            }),
                        const SizedBox(width: 10),
                        if (ref.watch(venuesDataProvider).isNotEmpty)
                          CustomButton(
                              //red button
                              color: Colors.red,
                              text: 'Clear All Venue',
                              radius: 10,
                              onPressed: () {
                                CustomDialog.showInfo(
                                    message:
                                        'Are you sure you want to clear all venues? This action cannot be undone.',
                                    buttonText: 'Yes| Clear All',
                                    onPressed: () {
                                      ref
                                          .read(
                                              venueDataImportProvider.notifier)
                                          .deleteAllVenues(ref);
                                    });
                              }),
                        const SizedBox(width: 10),
                      ])),
                  const SizedBox(height: 20),
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: CustomTable<VenueModel>(
                      header: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Please Note: all venues with special venues will be highlighted in red untill you add venued to them',
                                        style: getTextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 600,
                              child: CustomTextFields(
                                hintText: 'Search for a venue',
                                suffixIcon:
                                    const Icon(fluent.FluentIcons.search),
                                onChanged: (value) {
                                  venuesNotifier.search(value);
                                },
                              ),
                            ),
                          ]),
                      isAllRowsSelected: true,
                      currentIndex: venues.currentPageItems.isNotEmpty
                          ? venues.items.indexOf(venues.currentPageItems[0]) + 1
                          : 0,
                      lastIndex: venues.pageSize * (venues.currentPage + 1),
                      pageSize: venues.pageSize,
                      onPageSizeChanged: (value) {
                        venuesNotifier.onPageSizeChange(value!);
                      },
                      onPreviousPage: venues.hasPreviousPage
                          ? () {
                              venuesNotifier.previousPage();
                            }
                          : null,
                      onNextPage: venues.hasNextPage
                          ? () {
                              venuesNotifier.nextPage();
                            }
                          : null,
                      rows: [
                        for (int i = 0; i < venues.currentPageItems.length; i++)
                          CustomTableRow(
                            item: venues.currentPageItems[i],
                            context: context,
                            index: i,
                            isHovered: ref.watch(venueItemHovered) ==
                                venues.currentPageItems[i],
                            selectRow: (value) {},
                            isSelected: false,
                            onHover: (value) {
                              if (value ?? false) {
                                ref.read(venueItemHovered.notifier).state =
                                    venues.currentPageItems[i];
                              }
                            },
                          )
                      ],
                      showColumnHeadersAtFooter: true,
                      data: venues.items,
                      columns: [
                        CustomTableColumn(
                          title: 'Venue Id',
                          width: 100,
                          cellBuilder: (item) => Text(
                            item.id ?? '',
                            style: tableTextStyle,
                          ),
                        ),
                        CustomTableColumn(
                          title: 'Venue Name',
                          //width: 200,
                          cellBuilder: (item) => Text(
                            item.name ?? '',
                            style: tableTextStyle,
                          ),
                        ),
                        CustomTableColumn(
                          title: 'Capacity',
                          width: 150,
                          cellBuilder: (item) => Text(
                            '${item.capacity ?? 0}',
                            style: tableTextStyle,
                          ),
                        ),

                        CustomTableColumn(
                          title: 'Is Special',
                          // width: 100,
                          cellBuilder: (item) => Text(
                            item.isSpecialVenue ?? false ? 'Yes' : 'No',
                            style: tableTextStyle,
                          ),
                        ),
                        CustomTableColumn(
                          title: 'Is Disability Access',
                          //width: 400,
                          cellBuilder: (item) => Text(
                            item.disabilityAccess ?? false ? 'Yes' : 'No',
                            style: tableTextStyle,
                          ),
                        ),

                        // delete button
                        CustomTableColumn(
                          title: 'Action',
                          //width: 100,
                          cellBuilder: (item) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  CustomDialog.showInfo(
                                      message:
                                          'Are you sure you want to delete this venue?',
                                      buttonText: 'Yes| Delete',
                                      onPressed: () {
                                        venuesNotifier.deleteVenue(item,ref);
                                      });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.red,
                                    //shadow
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              //edit button
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  CustomDialog.showCustom(
                                      width: 500,
                                      height: 350,
                                      ui: EditVenue(item));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.blue,
                                    //shadow
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                ])));
  }
}
