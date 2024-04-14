import 'package:aamusted_timetable_generator/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> {
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(
        'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString('assets/help.md'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    Expanded(
                      child: Markdown(
                        data: snapshot.data!,
                        shrinkWrap: true,
                        styleSheet: MarkdownStyleSheet(
                          p: getTextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          h2: getTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        SizedBox(
                          width: 600,
                          height: 450,
                          // Use [Video] widget to display video output.
                          child: Video(controller: controller),
                        ),
                        const SizedBox(height: 20),
                        //add contact details if futher help is needed
                        Card(
                            elevation: 5,
                            child: Container(
                                width: 600,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'For further help contact',
                                        style: getTextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      const Row(children: [
                                        Icon(Icons.email),
                                        SizedBox(width: 10),
                                        Text(
                                          'emmanuel.f.nyamah@gmail.com',
                                        )
                                      ]),
                                      const SizedBox(height: 10),
                                      const Row(children: [
                                        Icon(Icons.phone),
                                        SizedBox(width: 10),
                                        Text(
                                          '+233 24 848 5308',
                                        )
                                      ]),
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  ],
                );
              }
              return SizedBox(
                  child: Center(
                child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                    child: const CircularProgressIndicator()),
              ));
            }),
      ),
    );
  }
}
