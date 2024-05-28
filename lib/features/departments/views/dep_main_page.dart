import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_button.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_dialog.dart';
import 'package:aamusted_timetable_generator/core/widget/custom_input.dart';
import 'package:aamusted_timetable_generator/features/departments/data/department_model.dart';
import 'package:aamusted_timetable_generator/features/departments/provider/department_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Data/department_data_section.dart';

class DepartmentPage extends ConsumerStatefulWidget {
  const DepartmentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends ConsumerState<DepartmentPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var departments = ref.watch(departmentStream);
    return Container(
        color: Colors.grey.withOpacity(.1),
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: [
                        Text('Department Allocations'.toUpperCase(),
                            style: getTextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ])),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        //department list
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextFields(
                                    hintText: 'Search Department',
                                    controller: _controller,
                                    onChanged: (value) {
                                      ref
                                          .read(departmentsProvider.notifier)
                                          .filterDepartments(value);
                                    },
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 50,
                                        child: CustomButton(
                                            radius: 10,
                                            padding: const EdgeInsets.all(10),
                                            text: '',
                                            onPressed: () {
                                              if (_controller.text.isNotEmpty) {
                                                ref
                                                    .read(departmentsProvider
                                                        .notifier)
                                                    .addDepartment(
                                                        _controller.text);
                                                _controller.clear();
                                              } else {
                                                CustomDialog.showToast(
                                                    message:
                                                        'Please enter a department name');
                                              }
                                            },
                                            icon: Icons.add),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Expanded(
                                    child: departments.when(data: (data) {
                                      if (data.isEmpty) {
                                        return const Center(
                                            child: Text('No Department Found'));
                                      }
                                      var departmentList =
                                          ref.watch(departmentsProvider);
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ListView.builder(
                                              itemCount: departmentList
                                                  .filteredItems.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                var item = departmentList
                                                    .filteredItems[index];
                                                var selectedDepartment = ref.watch(
                                                    selectedDepartmentProvider);

                                                if (selectedDepartment ==
                                                        null ||
                                                    selectedDepartment.id !=
                                                        item.id) {
                                                  return _buildDepartmentItem(
                                                      item);
                                                } else {
                                                  return _buildEdit();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }, error: (error, stack) {
                                      return Center(
                                          child: Text('Error: $error'));
                                    }, loading: () {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Card(
                              color: Colors.grey.shade200,
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: DataSection(),
                              ),
                            ))
                      ],
                    ),
                  )
                ])));
  }

  Widget _buildEdit() {
    var item = ref.watch(selectedDepartmentProvider);
    var notifier = ref.read(selectedDepartmentProvider.notifier);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        )),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFields(
                hintText: 'Department Name',
                controller: _editController..text = item!.name!,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 125,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: CustomButton(
                            padding: const EdgeInsets.all(10),
                            color: Colors.green,
                            radius: 10,
                            text: '',
                            onPressed: () {
                              notifier.updateDepartment(
                                  ref, _editController.text);
                            },
                            icon: Icons.update,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 50,
                          child: CustomButton(
                            padding: const EdgeInsets.all(10),
                            color: Colors.red,
                            radius: 10,
                            text: '',
                            onPressed: () {
                              notifier.clearSelectedDepartment();
                            },
                            icon: Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildDepartmentItem(DepartmentModel item) {
    var activeItem = ref.watch(activeDepartmentProvider);
    return InkWell(
      onTap: () {
        ref.read(activeDepartmentProvider.notifier).setActiveDepartment(item);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
              color: activeItem != null && activeItem.id == item.id
                  ? Colors.green
                  : Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              )),
          child: Row(
            children: [
              Text(
                item.id!,
                style: getTextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(item.name!, style: getTextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    ref
                        .read(selectedDepartmentProvider.notifier)
                        .setSelectedDepartment(item);
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 24,
                  )),
              const SizedBox(width: 5),
              IconButton(
                  onPressed: () {
                    CustomDialog.showInfo(
                        message:
                            'Are you sure you want to delete this department? This action cannot be undone',
                        buttonText: 'Yes',
                        onPressed: () {
                          ref
                              .read(departmentsProvider.notifier)
                              .deleteDepartment(item);
                        });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 24,
                  ))
            ],
          )),
    );
  }
}
