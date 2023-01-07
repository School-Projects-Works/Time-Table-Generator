import 'package:aamusted_timetable_generator/Components/CustomCheckBox.dart';
import 'package:aamusted_timetable_generator/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../SateManager/ConfigDataFlow.dart';

class DaysSection extends StatelessWidget {
  const DaysSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigDataFlow>(builder: (context, data, child) {
      return Container(
          width: double.infinity,
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Days',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('Select days on which class will take place and provide the category of students who will have class on these days.',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 20),
              CustomCheckBox(
               title: 'Monday',
               onTap: (){
                 if(data.getMonday.isEmpty) {
                   data.updateMonday('Monday');
                 }else{
                   data.updateMonday('');
                 }
               },
               isChecked: data.getMonday.isNotEmpty,
                onRegular: (){
                 if(data.getMonday['reg']==null||data.getMonday['reg']==false) {
                   data.updateMondayType('+Regular');
                 }else{
                   data.updateMondayType('-Regular');
                 }
                },
                regularChecked: data.getMonday['reg']!=null&& data.getMonday['reg'],
                onEvening: (){
                  if(data.getMonday['eve']==null||data.getMonday['eve']==false) {
                    data.updateMondayType('+Evening');
                  }else{
                    data.updateMondayType('-Evening');
                  }
                },
                eveningChecked: data.getMonday['eve']!=null&& data.getMonday['eve'],
                onWeekend: (){
                  if(data.getMonday['week']==null||data.getMonday['week']==false) {
                    data.updateMondayType('+Weekend');
                  }else{
                    data.updateMondayType('-Weekend');
                  }
                },
                weekendChecked: data.getMonday['week']!=null&& data.getMonday['week'],
             ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: 'Tuesday',
                onTap: (){
                  if(data.getTuesday.isEmpty) {
                    data.updateTuesday('Tuesday');
                  }else{
                    data.updateTuesday('');
                  }
                },
                isChecked: data.getTuesday.isNotEmpty,
                onRegular: (){
                  if(data.getTuesday['reg']==null||data.getTuesday['reg']==false) {
                    data.updateTuesdayType('+Regular');
                  }else{
                    data.updateTuesdayType('-Regular');
                  }
                },
                regularChecked: data.getTuesday['reg']!=null&& data.getTuesday['reg'],
                onEvening: (){
                  if(data.getTuesday['eve']==null||data.getTuesday['eve']==false) {
                    data.updateTuesdayType('+Evening');
                  }else{
                    data.updateTuesdayType('-Evening');
                  }
                },
                eveningChecked: data.getTuesday['eve']!=null&& data.getTuesday['eve'],
                onWeekend: (){
                  if(data.getTuesday['week']==null||data.getTuesday['week']==false) {
                    data.updateTuesdayType('+Weekend');
                  }else{
                    data.updateTuesdayType('-Weekend');
                  }
                },
                weekendChecked: data.getTuesday['week']!=null&& data.getTuesday['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: 'Wednesday',
                onTap: (){
                  if(data.getWednesday.isEmpty) {
                    data.updateWednesday('Wednesday');
                  }else{
                    data.updateWednesday('');
                  }
                },
                isChecked: data.getWednesday.isNotEmpty,
                onRegular: (){
                  if(data.getWednesday['reg']==null||data.getWednesday['reg']==false) {
                    data.updateWednesdayType('+Regular');
                  }else{
                    data.updateWednesdayType('-Regular');
                  }
                },
                regularChecked: data.getWednesday['reg']!=null&& data.getWednesday['reg'],
                onEvening: (){
                  if(data.getWednesday['eve']==null||data.getWednesday['eve']==false) {
                    data.updateWednesdayType('+Evening');
                  }else{
                    data.updateWednesdayType('-Evening');
                  }
                },
                eveningChecked: data.getWednesday['eve']!=null&& data.getWednesday['eve'],
                onWeekend: (){
                  if(data.getWednesday['week']==null||data.getWednesday['week']==false) {
                    data.updateWednesdayType('+Weekend');
                  }else{
                    data.updateWednesdayType('-Weekend');
                  }
                },
                weekendChecked: data.getWednesday['week']!=null&& data.getWednesday['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: 'Thursday',
                onTap: (){
                  if(data.getThursday.isEmpty) {
                    data.updateThursday('Thursday');
                  }else{
                    data.updateThursday('');
                  }
                },
                isChecked: data.getThursday.isNotEmpty,
                onRegular: (){
                  if(data.getThursday['reg']==null||data.getThursday['reg']==false) {
                    data.updateThursdayType('+Regular');
                  }else{
                    data.updateThursdayType('-Regular');
                  }
                },
                regularChecked: data.getThursday['reg']!=null&& data.getThursday['reg'],
                onEvening: (){
                  if(data.getThursday['eve']==null||data.getThursday['eve']==false) {
                    data.updateThursdayType('+Evening');
                  }else{
                    data.updateThursdayType('-Evening');
                  }
                },
                eveningChecked: data.getThursday['eve']!=null&& data.getThursday['eve'],
                onWeekend: (){
                  if(data.getThursday['week']==null||data.getThursday['week']==false) {
                    data.updateThursdayType('+Weekend');
                  }else{
                    data.updateThursdayType('-Weekend');
                  }
                },
                weekendChecked: data.getThursday['week']!=null&& data.getThursday['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: 'Friday',
                onTap: (){
                  if(data.getFriday.isEmpty) {
                    data.updateFriday('Friday');
                  }else{
                    data.updateFriday('');
                  }
                },
                isChecked: data.getFriday.isNotEmpty,
                onRegular: (){
                  if(data.getFriday['reg']==null||data.getFriday['reg']==false) {
                    data.updateFridayType('+Regular');
                  }else{
                    data.updateFridayType('-Regular');
                  }
                },
                regularChecked: data.getFriday['reg']!=null&& data.getFriday['reg'],
                onEvening: (){
                  if(data.getFriday['eve']==null||data.getFriday['eve']==false) {
                    data.updateFridayType('+Evening');
                  }else{
                    data.updateFridayType('-Evening');
                  }
                },
                eveningChecked: data.getFriday['eve']!=null&& data.getFriday['eve'],
                onWeekend: (){
                  if(data.getFriday['week']==null||data.getFriday['week']==false) {
                    data.updateFridayType('+Weekend');
                  }else{
                    data.updateFridayType('-Weekend');
                  }
                },
                weekendChecked: data.getFriday['week']!=null&& data.getFriday['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: 'Saturday',
                onTap: (){
                  if(data.getSaturday.isEmpty) {
                    data.updateSaturday('Saturday');
                  }else{
                    data.updateSaturday('');
                  }
                },
                isChecked: data.getSaturday.isNotEmpty,
                onRegular: (){
                  if(data.getSaturday['reg']==null||data.getSaturday['reg']==false) {
                    data.updateSaturdayType('+Regular');
                  }else{
                    data.updateSaturdayType('-Regular');
                  }
                },
                regularChecked: data.getSaturday['reg']!=null&& data.getSaturday['reg'],
                onEvening: (){
                  if(data.getSaturday['eve']==null||data.getSaturday['eve']==false) {
                    data.updateSaturdayType('+Evening');
                  }else{
                    data.updateSaturdayType('-Evening');
                  }
                },
                eveningChecked: data.getSaturday['eve']!=null&& data.getSaturday['eve'],
                onWeekend: (){
                  if(data.getSaturday['week']==null||data.getSaturday['week']==false) {
                    data.updateSaturdayType('+Weekend');
                  }else{
                    data.updateSaturdayType('-Weekend');
                  }
                },
                weekendChecked: data.getSaturday['week']!=null&& data.getSaturday['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: 'Sunday',
                onTap: (){
                  if(data.getSunday.isEmpty) {
                    data.updateSunday('Sunday');
                  }else{
                    data.updateSunday('');
                  }
                },
                isChecked: data.getSunday.isNotEmpty,
                onRegular: (){
                  if(data.getSunday['reg']==null||data.getSunday['reg']==false) {
                    data.updateSundayType('+Regular');
                  }else{
                    data.updateSundayType('-Regular');
                  }
                },
                regularChecked: data.getSunday['reg']!=null&& data.getSunday['reg'],
                onEvening: (){
                  if(data.getSunday['eve']==null||data.getSunday['eve']==false) {
                    data.updateSundayType('+Evening');
                  }else{
                    data.updateSundayType('-Evening');
                  }
                },
                eveningChecked: data.getSunday['eve']!=null&& data.getSunday['eve'],
                onWeekend: (){
                  if(data.getSunday['week']==null||data.getSunday['week']==false) {
                    data.updateSundayType('+Weekend');
                  }else{
                    data.updateSundayType('-Weekend');
                  }
                },
                weekendChecked: data.getSunday['week']!=null&& data.getSunday['week'],
              ),
              const SizedBox(height: 15),
            ],
          ));
    });
  }
}
