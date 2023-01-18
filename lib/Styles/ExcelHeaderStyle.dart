import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Style headerStyle(Workbook workbook, String name) {
  Style globalStyle = workbook.styles.add(name);
  globalStyle.bold = true;
  globalStyle.fontSize = 12;
  globalStyle.fontColor = '#FFFFFF';
  globalStyle.backColor = '#282A3A';
  globalStyle.hAlign = HAlignType.center;
  globalStyle.vAlign = VAlignType.center;
  return globalStyle;
}
