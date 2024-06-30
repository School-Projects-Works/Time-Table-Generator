import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future:
                DefaultAssetBundle.of(context).loadString('assets/about.md'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Markdown(
                    data: snapshot.data!,
                    shrinkWrap: true,
                    styleSheet: MarkdownStyleSheet(
                      p: getTextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      h2: getTextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox(
                    child: Center(
                  child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.white,
                      child: const CircularProgressIndicator()),
                ));
              }
            }),
      ),
    );
  }
}
