import 'package:bee_chat/models/assets/coin_model.dart';
import 'package:bee_chat/models/dynamic/posts_reward_options_model.dart';
import 'package:bee_chat/net/assets_net.dart';
import 'package:bee_chat/net/dynamics_net.dart';
import 'package:bee_chat/provider/language_provider.dart';
import 'package:bee_chat/provider/theme_provider.dart';
import 'package:bee_chat/provider/user_provider.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:bee_chat/utils/ab_toast.dart';
import 'package:bee_chat/utils/extensions/widget_extensions.dart';
import 'package:bee_chat/widget/ab_button.dart';
import 'package:bee_chat/widget/ab_image.dart';
import 'package:bee_chat/widget/ab_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future showHelpPostDialog(
  BuildContext context, {
  required int postId,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DialogHelpPostBox(
        postId: postId,
      );
    },
  );
}

class DialogHelpPostBox extends StatefulWidget {
  final int postId;

  const DialogHelpPostBox({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _DialogHelpPostBoxState createState() => _DialogHelpPostBoxState();
}

class _DialogHelpPostBoxState extends State<DialogHelpPostBox> {
  List<PostsRewardOptionsModel> listReward = [];
  String? memberUse;
  CoinModel? theCoin;

  PostsRewardOptionsModel? selectedReward;

  double _keyboardHeight = 0.0;

  int inputTime = 0; //小时

  GlobalKey<NumInputWidgetState> numInputKey = GlobalKey<NumInputWidgetState>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    var resultRecords = await DynamicsNet.dynamicsHotPostPaySetList();
    if (resultRecords.data != null && resultRecords.data!.isNotEmpty) {
      listReward = resultRecords.data!;
      selectedReward = resultRecords.data![0];
      getMemberUse(resultRecords.data![0].payCoinId ?? 0);
      setState(() {});
    }
  }

  getMemberUse(int coinId) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    List<CoinModel> coinList = provider.coinList;

    for (CoinModel coin in coinList) {
      if (coin.id == coinId) {
        theCoin = coin;
        break;
      }
    }
    setState(() {});
    final resultMemberUse = await AssetsNet.assetsGetMemberUseCapital(coinId: coinId);
    if (resultMemberUse.data != null) {
      memberUse = resultMemberUse.data;
    }else{
      memberUse = null;
    }
    setState(() {});
  }

  submit() async {
    double? payNum = selectedReward!.payQty;

    int hotTimes = 1;

    //类型（1：固定数量、2：自定义数量）
    if (selectedReward?.type == 1) {
      hotTimes = selectedReward!.durationNum!.toInt();
      payNum = selectedReward!.payQty;
    } else {
      hotTimes = inputTime;
      payNum = (selectedReward!.price ?? 0) * inputTime;
    }
    final result = await DynamicsNet.dynamicsHotPostPay(
      postId: widget.postId,
      hotTimes: hotTimes,
      payPrice: payNum??0,
      hotSetId: selectedReward!.id!,
    );
    if (result.code == 200) {
      Navigator.of(context).pop(true);
      ABToast.show(AB_S().hotPostSuccessful,toastType: ToastType.success);
    } else {
      Navigator.of(context).pop(false);
      ABToast.show(result.message??AB_S().verificationFailedInsufficientBalance,toastType: ToastType.fail);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 监听键盘高度变化
    final newKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _keyboardHeight = newKeyboardHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12.px)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.px, top: 15.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ABText(
                    AB_S().selectDurationHotPost,
                    textColor: theme.textColor,
                    fontSize: 18.px,
                    fontWeight: FontWeight.w600,
                  ),
                  ABText(
                    AB_S().currentRemaining + ' ' + (memberUse ?? '') + ' ' + (theCoin?.coinName ?? ''),
                    textColor: theme.text999,
                    fontSize: 14.px,
                  ).padding(top: 10.px, bottom: 26.px),
                  GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.px),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //设置列数
                      crossAxisCount: 4,
                      //设置横向间距
                      crossAxisSpacing: 8.px,
                      //设置主轴间距
                      mainAxisSpacing: 8.px,
                      childAspectRatio: 80 / 40,
                    ),
                    shrinkWrap: true,
                    // 避免内部子项的尺寸影响外部容器的高度
                    itemCount: listReward.length,
                    // 总共20个项目
                    itemBuilder: (context, index) {
                      PostsRewardOptionsModel item = listReward[index];

                      //类型（1：固定数量、2：自定义数量）
                      if (item.type == 1) {
                        return getRewardItemBuild(item);
                      } else {
                        return getInputItemBuild(item);
                      }
                    },
                  ),
                  if (selectedReward != null)
                    Builder(builder: (context) {
                      var payNum = selectedReward!.payQty;
                      //类型（1：固定数量、2：自定义数量）
                      if (selectedReward?.type == 1) {
                        payNum = selectedReward!.payQty;
                      } else {
                        payNum = (selectedReward!.price ?? 0) * inputTime;
                      }

                      return ABText(
                        '${AB_S().currentPaymentRequired} $payNum ${theCoin?.coinName ?? ''}',
                        textColor: theme.text999,
                        fontSize: 14.px,
                      ).padding(
                        top: 24.px,
                      );
                    }),
                  SizedBox(height: 14.px),
                  Builder(
                    builder: (context) {
                      bool canClick = false;
                      if(selectedReward==null){
                        canClick = false;
                      }else{
                        //类型（1：固定数量、2：自定义数量）
                        if (selectedReward?.type == 1) {
                          canClick = true;
                        } else {
                          if(inputTime>0){
                            canClick = true;
                          }
                        }
                      }
                      return Padding(
                        padding: EdgeInsets.only(left: 16.0.px, right: 16.px),
                        child: ABButton.gradientColorButton(
                          colors: !canClick
                              ? [theme.text999, theme.text999]
                              : [theme.primaryColor, theme.secondaryColor],
                          cornerRadius: 12,
                          height: 48,
                          text: AB_getS(context).payNow,
                          onPressed: () {
                            if(canClick) submit();
                          },
                        ),
                      );
                    }
                  ),
                  SizedBox(
                    height: _keyboardHeight,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getRewardItemBuild(PostsRewardOptionsModel item) {
    final theme = AB_theme(context);

    var isSelected = item.id == selectedReward?.id;
    var time = item.durationNum?.toStringAsFixed(0) ?? '1';

    return InkWell(
      onTap: () {
        numInputKey.currentState?.focusNode.unfocus();
        setState(() {
          selectedReward = item;
          getMemberUse(item.payCoinId ?? 0);
        });
      },
      child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), color: isSelected ? theme.primaryColor : theme.f4f4f4),
          child: Center(
            child: ABText(
              time + AB_S().hour2,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textColor: isSelected ? theme.white : theme.textColor,
            ),
          )),
    );
  }

  getInputItemBuild(PostsRewardOptionsModel item) {
    final theme = AB_theme(context);

    var isSelected = item.id == selectedReward?.id;
    var time = item.durationNum?.toStringAsFixed(0) ?? '1';

    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: isSelected ? theme.primaryColor : theme.f4f4f4),
        child: NumInputWidget(
          key:numInputKey,
          onFocusChange: () {
            selectedReward = item;
            getMemberUse(item.payCoinId ?? 0);
            setState(() {});
          },
          onChange: (int value) {
            inputTime = value;
            setState(() {});
          },
        ));
  }
}

class NumInputWidget extends StatefulWidget {
  final Function(int) onChange;
  final Function onFocusChange;

  const NumInputWidget({
    super.key,
    required this.onChange,
    required this.onFocusChange,
  });

  @override
  State<NumInputWidget> createState() => NumInputWidgetState();
}

class NumInputWidgetState extends State<NumInputWidget> {
  TextEditingController numText = TextEditingController(text: '');

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      widget.onFocusChange();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = AB_theme(context);
    return Center(
      child: TextField(
        focusNode: focusNode,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        obscureText: false,
        controller: numText,
        onChanged: (text) {
          if (text.startsWith('0')) {
            numText.text = numText.text.substring(1);
            setState(() {});
          }
          widget.onChange(int.tryParse(numText.text) ?? 0);
        },
        onSubmitted: (text) {},
        enabled: true,
        keyboardType: TextInputType.number,
        maxLength: 100,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 12),
          counterText: '',
          hintText: AB_S().otherDuration,
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 14.px, color: theme.textColor),
          labelStyle: TextStyle(fontSize: 14.px, color: theme.textColor),
        ),
        style: TextStyle(
          fontSize: 14.px,
          color: theme.textColor,
        ),
        inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      ),
    );
  }
}
