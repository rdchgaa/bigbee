import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data' as typed_data;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/src/constants/extensions.dart';
import 'package:wechat_assets_picker/src/internal/singleton.dart';
import 'package:wechat_assets_picker/src/widget/builder/value_listenable_builder_2.dart';
import 'package:wechat_assets_picker/src/widget/gaps.dart';
import 'package:wechat_assets_picker/src/widget/platform_progress_indicator.dart';
import 'package:wechat_assets_picker/src/widget/scale_text.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MyPicker<Asset, Path> extends StatefulWidget {
  final ThumbnailSize gridThumbnailSize;
  final ThumbnailSize? previewThumbnailSize;
  final ThemeData theme;
  final bool shouldBuildSpecialItem;
  final Duration switchingPathDuration;
  final DefaultAssetPickerProvider provider;
  final AssetPickerTextDelegate textDelegate;
  final AssetPickerTextDelegate semanticsTextDelegate;

  /// The [PermissionState] when the picker is called.
  /// 当选择器被拉起时的权限状态
  final PermissionState initialPermission;

  final int gridCount;

  final Color? themeColor;

  final ThemeData? pickerTheme;

  /// Allow users set a special item in the picker with several positions.
  /// 允许用户在选择器中添加一个自定义 item，并指定位置
  final SpecialItemPosition specialItemPosition;

  /// The widget builder for the the special item.
  /// 自定义 item 的构造方法
  final SpecialItemBuilder<Path>? specialItemBuilder;

  /// Indicates the loading status for the builder.
  /// 指示目前加载的状态
  final LoadingIndicatorBuilder? loadingIndicatorBuilder;

  /// {@macro wechat_assets_picker.AssetSelectPredicate}
  final AssetSelectPredicate<Asset>? selectPredicate;

  /// The [ScrollController] for the preview grid.
  final ScrollController gridScrollController;

  /// If path switcher opened.
  /// 是否正在进行路径选择
  final ValueNotifier<bool> isSwitchingPath;

  /// The [GlobalKey] for [assetsGridBuilder] to locate the [ScrollView.center].
  /// [assetsGridBuilder] 用于定位 [ScrollView.center] 的 [GlobalKey]
  final GlobalKey gridRevertKey;

  /// Whether the assets grid should revert.
  /// 判断资源网格是否需要倒序排列
  ///
  /// [Null] means judging by [isAppleOS].
  /// 使用 [Null] 即使用 [isAppleOS] 进行判断。
  final bool? shouldRevertGrid;

  /// {@macro wechat_assets_picker.LimitedPermissionOverlayPredicate}
  final LimitedPermissionOverlayPredicate? limitedPermissionOverlayPredicate;

  /// {@macro wechat_assets_picker.PathNameBuilder}
  final PathNameBuilder<AssetPathEntity>? pathNameBuilder;

  final SpecialPickerType? specialPickerType;

  const MyPicker(
      {super.key,
      required this.theme,
      required this.shouldBuildSpecialItem,
      required this.switchingPathDuration,
      required this.provider,
      this.loadingIndicatorBuilder,
      required this.textDelegate,
      required this.semanticsTextDelegate,
      required this.initialPermission,
      required this.gridCount,
      this.themeColor,
      this.pickerTheme,
      required this.specialItemPosition,
      this.specialItemBuilder,
      this.selectPredicate,
      this.shouldRevertGrid,
      this.limitedPermissionOverlayPredicate,
      this.pathNameBuilder,
      required this.gridScrollController,
      required this.isSwitchingPath,
      required this.gridRevertKey,
      this.specialPickerType,
      required this.gridThumbnailSize,
      this.previewThumbnailSize});

  @override
  State<MyPicker> createState() => _MyPickerState();
}

class _MyPickerState<Asset, Path> extends State<MyPicker> {
  bool isNativeImage = false;
  bool isMinxImage = false;

  Curve get switchingPathCurve => Curves.easeInOutQuad;
  Size? appBarPreferredSize;

  /// Space between assets item widget.
  /// 资源部件之间的间隔
  double get itemSpacing => 2;

  /// Item's height in app bar.
  /// 顶栏内各个组件的统一高度
  double get appBarItemHeight => 48;

  /// Blur radius in Apple OS layout mode.
  /// 苹果系列系统布局方式下的模糊度
  double get appleOSBlurRadius => 10;

  /// Height for the bottom occupied section.
  /// 底部区域占用的高度
  double get bottomSectionHeight => bottomActionBarHeight + permissionLimitedBarHeight;

  /// Height for bottom action bar.
  /// 底部操作栏的高度
  double get bottomActionBarHeight => kToolbarHeight / 1.1;

  double get bottomPreviewHeight => 90.0;

  /// Height for the permission limited bar.
  /// 权限受限栏的高度
  double get permissionLimitedBarHeight => isPermissionLimited ? 75 : 0;

  /// Notifier for the current [PermissionState].
  /// 当前 [PermissionState] 的监听
  late final ValueNotifier<PermissionState> permission = ValueNotifier<PermissionState>(
    widget.initialPermission,
  );
  late final ValueNotifier<bool> permissionOverlayDisplay = ValueNotifier<bool>(
    widget.limitedPermissionOverlayPredicate?.call(permission.value) ?? (permission.value == PermissionState.limited),
  );

  /// Whether the permission is limited currently.
  /// 当前的权限是否为受限
  bool get isPermissionLimited => permission.value == PermissionState.limited;

  bool effectiveShouldRevertGrid(BuildContext context) => widget.shouldRevertGrid ?? isAppleOS(context);

  AssetPickerTextDelegate get textDelegate => Singleton.textDelegate;

  AssetPickerTextDelegate get semanticsTextDelegate => Singleton.textDelegate.semanticsTextDelegate;

  bool get isWeChatMoment => widget.specialPickerType == SpecialPickerType.wechatMoment;

  /// Whether the preview of assets is enabled.
  /// 资源的预览是否启用
  bool get isPreviewEnabled => widget.specialPickerType != SpecialPickerType.noPreview;

  @override
  bool get isSingleAssetMode => widget.provider.maxAssets == 1;

  int selectType = 2; //1：图片 ，2：全部，3：视频

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {}

  bool isAppleOS(BuildContext context) => switch (widget.theme.platform) {
        TargetPlatform.iOS || TargetPlatform.macOS => true,
        _ => false,
      };

  @override
  Widget build(BuildContext context) {
    return AssetPickerAppBarWrapper(
      appBar: appBar(context),
      body: Consumer<DefaultAssetPickerProvider>(
        builder: (BuildContext context, DefaultAssetPickerProvider p, _) {
          final bool shouldDisplayAssets = p.hasAssetsToDisplay || widget.shouldBuildSpecialItem;
          return AnimatedSwitcher(
            duration: widget.switchingPathDuration,
            child: shouldDisplayAssets
                ? Stack(
                    children: <Widget>[
                      RepaintBoundary(
                        child: Column(
                          children: <Widget>[
                            Expanded(child: assetsGridBuilder(context)),
                            if (isPreviewEnabled || !isSingleAssetMode) bottomActionBar(context),
                          ],
                        ),
                      ),
                      pathEntityListBackdrop(context),
                      pathEntityListWidget(context),
                    ],
                  )
                : loadingIndicator(context),
          );
        },
      ),
    );
  }

  Widget pathEntityListBackdrop(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isSwitchingPath,
      builder: (_, bool isSwitchingPath, __) => Positioned.fill(
        child: IgnorePointer(
          ignoring: !isSwitchingPath,
          child: ExcludeSemantics(
            child: GestureDetector(
              onTap: () => widget.isSwitchingPath.value = false,
              child: AnimatedOpacity(
                duration: widget.switchingPathDuration,
                opacity: isSwitchingPath ? .75 : 0,
                child: const ColoredBox(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color interactiveTextColor(BuildContext context) => Color.lerp(
        context.iconTheme.color?.withOpacity(.7) ?? Colors.white,
        Colors.blueAccent,
        0.4,
      )!;

  Widget pathEntityListWidget(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    return Positioned.fill(
      // top: isAppleOS(context) ? context.topPadding + appBarPreferredSize!.height : 0,
      top: 0,
      bottom: null,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.isSwitchingPath,
        builder: (_, bool isSwitchingPath, Widget? child) => Semantics(
          hidden: isSwitchingPath ? null : true,
          child: AnimatedAlign(
            duration: widget.switchingPathDuration,
            curve: switchingPathCurve,
            alignment: Alignment.bottomCenter,
            heightFactor: isSwitchingPath ? 1 : 0,
            child: AnimatedOpacity(
              duration: widget.switchingPathDuration,
              curve: switchingPathCurve,
              opacity: !isAppleOS(context) || isSwitchingPath ? 1 : 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * (isAppleOS(context) ? .6 : .8),
                  ),
                  color: widget.theme.colorScheme.background,
                  child: child,
                ),
              ),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ValueListenableBuilder<PermissionState>(
              valueListenable: permission,
              builder: (_, PermissionState ps, Widget? child) => Semantics(
                label: '${semanticsTextDelegate.viewingLimitedAssetsTip}, '
                    '${semanticsTextDelegate.changeAccessibleLimitedAssets}',
                button: true,
                onTap: PhotoManager.presentLimited,
                hidden: !isPermissionLimited,
                focusable: isPermissionLimited,
                excludeSemantics: true,
                child: isPermissionLimited ? child : const SizedBox.shrink(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: textDelegate.viewingLimitedAssetsTip,
                      ),
                      TextSpan(
                        text: ' '
                            '${textDelegate.changeAccessibleLimitedAssets}',
                        style: TextStyle(color: interactiveTextColor(context)),
                        recognizer: TapGestureRecognizer()..onTap = PhotoManager.presentLimited,
                      ),
                    ],
                  ),
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 14),
                ),
              ),
            ),
            Flexible(
              child: Selector<DefaultAssetPickerProvider, List<PathWrapper<AssetPathEntity>>>(
                selector: (_, DefaultAssetPickerProvider p) => p.paths,
                builder: (_, List<PathWrapper<AssetPathEntity>> paths, __) {
                  final List<PathWrapper<AssetPathEntity>> filtered = paths
                      .where(
                        (PathWrapper<AssetPathEntity> p) => p.assetCount != 0,
                      )
                      .toList();
                  final brightness = MediaQuery.platformBrightnessOf(context);
                  bool isDarkMode = brightness == Brightness.dark;
                  return ListView.separated(
                    padding: const EdgeInsetsDirectional.only(top: 1),
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext c, int i) => pathEntityWidget(
                      context: c,
                      list: filtered,
                      index: i,
                    ),
                    separatorBuilder: (_, __) => Container(
                      margin: const EdgeInsetsDirectional.only(start: 60),
                      height: 1,
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pathEntityWidget({
    required BuildContext context,
    required List<PathWrapper<AssetPathEntity>> list,
    required int index,
  }) {
    final PathWrapper<AssetPathEntity> wrapper = list[index];
    final AssetPathEntity pathEntity = wrapper.path;
    final typed_data.Uint8List? data = wrapper.thumbnailData;

    Widget builder() {
      if (data != null) {
        return Image.memory(data, fit: BoxFit.cover);
      }
      if (pathEntity.type.containsAudio()) {
        return ColoredBox(
          color: widget.theme.colorScheme.primary.withOpacity(0.12),
          child: const Center(child: Icon(Icons.audiotrack)),
        );
      }
      return ColoredBox(color: widget.theme.colorScheme.primary.withOpacity(0.12));
    }

    final String pathName = widget.pathNameBuilder?.call(pathEntity) ?? pathEntity.name;
    final String name = isPermissionLimited && pathEntity.isAll ? textDelegate.accessiblePathName : pathName;
    final String semanticsName =
        isPermissionLimited && pathEntity.isAll ? semanticsTextDelegate.accessiblePathName : pathName;
    final String? semanticsCount = wrapper.assetCount?.toString();
    final StringBuffer labelBuffer = StringBuffer(
      '$semanticsName, ${semanticsTextDelegate.sUnitAssetCountLabel}',
    );
    if (semanticsCount != null) {
      labelBuffer.write(': $semanticsCount');
    }
    return Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
      selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
      builder: (_, PathWrapper<AssetPathEntity>? currentWrapper, __) {
        final bool isSelected = currentWrapper?.path == pathEntity;
        return Semantics(
          label: labelBuffer.toString(),
          selected: isSelected,
          onTapHint: semanticsTextDelegate.sActionSwitchPathLabel,
          button: false,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashFactory: InkSplash.splashFactory,
              onTap: () {
                Feedback.forTap(context);
                context.read<DefaultAssetPickerProvider>().switchPath(wrapper);
                widget.isSwitchingPath.value = false;
                widget.gridScrollController.jumpTo(0);
              },
              child: SizedBox(
                height: isAppleOS(context) ? 64 : 52,
                child: Row(
                  children: <Widget>[
                    RepaintBoundary(
                      child: AspectRatio(aspectRatio: 1, child: builder()),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 15,
                          end: 20,
                        ),
                        child: ExcludeSemantics(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    end: 10,
                                  ),
                                  child: ScaleText(
                                    name,
                                    style: const TextStyle(fontSize: 17),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (semanticsCount != null)
                                ScaleText(
                                  '($semanticsCount)',
                                  style: TextStyle(
                                    color: widget.theme.textTheme.bodySmall?.color,
                                    fontSize: 17,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isSelected)
                      AspectRatio(
                        aspectRatio: 1,
                        child: Icon(Icons.check, color: widget.themeColor, size: 26),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AssetPickerAppBar appBar(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    bool isDarkMode = brightness == Brightness.dark;
    final AssetPickerAppBar appBar = AssetPickerAppBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      // title: Semantics(
      //   onTapHint: semanticsTextDelegate.sActionSwitchPathLabel,
      //   child: pathEntitySelector(context),
      // ),
      title: titleSelectBuild(),
      leading: backButton(context),
      // actions: [pathEntitySelector(context)],
      blurRadius: isAppleOS(context) ? 10 : 0,
    );
    appBarPreferredSize ??= appBar.preferredSize;
    return appBar;
  }

  Widget backButton(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    bool isDarkMode = brightness == Brightness.dark;
    final Color titleColor = isDarkMode ? Colors.white : Colors.black;
    // final theme = AB_theme(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        onPressed: Navigator.of(context).maybePop,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: Icon(
          CupertinoIcons.arrow_left,
          color: titleColor,
        ),
      ),
    );
  }

  Widget titleSelectBuild() {
    var paddingLeft = 19.0;
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              widget.provider.selectType = 1;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(left: paddingLeft, right: paddingLeft, top: 5, bottom: 5),
              child: Text(
                widget.textDelegate.image,
                style: TextStyle(
                    color: widget.pickerTheme?.textTheme.titleMedium?.color,
                    fontSize: widget.provider.selectType == 1 ? 18 : 16,
                    fontWeight: widget.provider.selectType == 1 ? FontWeight.w600 : null),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.provider.selectType = 2;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(left: paddingLeft, right: paddingLeft, top: 5, bottom: 5),
              child: Text(
                widget.textDelegate.all,
                style: TextStyle(
                    color: widget.pickerTheme?.textTheme.titleMedium?.color,
                    fontSize: widget.provider.selectType == 2 ? 18 : 16,
                    fontWeight: widget.provider.selectType == 2 ? FontWeight.w600 : null),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.provider.selectType = 3;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(left: paddingLeft, right: paddingLeft, top: 5, bottom: 5),
              child: Text(
                widget.textDelegate.video,
                style: TextStyle(
                    color: widget.pickerTheme?.textTheme.titleMedium?.color,
                    fontSize: widget.provider.selectType == 3 ? 18 : 16,
                    fontWeight: widget.provider.selectType == 3 ? FontWeight.w600 : null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pathEntitySelector(BuildContext context) {
    Widget pathText(
      BuildContext context,
      String text,
      String semanticsText,
    ) {
      return Flexible(
        child: ScaleText(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          maxScaleFactor: 1.2,
          semanticsLabel: semanticsText,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: UnconstrainedBox(
        child: GestureDetector(
          onTap: () {
            if (isPermissionLimited && widget.provider.isAssetsEmpty) {
              PhotoManager.presentLimited();
              return;
            }
            if (widget.provider.currentPath == null) {
              return;
            }
            widget.isSwitchingPath.value = !widget.isSwitchingPath.value;
          },
          child: Container(
            height: appBarItemHeight,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.5,
            ),
            padding: const EdgeInsetsDirectional.only(start: 12, end: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: widget.theme.dividerColor,
            ),
            child: Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
              selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
              builder: (_, PathWrapper<AssetPathEntity>? p, Widget? w) {
                final AssetPathEntity? path = p?.path;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (path == null && isPermissionLimited)
                      pathText(
                        context,
                        textDelegate.changeAccessibleLimitedAssets,
                        semanticsTextDelegate.changeAccessibleLimitedAssets,
                      ),
                    if (path != null)
                      pathText(
                        context,
                        isPermissionLimited && path.isAll
                            ? textDelegate.accessiblePathName
                            : widget.pathNameBuilder?.call(path) ?? path.name,
                        isPermissionLimited && path.isAll
                            ? semanticsTextDelegate.accessiblePathName
                            : widget.pathNameBuilder?.call(path) ?? path.name,
                      ),
                    w!,
                  ],
                );
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.theme.iconTheme.color!.withOpacity(0.5),
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: widget.isSwitchingPath,
                    builder: (_, bool isSwitchingPath, Widget? w) {
                      return Transform.rotate(
                        angle: isSwitchingPath ? math.pi : 0,
                        child: w,
                      );
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 15,
                      color: widget.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget assetsGridBuilder(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    final bool gridRevert = effectiveShouldRevertGrid(context);
    return Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
      selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
      builder: (
        BuildContext context,
        PathWrapper<AssetPathEntity>? wrapper,
        _,
      ) {
        // First, we need the count of the assets.
        int totalCount = wrapper?.assetCount ?? 0;
        final Widget? specialItem;
        // If user chose a special item's position, add 1 count.
        if (widget.specialItemPosition != SpecialItemPosition.none) {
          specialItem = widget.specialItemBuilder?.call(
            context,
            wrapper?.path,
            totalCount,
          );
          if (specialItem != null) {
            totalCount += 1;
          }
        } else {
          specialItem = null;
        }
        if (totalCount == 0 && specialItem == null) {
          return loadingIndicator(context);
        }
        // Then we use the [totalCount] to calculate placeholders we need.
        final int placeholderCount;
        if (gridRevert && totalCount % widget.gridCount != 0) {
          // When there are left items that not filled into one row,
          // filled the row with placeholders.
          placeholderCount = widget.gridCount - totalCount % widget.gridCount;
        } else {
          // Otherwise, we don't need placeholders.
          placeholderCount = 0;
        }
        // Calculate rows count.
        final int row = (totalCount + placeholderCount) ~/ widget.gridCount;
        // Here we got a magic calculation. [itemSpacing] needs to be divided by
        // [gridCount] since every grid item is squeezed by the [itemSpacing],
        // and it's actual size is reduced with [itemSpacing / gridCount].
        final double dividedSpacing = itemSpacing / widget.gridCount;
        final double topPadding = appBarPreferredSize!.height;

        Widget sliverGrid(BuildContext context, List<AssetEntity> assets) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, int index) => Builder(
                builder: (BuildContext context) {
                  if (gridRevert) {
                    if (index < placeholderCount) {
                      return const SizedBox.shrink();
                    }
                    index -= placeholderCount;
                  }
                  return MergeSemantics(
                    child: Directionality(
                      textDirection: Directionality.of(context),
                      child: assetGridItemBuilder(
                        context,
                        index,
                        assets,
                        specialItem: specialItem,
                      ),
                    ),
                  );
                },
              ),
              childCount: assetsGridItemCount(
                context: context,
                assets: assets,
                placeholderCount: placeholderCount,
                specialItem: specialItem,
              ),
              findChildIndexCallback: (Key? key) {
                if (key is ValueKey<String>) {
                  return findChildIndexBuilder(
                    id: key.value,
                    assets: assets,
                    placeholderCount: placeholderCount,
                  );
                }
                return null;
              },
              // Explicitly disable semantic indexes for custom usage.
              addSemanticIndexes: false,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.gridCount,
              mainAxisSpacing: itemSpacing,
              crossAxisSpacing: itemSpacing,
            ),
          );
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double itemSize = constraints.maxWidth / widget.gridCount;
            // Check whether all rows can be placed at the same time.
            final bool onlyOneScreen = row * itemSize <=
                constraints.maxHeight - context.bottomPadding - topPadding - permissionLimitedBarHeight;
            final double height;
            if (onlyOneScreen) {
              height = constraints.maxHeight;
            } else {
              // Reduce [permissionLimitedBarHeight] for the final height.
              height = constraints.maxHeight - permissionLimitedBarHeight;
            }
            // Use [ScrollView.anchor] to determine where is the first place of
            // the [SliverGrid]. Each row needs [dividedSpacing] to calculate,
            // then minus one times of [itemSpacing] because spacing's count in the
            // cross axis is always less than the rows.
            final double anchor = math.min(
              (row * (itemSize + dividedSpacing) + topPadding - itemSpacing) / height,
              1,
            );
            final brightness = MediaQuery.platformBrightnessOf(context);
            bool isDarkMode = brightness == Brightness.dark;
            return Directionality(
              textDirection: effectiveGridDirection(context),
              child: ColoredBox(
                color: isDarkMode ? Color(0xff030303) : Color(0xfffbfbfb),
                // color: Color(0xFFFBFBFB),
                // color: Color(0xFFFFFFFF),
                // TODO:图片选择界面
                child: Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
                  selector: (_, DefaultAssetPickerProvider p) => widget.provider.selectType == 1
                      ? p.currentImageAssets
                      : widget.provider.selectType == 2
                          ? p.currentAssets
                          : p.currentVideoAssets,
                  builder: (BuildContext context, List<AssetEntity> assets, _) {
                    final SliverGap bottomGap = SliverGap.v(
                      context.bottomPadding + bottomSectionHeight,
                    );
                    appBarPreferredSize ??= appBar(context).preferredSize;
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: widget.gridScrollController,
                      anchor: gridRevert ? anchor : 0,
                      center: gridRevert ? widget.gridRevertKey : null,
                      slivers: <Widget>[
                        // if (isAppleOS(context))
                        //   SliverGap.v(
                        //     context.topPadding + appBarPreferredSize!.height,
                        //   ),
                        sliverGrid(context, assets),
                        // Ignore the gap when the [anchor] is not equal to 1.
                        if (gridRevert && anchor == 1) bottomGap,
                        if (gridRevert)
                          SliverToBoxAdapter(
                            key: widget.gridRevertKey,
                            child: const SizedBox.shrink(),
                          ),
                        // if (isAppleOS(context) && !gridRevert) bottomGap,
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  int findChildIndexBuilder({
    required String id,
    required List<AssetEntity> assets,
    int placeholderCount = 0,
  }) {
    int index = assets.indexWhere((AssetEntity e) => e.id == id);
    if (widget.specialItemPosition == SpecialItemPosition.prepend) {
      index += 1;
    }
    index += placeholderCount;
    return index;
  }

  int assetsGridItemCount({
    required BuildContext context,
    required List<AssetEntity> assets,
    int placeholderCount = 0,
    Widget? specialItem,
  }) {
    final PathWrapper<AssetPathEntity>? currentWrapper =
        context.select<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
      (DefaultAssetPickerProvider p) => p.currentPath,
    );
    final AssetPathEntity? currentPathEntity = currentWrapper?.path;
    final int length = assets.length + placeholderCount;

    // Return 1 if the [specialItem] build something.
    if (currentPathEntity == null && specialItem != null) {
      return placeholderCount + 1;
    }

    // Return actual length if the current path is all.
    // 如果当前目录是全部内容，则返回实际的内容数量。
    if (currentPathEntity?.isAll != true && specialItem == null) {
      return length;
    }
    return switch (widget.specialItemPosition) {
      SpecialItemPosition.none => length,
      SpecialItemPosition.prepend || SpecialItemPosition.append => length + 1,
    };
  }

  Widget loadingIndicator(BuildContext context) {
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.isAssetsEmpty,
      builder: (BuildContext context, bool isAssetsEmpty, Widget? w) {
        if (widget.loadingIndicatorBuilder != null) {
          return widget.loadingIndicatorBuilder!(context, isAssetsEmpty);
        }
        return Center(child: isAssetsEmpty ? emptyIndicator(context) : w);
      },
      child: PlatformProgressIndicator(
        color: widget.theme.iconTheme.color,
        size: MediaQuery.sizeOf(context).width / widget.gridCount / 3,
      ),
    );
  }

  Widget assetGridItemBuilder(
    BuildContext context,
    int index,
    List<AssetEntity> currentAssets, {
    Widget? specialItem,
  }) {
    final DefaultAssetPickerProvider p = context.read<DefaultAssetPickerProvider>();
    final int length = currentAssets.length;
    final PathWrapper<AssetPathEntity>? currentWrapper = p.currentPath;
    final AssetPathEntity? currentPathEntity = currentWrapper?.path;

    if (specialItem != null) {
      if ((index == 0 && widget.specialItemPosition == SpecialItemPosition.prepend) ||
          (index == length && widget.specialItemPosition == SpecialItemPosition.append)) {
        return specialItem;
      }
    }

    final int currentIndex;
    if (specialItem != null && widget.specialItemPosition == SpecialItemPosition.prepend) {
      currentIndex = index - 1;
    } else {
      currentIndex = index;
    }

    if (currentPathEntity == null) {
      return const SizedBox.shrink();
    }

    if (p.hasMoreToLoad) {
      if ((p.pageSize <= widget.gridCount * 3 && index == length - 1) || index == length - widget.gridCount * 3) {
        p.loadMoreAssets();
      }
    }

    final AssetEntity asset = currentAssets.elementAt(currentIndex);
    final Widget builder = switch (asset.type) {
      AssetType.image || AssetType.video => imageAndVideoItemBuilder(context, currentIndex, asset),
      AssetType.audio => audioItemBuilder(context, currentIndex, asset),
      AssetType.other => const SizedBox.shrink(),
    };
    final Widget content = Stack(
      key: ValueKey<String>(asset.id),
      children: <Widget>[
        builder,
        selectedBackdrop(context, currentIndex, asset),
        if (!isWeChatMoment || asset.type != AssetType.video) selectIndicator(context, index, asset),
        // itemBannedIndicator(context, asset),
      ],
    );
    return assetGridItemSemanticsBuilder(context, index, asset, content);
  }

  Widget itemBannedIndicator(BuildContext context, AssetEntity asset) {
    return Consumer<AssetPickerProvider<Asset, Path>>(
      builder: (_, AssetPickerProvider<Asset, Path> p, __) {
        if (!p.selectedAssets.contains(asset) && p.selectedMaximumAssets) {
          return Container(
            color: widget.theme.colorScheme.background.withOpacity(.85),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget selectIndicator(BuildContext context, int index, AssetEntity asset) {
    final double indicatorSize = MediaQuery.sizeOf(context).width / widget.gridCount / 3;
    final Duration duration = widget.switchingPathDuration * 0.75;
    return Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider dp, __) {
        final int index = dp.selectedAssets.indexOf(asset);
        return Selector<DefaultAssetPickerProvider, String>(
          selector: (_, DefaultAssetPickerProvider p) => p.selectedDescriptions,
          builder: (BuildContext context, String descriptions, __) {
            final bool selected = descriptions.contains(asset.toString());
            final Widget innerSelector = AnimatedContainer(
              duration: duration,
              width: indicatorSize / (isAppleOS(context) ? 1.25 : 1.5),
              height: indicatorSize / (isAppleOS(context) ? 1.25 : 1.5),
              padding: EdgeInsets.all(indicatorSize / 10),
              decoration: BoxDecoration(
                border: !selected
                    ? Border.all(
                        // color: context.theme.unselectedWidgetColor,
                        color: Colors.white,
                        width: indicatorSize / 25,
                      )
                    : null,
                color: selected ? Color(0xffFFCB32) : null,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: AnimatedSwitcher(
                  duration: duration,
                  reverseDuration: duration,
                  child:
                      // selected ? const Icon(Icons.check) : const SizedBox.shrink(),
                      selected
                          ? Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.white),
                            )
                          : const SizedBox.shrink(),
                ),
              ),
            );
            final Widget selectorWidget = GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => selectAsset(context, asset, index, selected),
              child: Container(
                margin: EdgeInsets.all(indicatorSize / 4),
                width: isPreviewEnabled ? indicatorSize : null,
                height: isPreviewEnabled ? indicatorSize : null,
                alignment: AlignmentDirectional.topEnd,
                child: (!isPreviewEnabled && isSingleAssetMode && !selected) ? const SizedBox.shrink() : innerSelector,
              ),
            );
            if (isPreviewEnabled) {
              return PositionedDirectional(
                top: 0,
                end: 0,
                child: selectorWidget,
              );
            }
            return selectorWidget;
          },
        );
      },
    );
  }

  Widget assetGridItemSemanticsBuilder(
    BuildContext context,
    int index,
    AssetEntity asset,
    Widget child,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isSwitchingPath,
      builder: (_, bool isSwitchingPath, Widget? child) {
        return Consumer<DefaultAssetPickerProvider>(
          builder: (_, DefaultAssetPickerProvider p, __) {
            final bool isBanned = (!p.selectedAssets.contains(asset) && p.selectedMaximumAssets) ||
                (isWeChatMoment && asset.type == AssetType.video && p.selectedAssets.isNotEmpty);
            final bool isSelected = p.selectedDescriptions.contains(
              asset.toString(),
            );
            final int selectedIndex = p.selectedAssets.indexOf(asset) + 1;
            String hint = '';
            if (asset.type == AssetType.audio || asset.type == AssetType.video) {
              hint += '${semanticsTextDelegate.sNameDurationLabel}: ';
              hint += semanticsTextDelegate.durationIndicatorBuilder(
                asset.videoDuration,
              );
            }
            if (asset.title?.isNotEmpty ?? false) {
              hint += ', ${asset.title}';
            }
            return Semantics(
              button: false,
              enabled: !isBanned,
              excludeSemantics: true,
              focusable: !isSwitchingPath,
              label: '${semanticsTextDelegate.semanticTypeLabel(asset.type)}'
                  '${semanticIndex(index)}, '
                  '${asset.createDateTime.toString().replaceAll('.000', '')}',
              hidden: isSwitchingPath,
              hint: hint,
              image: asset.type == AssetType.image || asset.type == AssetType.video,
              onTap: () => selectAsset(context, asset, index, isSelected),
              onTapHint: semanticsTextDelegate.sActionSelectHint,
              onLongPress: isPreviewEnabled ? () => viewAsset(context, index, asset) : null,
              onLongPressHint: semanticsTextDelegate.sActionPreviewHint,
              selected: isSelected,
              sortKey: OrdinalSortKey(
                semanticIndex(index).toDouble(),
                name: 'GridItem',
              ),
              value: selectedIndex > 0 ? '$selectedIndex' : null,
              child: GestureDetector(
                // Regression https://github.com/flutter/flutter/issues/35112.
                onLongPress: isPreviewEnabled && MediaQuery.accessibleNavigationOf(context)
                    ? () => viewAsset(context, index, asset)
                    : null,
                child: IndexedSemantics(
                  index: semanticIndex(index),
                  child: child,
                ),
              ),
            );
          },
        );
      },
      child: child,
    );
  }

  Future<void> viewAsset(
    BuildContext context,
    int index,
    AssetEntity currentAsset,
  ) async {
    final DefaultAssetPickerProvider provider = context.read<DefaultAssetPickerProvider>();
    // - When we reached the maximum select count and the asset is not selected,
    //   do nothing.
    // - When the special type is WeChat Moment, pictures and videos cannot
    //   be selected at the same time. Video select should be banned if any
    //   pictures are selected.
    if ((!provider.selectedAssets.contains(currentAsset) && provider.selectedMaximumAssets) ||
        (isWeChatMoment && currentAsset.type == AssetType.video && provider.selectedAssets.isNotEmpty)) {
      return;
    }
    List<AssetEntity> current;
    final List<AssetEntity>? selected;
    final int effectiveIndex;
    if (isWeChatMoment) {
      if (currentAsset.type == AssetType.video) {
        current = <AssetEntity>[currentAsset];
        selected = null;
        effectiveIndex = 0;
      } else {
        current = provider.currentAssets.where((AssetEntity e) => e.type == AssetType.image).toList();
        selected = provider.selectedAssets;
        effectiveIndex = current.indexOf(currentAsset);
      }
    } else {
      current = provider.currentAssets;
      selected = provider.selectedAssets;
      effectiveIndex = index;
    }
    final DefaultAssetPickerProvider p = context.read<DefaultAssetPickerProvider>();
    if(p.selectType == 1){//图片
      current = p.currentImageAssets;
    }else if(p.selectType == 3){//视频
      current = p.currentVideoAssets;
    }
    final List<AssetEntity>? result = await AssetPickerViewer.pushToViewer(
      context,
      currentIndex: effectiveIndex,
      previewAssets: current,
      themeData: widget.theme,
      previewThumbnailSize: widget.previewThumbnailSize,
      selectPredicate: widget.selectPredicate,
      selectedAssets: selected,
      selectorProvider: provider,
      specialPickerType: widget.specialPickerType,
      maxAssets: provider.maxAssets,
      shouldReversePreview: isAppleOS(context),
    );
    if (result != null) {
      AssetPickerResultData data =
          AssetPickerResultData(assets: result, isNativeImage: isNativeImage, isMinxImage: isMinxImage);

      Navigator.of(context).maybePop(data);
    }
  }

  Future<void> selectAsset(
    BuildContext context,
    AssetEntity asset,
    int index,
    bool selected,
  ) async {
    final bool? selectPredicateResult = await widget.selectPredicate?.call(
      context,
      asset,
      selected,
    );
    if (selectPredicateResult == false) {
      return;
    }
    final DefaultAssetPickerProvider provider = context.read<DefaultAssetPickerProvider>();
    if (selected) {
      provider.unSelectAsset(asset);
      return;
    }
    if (isSingleAssetMode) {
      provider.selectedAssets.clear();
    }
    provider.selectAsset(asset);
    if (isSingleAssetMode && !isPreviewEnabled) {
      AssetPickerResultData data = AssetPickerResultData(
          assets: provider.selectedAssets, isNativeImage: isNativeImage, isMinxImage: isMinxImage);

      Navigator.of(context).maybePop(data);
    }
  }

  int semanticIndex(int index) {
    if (widget.specialItemPosition != SpecialItemPosition.prepend) {
      return index + 1;
    }
    return index;
  }

  Widget imageAndVideoItemBuilder(
    BuildContext context,
    int index,
    AssetEntity asset,
  ) {
    final AssetEntityImageProvider imageProvider = AssetEntityImageProvider(
      asset,
      isOriginal: false,
      thumbnailSize: widget.gridThumbnailSize,
    );
    SpecialImageType? type;
    if (imageProvider.imageFileType == ImageFileType.gif) {
      type = SpecialImageType.gif;
    } else if (imageProvider.imageFileType == ImageFileType.heic) {
      type = SpecialImageType.heic;
    }
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: RepaintBoundary(
            child: AssetEntityGridItemBuilder(
              image: imageProvider,
              failedItemBuilder: failedItemBuilder,
            ),
          ),
        ),
        if (type == SpecialImageType.gif) // 如果为GIF则显示标识
          gifIndicator(context, asset),
        if (asset.type == AssetType.video) // 如果为视频则显示标识
          videoIndicator(context, asset),
      ],
    );
  }

  Widget videoIndicator(BuildContext context, AssetEntity asset) {
    return PositionedDirectional(
      start: 0,
      end: 0,
      bottom: 0,
      child: Container(
        width: double.maxFinite,
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomCenter,
            end: AlignmentDirectional.topCenter,
            colors: <Color>[widget.theme.dividerColor, Colors.transparent],
          ),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.videocam, size: 22, color: Colors.white),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 4),
                child: ScaleText(
                  textDelegate.durationIndicatorBuilder(
                    Duration(seconds: asset.duration),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1.4,
                  ),
                  maxLines: 1,
                  maxScaleFactor: 1.2,
                  semanticsLabel: semanticsTextDelegate.durationIndicatorBuilder(
                    Duration(seconds: asset.duration),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gifIndicator(BuildContext context, AssetEntity asset) {
    return PositionedDirectional(
      start: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomCenter,
            end: AlignmentDirectional.topCenter,
            colors: <Color>[widget.theme.dividerColor, Colors.transparent],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: !isAppleOS(context)
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: widget.theme.iconTheme.color!.withOpacity(0.75),
                )
              : null,
          child: ScaleText(
            textDelegate.gifIndicator,
            style: TextStyle(
              color: isAppleOS(context) ? widget.theme.textTheme.bodyMedium?.color : widget.theme.primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            semanticsLabel: semanticsTextDelegate.gifIndicator,
            strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
          ),
        ),
      ),
    );
  }

  Widget failedItemBuilder(BuildContext context) {
    return Center(
      child: ScaleText(
        textDelegate.loadFailed,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
        semanticsLabel: semanticsTextDelegate.loadFailed,
      ),
    );
  }

  /// The effective direction for the assets grid.
  /// 网格实际的方向
  ///
  /// By default, the direction will be reversed if it's iOS/macOS.
  /// 默认情况下，在 iOS/macOS 上方向会反向。
  TextDirection effectiveGridDirection(BuildContext context) {
    final TextDirection od = Directionality.of(context);
    if (effectiveShouldRevertGrid(context)) {
      if (od == TextDirection.ltr) {
        return TextDirection.rtl;
      }
      return TextDirection.ltr;
    }
    return od;
  }

  /// The tip widget displays when the access is limited.
  /// 当访问受限时在底部展示的提示
  Widget accessLimitedBottomTip(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        PhotoManager.openSetting();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: permissionLimitedBarHeight,
        color: widget.theme.primaryColor.withOpacity(isAppleOS(context) ? 0.90 : 1),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 5),
            Icon(
              Icons.warning,
              color: Colors.orange[400]!.withOpacity(.8),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ScaleText(
                textDelegate.accessAllTip,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                ),
                semanticsLabel: semanticsTextDelegate.accessAllTip,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: context.iconTheme.color?.withOpacity(.5),
            ),
          ],
        ),
      ),
    );
  }

  /// Preview item widgets for audios.
  /// 音频的底部预览部件
  Widget _audioPreviewItem(AssetEntity asset) {
    return ColoredBox(
      color: widget.theme.dividerColor,
      child: const Center(child: Icon(Icons.audiotrack)),
    );
  }

  /// Preview item widgets for images.
  /// 图片的底部预览部件
  Widget _imagePreviewItem(AssetEntity asset) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: ExtendedImage(
          image: AssetEntityImageProvider(asset, isOriginal: false),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Preview item widgets for video.
  /// 视频的底部预览部件
  Widget _videoPreviewItem(AssetEntity asset) {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          _imagePreviewItem(asset),
          Center(
            child: Icon(
              Icons.video_library,
              color: widget.theme.iconTheme.color?.withOpacity(0.54),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomDetailItemBuilder(BuildContext context, int index) {
    const double padding = 8.0;

    void onTap(AssetEntity asset) {
      final int page;
      viewAsset(context, index, asset);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding / 2,
      ),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Consumer<DefaultAssetPickerProvider>(
          builder: (context, DefaultAssetPickerProvider p, __) {
            final AssetEntity asset = p.selectedAssets.elementAt(index);
            final Widget item = switch (asset.type) {
              AssetType.image => _imagePreviewItem(asset),
              AssetType.video => _videoPreviewItem(asset),
              AssetType.audio => _audioPreviewItem(asset),
              AssetType.other => const SizedBox.shrink(),
            };
            return Semantics(
              label: '${semanticsTextDelegate.semanticTypeLabel(asset.type)}'
                  '${index + 1}',
              onTap: () => onTap(asset),
              onTapHint: semanticsTextDelegate.sActionPreviewHint,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => onTap(asset),
                child: Selector<AssetPickerViewerProvider<AssetEntity>?, List<AssetEntity>?>(
                  selector: (_, AssetPickerViewerProvider<AssetEntity>? p) => p?.currentlySelectedAssets,
                  child: item,
                  builder: (
                    _,
                    List<AssetEntity>? currentlySelectedAssets,
                    Widget? w,
                  ) {
                    final bool isSelected = currentlySelectedAssets?.contains(asset) ?? false;
                    return ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Stack(
                        children: <Widget>[
                          w!,
                          AnimatedContainer(
                            duration: kThemeAnimationDuration,
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: InkWell(
                              onTap: () {
                                // onChangingSelected(context, asset, true);
                                p.unSelectAsset(asset);
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8)), color: Color(0xffd9d9d9)),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Action bar widget aligned to bottom.
  /// 底部操作栏部件
  Widget bottomActionBar(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    bool isDarkMode = brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Colors.black : Colors.white;

    Widget child = Consumer<DefaultAssetPickerProvider>(
      builder: (context, DefaultAssetPickerProvider p, __) {
        var height = bottomActionBarHeight + context.bottomPadding + bottomPreviewHeight + 30 + 10 + 10;
        if (p.selectedAssets.length == 0) {
          height = bottomActionBarHeight + context.bottomPadding + 30 + 10;
        }
        return Container(
          height: height,
          padding: EdgeInsets.only(left: 0, right: 0, bottom: MediaQuery.of(context).padding.bottom + 10),
          // color:
          //     widget.theme.primaryColor.withOpacity(isAppleOS(context) ? 0.90 : 1),
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: p.selectedAssets.length > 0 ? bottomPreviewHeight + 20 : 0,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      if (p.selectedAssets.length != 0)
                        SizedBox(
                          height: 30,
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12, bottom: 2),
                                child: Text(
                                  textDelegate.selectTip
                                      .replaceAll('\${num}', p.selectedAssets.length.toString())
                                      .replaceAll('\${numMax}', p.maxAssets.toString()),
                                  style: TextStyle(fontSize: 14, color: Color(0xff989897)),
                                ),
                              )),
                        ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
                          physics: const ClampingScrollPhysics(),
                          itemCount: p.selectedAssets.length,
                          itemBuilder: bottomDetailItemBuilder,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    if (p.showOriginalBtn || p.showMergeSend) previewButton(context),
                    Expanded(child: confirmButton(context)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    if (isPermissionLimited) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[accessLimitedBottomTip(context), child],
      );
    }
    child = ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: appleOSBlurRadius,
          sigmaY: appleOSBlurRadius,
        ),
        child: child,
      ),
    );
    return child;
  }

  Widget previewButton(BuildContext context) {
    return Consumer<DefaultAssetPickerProvider>(
      builder: (context, DefaultAssetPickerProvider p, __) {
        return Row(
          children: [
            if (p.showOriginalBtn)
              InkWell(
                onTap: () {
                  setState(() {
                    isNativeImage = !isNativeImage;
                  });
                  // onChangingSelected(context, asset, true);
                },
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: !isNativeImage ? Color(0x11000000) : Color(0xffFFCB32),
                          border: isNativeImage ? null : Border.all(width: 1, color: Color(0xffcccccc))),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: !isNativeImage
                            ? SizedBox()
                            : Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 12, right: 16),
                        child: Text(
                          textDelegate.nativeImage,
                          style: TextStyle(fontSize: 14, color: widget.pickerTheme?.textTheme.titleMedium?.color),
                        ))
                  ],
                ),
              ),
            !p.showMergeSend
                ? SizedBox(
                    width: 30,
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isMinxImage = !isMinxImage;
                        });
                        // onChangingSelected(context, asset, true);
                      },
                      child: Row(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                color: !isMinxImage ? Color(0x11000000) : Color(0xffFFCB32),
                                border: isMinxImage ? null : Border.all(width: 1, color: Color(0xffcccccc))),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: !isMinxImage
                                  ? SizedBox()
                                  : Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                textDelegate.minxImage,
                                style: TextStyle(fontSize: 14, color: widget.pickerTheme?.textTheme.titleMedium?.color),
                              ))
                        ],
                      ),
                    ),
                  )
          ],
        );
      },
    );
  }

  Widget confirmButton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, con) {
        return Consumer<DefaultAssetPickerProvider>(
          builder: (_, DefaultAssetPickerProvider p, __) {
            final bool isSelectedNotEmpty = p.isSelectedNotEmpty;

            AssetPickerResultData data =
                AssetPickerResultData(assets: p.selectedAssets, isNativeImage: isNativeImage, isMinxImage: isMinxImage);

            bool hasImage = false;
            int imageNum = 0;
            for (AssetEntity asset in p.selectedAssets) {
              if (asset.type == AssetType.image) {
                hasImage = true;
                imageNum += 1;
              }
            }

            bool hasVideo = false;
            int videoNum = 0;
            for (AssetEntity asset in p.selectedAssets) {
              if (asset.type == AssetType.video) {
                hasVideo = true;
                videoNum += 1;
              }
            }


            bool shouldAllowConfirm =(isSelectedNotEmpty || p.previousSelectedAssets.isNotEmpty);
            var tips ;

            // 合并发送 规则
            if(isMinxImage){
              shouldAllowConfirm =
              !(isMinxImage && hasVideo);
              tips = textDelegate.sendTip;
            }


            //动态发送规则
            if (p.isDynamic) {
              if (hasVideo) {
                if (hasImage) {
                  shouldAllowConfirm = false;
                  tips = textDelegate.sendTip1;
                }else{
                  if(videoNum>1){
                    shouldAllowConfirm = false;
                    tips = textDelegate.sendTip2;
                  }
                }
              }
            }
            return InkWell(
              onTap: shouldAllowConfirm ? () => Navigator.of(context).maybePop(data) : null,
              child: Container(
                // margin: EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: !shouldAllowConfirm
                        ? [widget.theme.dividerColor, widget.theme.dividerColor]
                        : [
                            Color(0xffFFCB32),
                            Color(0xffFB8701),
                          ],
                    // color: widget.theme.colorScheme.secondary,
                  ),
                ),
                width: con.maxWidth - 30,
                // height:48,
                height: appBarItemHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, con) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ScaleText(
                            '${p.confirmText ?? textDelegate.confirm}',
                            // isSelectedNotEmpty && !isSingleAssetMode
                            //     ? '${textDelegate.send}'
                            //         ' (${p.selectedAssets.length}/${p.maxAssets})'
                            //     : textDelegate.send,
                            style: TextStyle(
                              color: shouldAllowConfirm
                                  ? widget.theme.textTheme.bodyLarge?.color
                                  : widget.theme.textTheme.bodySmall?.color,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            semanticsLabel: isSelectedNotEmpty && !isSingleAssetMode
                                ? '${semanticsTextDelegate.confirm}'
                                    ' (${p.selectedAssets.length}/${p.maxAssets})'
                                : semanticsTextDelegate.confirm,
                          ),
                          if(!shouldAllowConfirm &&tips!=null)SizedBox(
                            width: con.maxWidth - 10,
                            child: Text(
                              tips,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: shouldAllowConfirm
                                      ? widget.theme.textTheme.bodyLarge?.color?.withOpacity(0.6)
                                      : widget.theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget audioItemBuilder(BuildContext context, int index, AssetEntity asset) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          alignment: AlignmentDirectional.topStart,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: <Color>[widget.theme.dividerColor, Colors.transparent],
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 30),
            child: ScaleText(
              asset.title ?? '',
              style: const TextStyle(fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Align(
          alignment: AlignmentDirectional(0.9, 0.8),
          child: Icon(Icons.audiotrack),
        ),
        audioIndicator(context, asset),
      ],
    );
  }

  Widget audioIndicator(BuildContext context, AssetEntity asset) {
    return Container(
      width: double.maxFinite,
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.bottomCenter,
          end: AlignmentDirectional.topCenter,
          colors: <Color>[widget.theme.dividerColor, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 4),
        child: ScaleText(
          textDelegate.durationIndicatorBuilder(
            Duration(seconds: asset.duration),
          ),
          style: const TextStyle(fontSize: 16),
          semanticsLabel: '${semanticsTextDelegate.sNameDurationLabel}: '
              '${semanticsTextDelegate.durationIndicatorBuilder(
            Duration(seconds: asset.duration),
          )}',
        ),
      ),
    );
  }

  Widget selectedBackdrop(BuildContext context, int index, AssetEntity asset) {
    final double indicatorSize = MediaQuery.sizeOf(context).width / widget.gridCount / 3;
    return Positioned.fill(
      child: GestureDetector(
        onTap: isPreviewEnabled ? () => viewAsset(context, index, asset) : null,
        child: Consumer<DefaultAssetPickerProvider>(
          builder: (_, DefaultAssetPickerProvider p, __) {
            final int index = p.selectedAssets.indexOf(asset);
            final bool selected = index != -1;
            return AnimatedContainer(
              duration: widget.switchingPathDuration,
              padding: EdgeInsets.all(indicatorSize * .35),
              color: selected
                  ? widget.theme.colorScheme.primary.withOpacity(.0)
                  : widget.theme.colorScheme.background.withOpacity(.0),
              child: selected && !isSingleAssetMode
                  ? Align(
                      alignment: AlignmentDirectional.topStart,
                      // child: SizedBox(
                      //   height: indicatorSize / 2.5,
                      //   child: FittedBox(
                      //     alignment: AlignmentDirectional.topStart,
                      //     fit: BoxFit.cover,
                      //     child: Text(
                      //       '${index + 1}',
                      //       style: TextStyle(
                      //         color: widget.theme.textTheme.bodyLarge?.color
                      //             ?.withOpacity(.75),
                      //         fontWeight: FontWeight.w600,
                      //         height: 1,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget emptyIndicator(BuildContext context) {
    return ScaleText(
      widget.textDelegate.emptyList,
      maxScaleFactor: 1.5,
      semanticsLabel: widget.semanticsTextDelegate.emptyList,
    );
  }
}

class ShowPickerToast {
  static void show(String msg) {
    SmartDialog.showToast(
      '',
      builder: (_) => PickerToast(msg),
    );
  }
}

class PickerToast extends StatelessWidget {
  const PickerToast(this.msg, {Key? key}) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 20,
            maxWidth: MediaQuery.of(context).size.width - 80,
            maxHeight: 200,
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 100, top: 100),
            // alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
              // 阴影
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Text(
              msg,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              maxLines: 3,
            ),
          ),
        ));
  }
}
