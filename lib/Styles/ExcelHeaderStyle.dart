import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Style headerStyle(Workbook workbook, String name) {
  Style globalStyle = workbook.styles.add(name);
  globalStyle.bold = true;
  globalStyle.fontSize = 12;
  globalStyle.fontColor = '#ffffff';
  globalStyle.backColor = '#282A3A';
  globalStyle.hAlign = HAlignType.center;
  globalStyle.vAlign = VAlignType.center;
  //set border
  globalStyle.borders.all.lineStyle = LineStyle.thin;
  globalStyle.borders.all.color = '#ffffff';
  return globalStyle;
}

Style instructionStyle(Workbook workbook, String name) {
  Style globalStyle = workbook.styles.add(name);
  globalStyle.bold = true;
  globalStyle.fontSize = 15;
  globalStyle.hAlign = HAlignType.center;
  globalStyle.wrapText = true;
  globalStyle.fontColor = '#FF0000';
  globalStyle.vAlign = VAlignType.center;

  return globalStyle;
}
