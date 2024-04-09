import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:aamusted_timetable_generator/features/venues/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/venue_model.dart';

class EditVenue extends ConsumerStatefulWidget {
  const EditVenue(this.item, {super.key});
  final VenueModel item;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditVenueState();
}

class _EditVenueState extends ConsumerState<EditVenue> {
  final _formKey = GlobalKey<FormState>();
  final _venueNameController = TextEditingController();
  final _venueCapacityController = TextEditingController();
  bool? _isSpecial;
  bool? _dissableAccess;

  @override
  void initState() {
    super.initState();
    _venueNameController.text = widget.item.name ?? '';
    _venueCapacityController.text = widget.item.capacity.toString();
    _isSpecial = widget.item.isSpecialVenue;
    _dissableAccess = widget.item.disabilityAccess;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Venue',
                        style: getTextStyle(
                            color: secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            CustomDialog.dismiss();
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFields(
                    label: 'Venue Name',
                    controller: _venueNameController,
                    isCapitalized: true,
                    validator: (name) {
                      if (name!.isEmpty) {
                        return 'Venue name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                  const SizedBox(height: 22),
                  Row(children: [
                    Expanded(
                      child: CustomTextFields(
                        label: 'Capacity',
                        controller: _venueCapacityController,
                        keyboardType: TextInputType.number,
                        validator: (capacity) {
                          if (capacity!.isEmpty) {
                            return 'Capacity is required';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    Container(
                      width: 4,
                      height: 70,
                      color: primaryColor,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Special Venue'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: _isSpecial,
                                  onChanged: (value) {
                                    setState(() {
                                      _isSpecial = value;
                                    });
                                  }),
                              const Text('Yes'),
                              const SizedBox(width: 10),
                              Radio(
                                  value: false,
                                  groupValue: _isSpecial,
                                  onChanged: (value) {
                                    setState(() {
                                      _isSpecial = value;
                                    });
                                  }),
                              const Text('No'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 4,
                      height: 70,
                      color: primaryColor,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Disability Access'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: _dissableAccess,
                                  onChanged: (value) {
                                    setState(() {
                                      _dissableAccess = value;
                                    });
                                  }),
                              const Text('Yes'),
                              const SizedBox(width: 10),
                              Radio(
                                  value: false,
                                  groupValue: _dissableAccess,
                                  onChanged: (value) {
                                    setState(() {
                                      _dissableAccess = value;
                                    });
                                  }),
                              const Text('No'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 25),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: CustomButton(
                          radius: 10,
                          color: primaryColor,
                          text: 'Update Venue',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              final venue = VenueModel(
                                  id: widget.item.id,
                                  name: _venueNameController.text,
                                  capacity: int.parse(_venueCapacityController.text),
                                  isSpecialVenue: _isSpecial!,
                                  disabilityAccess: _dissableAccess!);
                              ref.read(venueDataImportProvider.notifier).updateVenue(venue,ref);
                              CustomDialog.dismiss();
                            }
                          }))
                ],
              )),
        ),
      ),
    );
  }
}
