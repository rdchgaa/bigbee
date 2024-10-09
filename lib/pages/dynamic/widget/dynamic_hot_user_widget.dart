import 'package:bee_chat/models/dynamic/posts_hot_recommend_model.dart';
import 'package:bee_chat/pages/contact/user_details_page.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/utils/ab_assets.dart';
import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

class DynamicHotUserWidget extends StatelessWidget {
  final List<PostsHotRecommendModel> userAvatarUrls;
  const DynamicHotUserWidget({super.key, required this.userAvatarUrls});

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Container(
      height: 104.px,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userAvatarUrls.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 16.px),
            child: Stack(
              children: [
                InkWell(
                  onTap: (){
                    if(userAvatarUrls[index].memberNum==null)return;
                    ABRoute.push(UserDetailsPage(userId: userAvatarUrls[index].memberNum.toString()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.px),
                    width: 72.px,
                    height: 72.px,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(36.px),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36.px),
                      ),
                      padding: EdgeInsets.all(2.px),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.px),
                        child: Image.network(
                          userAvatarUrls[index].avatarUrl??'',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ).center,
                ),
                if (index < 3) Positioned(
                    bottom: 16.px,
                    right: 0,
                    child: Image.asset(ABAssets.dynamicHotIcon(context)), width: 22.px, height: 22.px,)
              ],
            ),
          );
        },
      ),
    );
  }
}
