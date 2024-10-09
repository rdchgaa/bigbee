import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:flutter/material.dart';

import 'dynamic_list_item.dart';

class DynamicListWidget extends StatefulWidget {
  const DynamicListWidget({super.key});

  @override
  State<DynamicListWidget> createState() => _DynamicListWidgetState();
}

class _DynamicListWidgetState extends State<DynamicListWidget> {
  List<DynamicListModel> models = DynamicListModel.getList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              ABToast.show(AB_getS(context, listen: false).lookForward);
            },
            child: SizedBox());
        // child: DynamicListItem(model: models[index]));
      },
      itemCount: models.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
