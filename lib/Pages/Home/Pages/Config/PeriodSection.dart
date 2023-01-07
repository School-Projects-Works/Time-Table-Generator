import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CustomCheckBox.dart';
import '../../../../SateManager/ConfigDataFlow.dart';

class PeriodSection extends StatelessWidget {
  const PeriodSection({Key? key}) : super(key: key);

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
                'Select Periods',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('Select periods on which class will take place and provide the category of students who will have class on these periods.',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 20),
              CustomCheckBox(
                title: '1st Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodOneStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodOneEnd(value);
                },
                startVal: data.periodOne['start'],
                endVal: data.periodOne['end'],
                onTap: (){
                  if(data.getMonday.isEmpty) {
                    data.updatePeriodOne('1st Period');
                  }else{
                    data.updatePeriodOne('');
                  }
                },
                isChecked: data.getPeriodOne.isNotEmpty,
                onRegular: (){
                  if(data.getPeriodOne['reg']==null||data.getPeriodOne['reg']==false) {
                    data.updatePeriodOneType('+Regular');
                  }else{
                    data.updatePeriodOneType('-Regular');
                  }
                },
                regularChecked: data.getPeriodOne['reg']!=null&& data.getPeriodOne['reg'],
                onEvening: (){
                  if(data.getPeriodOne['eve']==null||data.getPeriodOne['eve']==false) {
                    data.updatePeriodOneType('+Evening');
                  }else{
                    data.updatePeriodOneType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodOne['eve']!=null&& data.getPeriodOne['eve'],
                onWeekend: (){
                  if(data.getPeriodOne['week']==null||data.getPeriodOne['week']==false) {
                    data.updatePeriodOneType('+Weekend');
                  }else{
                    data.updatePeriodOneType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodOne['week']!=null&& data.getPeriodOne['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: '2nd Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodTwoStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodTwoEnd(value);
                },
                startVal: data.periodTwo['start'],
                endVal: data.periodTwo['end'],
                onTap: (){
                  if(data.getMonday.isEmpty) {
                    data.updatePeriodTwo('2nd Period');
                  }else{
                    data.updatePeriodTwo('');
                  }
                },
                isChecked: data.getPeriodTwo.isNotEmpty,
                onRegular: (){
                  if(data.getPeriodTwo['reg']==null||data.getPeriodTwo['reg']==false) {
                    data.updatePeriodTwo('+Regular');
                  }else{
                    data.updatePeriodTwo('-Regular');
                  }
                },
                regularChecked: data.getPeriodTwo['reg']!=null&& data.getPeriodTwo['reg'],
                onEvening: (){
                  if(data.getPeriodTwo['eve']==null||data.getPeriodTwo['eve']==false) {
                    data.updatePeriodTwoType('+Evening');
                  }else{
                    data.updatePeriodTwoType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodTwo['eve']!=null&& data.getPeriodTwo['eve'],
                onWeekend: (){
                  if(data.getPeriodTwo['week']==null||data.getPeriodTwo['week']==false) {
                    data.updatePeriodTwoType('+Weekend');
                  }else{
                    data.updatePeriodTwoType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodTwo['week']!=null&& data.getPeriodTwo['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: '3rd Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodThreeStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodThreeEnd(value);
                },
                startVal: data.periodThree['start'],
                endVal: data.periodThree['end'],
                onTap: (){
                  if(data.getMonday.isEmpty) {
                    data.updatePeriodThree('3rd Period');
                  }else{
                    data.updatePeriodThree('');
                  }
                },
                isChecked: data.getPeriodThree.isNotEmpty,
                onRegular: (){
                  if(data.getPeriodThree['reg']==null||data.getPeriodThree['reg']==false) {
                    data.updatePeriodThreeType('+Regular');
                  }else{
                    data.updatePeriodThreeType('-Regular');
                  }
                },
                regularChecked: data.getPeriodThree['reg']!=null&& data.getPeriodThree['reg'],
                onEvening: (){
                  if(data.getPeriodThree['eve']==null||data.getPeriodThree['eve']==false) {
                    data.updatePeriodThreeType('+Evening');
                  }else{
                    data.updatePeriodThreeType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodThree['eve']!=null&& data.getPeriodThree['eve'],
                onWeekend: (){
                  if(data.getPeriodThree['week']==null||data.getPeriodThree['week']==false) {
                    data.updatePeriodThreeType('+Weekend');
                  }else{
                    data.updatePeriodThreeType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodThree['week']!=null&& data.getPeriodThree['week'],
              ),
              const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 25),
              CustomCheckBox(
                title: '4th Period',
                hasDropDown: true,
                onStartChanged: (value) {
                  data.setPeriodFourStart(value);
                },
                onEndChanged: (value) {
                  data.setPeriodFourEnd(value);
                },
                startVal: data.periodFour['start'],
                endVal: data.periodFour['end'],
                onTap: (){
                  if(data.getMonday.isEmpty) {
                    data.updatePeriodFour('4th Period');
                  }else{
                    data.updatePeriodFour('');
                  }
                },
                isChecked: data.getPeriodFour.isNotEmpty,
                onRegular: (){
                  if(data.getPeriodFour['reg']==null||data.getPeriodFour['reg']==false) {
                    data.updatePeriodFourType('+Regular');
                  }else{
                    data.updatePeriodFourType('-Regular');
                  }
                },
                regularChecked: data.getPeriodFour['reg']!=null&& data.getPeriodFour['reg'],
                onEvening: (){
                  if(data.getPeriodFour['eve']==null||data.getPeriodFour['eve']==false) {
                    data.updatePeriodFourType('+Evening');
                  }else{
                    data.updatePeriodFourType('-Evening');
                  }
                },
                eveningChecked: data.getPeriodFour['eve']!=null&& data.getPeriodFour['eve'],
                onWeekend: (){
                  if(data.getPeriodFour['week']==null||data.getPeriodFour['week']==false) {
                    data.updatePeriodFourType('+Weekend');
                  }else{
                    data.updatePeriodFourType('-Weekend');
                  }
                },
                weekendChecked: data.getPeriodFour['week']!=null&& data.getPeriodFour['week'],
              ),
              const SizedBox(height: 15),

            ],
          ));
    });
  }
}
