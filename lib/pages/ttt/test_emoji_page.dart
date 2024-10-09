import 'package:bee_chat/provider/custom_emoji_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/widget/ab_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class TestEmojiPage extends StatefulWidget {
  const TestEmojiPage({super.key});

  @override
  State<TestEmojiPage> createState() => _TestEmojiPageState();
}

class _TestEmojiPageState extends State<TestEmojiPage> {

  @override
  void initState() {

    String emoji = "https://fonts.gstatic.com/s/e/notoemoji/latest/1f602/512.gif";


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    List<String> urls = [
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f602/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f603/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f604/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f605/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f606/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f607/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f608/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f609/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f60a/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f60b/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f60c/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f60d/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f60e/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f60f/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f610/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f611/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f612/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f613/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f614/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f615/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f615/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f617/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f618/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f619/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f61a/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f61b/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f61c/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f61d/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f61e/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f61f/512.gif",
      "https://fonts.gstatic.com/s/e/notoemoji/latest/1f620/512.gif",
    ];
    CustomEmojiProvider provider = Provider.of<CustomEmojiProvider>(
        MyApp.context,
        listen: false);
    urls = provider.customEmojiList.first.emoticonsInfoList!.map((e) => e.imgUrl!).toList();

    return Scaffold(
      appBar: ABAppBar(title: "Emoji"),
      backgroundColor: theme.white,
      body: Container(
        child: GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 8,
        childAspectRatio: 1,
      ),
      children: (urls+urls+urls+urls+urls+urls).map(
            (item) {
          return Padding(
              padding: const EdgeInsets.all(8),
              child: GifView.network(
                item,
                // height: 200,
                // width: 200,
              ),
          );
        },
      ).toList(),
    ),
      ),
    );
  }
}
