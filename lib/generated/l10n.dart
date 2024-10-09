// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `BeeChat`
  String get appName {
    return Intl.message(
      'BeeChat',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get nickname {
    return Intl.message(
      'Nickname',
      name: 'nickname',
      desc: '',
      args: [],
    );
  }

  /// `Login account`
  String get loginAccount {
    return Intl.message(
      'Login account',
      name: 'loginAccount',
      desc: '',
      args: [],
    );
  }

  /// `The account number is 6-20 English or numbers or @#%.`
  String get loginAccountTip {
    return Intl.message(
      'The account number is 6-20 English or numbers or @#%.',
      name: 'loginAccountTip',
      desc: '',
      args: [],
    );
  }

  /// `The user's nickname is 2-8 digits of Chinese, English, and numbers`
  String get nicknameTip {
    return Intl.message(
      'The user\'s nickname is 2-8 digits of Chinese, English, and numbers',
      name: 'nicknameTip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter user nickname`
  String get inputNickname {
    return Intl.message(
      'Please enter user nickname',
      name: 'inputNickname',
      desc: '',
      args: [],
    );
  }

  /// `Please enter login account`
  String get inputLoginAccount {
    return Intl.message(
      'Please enter login account',
      name: 'inputLoginAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter user nickname`
  String get password {
    return Intl.message(
      'Please enter user nickname',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `The password requires 8-20 digits and consists of numbers and letters`
  String get passwordTip {
    return Intl.message(
      'The password requires 8-20 digits and consists of numbers and letters',
      name: 'passwordTip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the password`
  String get inputPassword {
    return Intl.message(
      'Please enter the password',
      name: 'inputPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the original password`
  String get inputOriginalPassword {
    return Intl.message(
      'Please enter the original password',
      name: 'inputOriginalPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the new password`
  String get inputNewPassword {
    return Intl.message(
      'Please enter the new password',
      name: 'inputNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter confirmation password`
  String get inputConfirmPassword {
    return Intl.message(
      'Please enter confirmation password',
      name: 'inputConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `The confirmation password and password are inconsistent`
  String get confirmPasswordError {
    return Intl.message(
      'The confirmation password and password are inconsistent',
      name: 'confirmPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter invitation code(Optional)`
  String get inputInvitedCode {
    return Intl.message(
      'Please enter invitation code(Optional)',
      name: 'inputInvitedCode',
      desc: '',
      args: [],
    );
  }

  /// `Wrong format of invitation code`
  String get invitedError {
    return Intl.message(
      'Wrong format of invitation code',
      name: 'invitedError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the graphic captcha`
  String get inputCaptcha {
    return Intl.message(
      'Please enter the graphic captcha',
      name: 'inputCaptcha',
      desc: '',
      args: [],
    );
  }

  /// `Next step`
  String get next {
    return Intl.message(
      'Next step',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgetPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account`
  String get haveAccount {
    return Intl.message(
      'Already have an account',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get goLogin {
    return Intl.message(
      'Login',
      name: 'goLogin',
      desc: '',
      args: [],
    );
  }

  /// `No account,`
  String get noAccount {
    return Intl.message(
      'No account,',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `to register>`
  String get goRegister {
    return Intl.message(
      'to register>',
      name: 'goRegister',
      desc: '',
      args: [],
    );
  }

  /// `Bee Chat`
  String get home {
    return Intl.message(
      'Bee Chat',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Market`
  String get market {
    return Intl.message(
      'Market',
      name: 'market',
      desc: '',
      args: [],
    );
  }

  /// `Market`
  String get market1 {
    return Intl.message(
      'Market',
      name: 'market1',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get mine {
    return Intl.message(
      'Mine',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic`
  String get dynamic {
    return Intl.message(
      'Dynamic',
      name: 'dynamic',
      desc: '',
      args: [],
    );
  }

  /// `Square`
  String get square {
    return Intl.message(
      'Square',
      name: 'square',
      desc: '',
      args: [],
    );
  }

  /// `Find`
  String get find {
    return Intl.message(
      'Find',
      name: 'find',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic`
  String get mnemonic {
    return Intl.message(
      'Mnemonic',
      name: 'mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Please record the mnemonic words on paper and keep them properly`
  String get mnemonicTip {
    return Intl.message(
      'Please record the mnemonic words on paper and keep them properly',
      name: 'mnemonicTip',
      desc: '',
      args: [],
    );
  }

  /// `Please select the words in the correct order`
  String get mnemonicTip1 {
    return Intl.message(
      'Please select the words in the correct order',
      name: 'mnemonicTip1',
      desc: '',
      args: [],
    );
  }

  /// `Copy to clipboard`
  String get copyToClipboard {
    return Intl.message(
      'Copy to clipboard',
      name: 'copyToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copyToClipboardSuccess {
    return Intl.message(
      'Copied to clipboard',
      name: 'copyToClipboardSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Experience now`
  String get experienceNow {
    return Intl.message(
      'Experience now',
      name: 'experienceNow',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic find account`
  String get mnemonicFindAccount {
    return Intl.message(
      'Mnemonic find account',
      name: 'mnemonicFindAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the mnemonic`
  String get inputMnemonic {
    return Intl.message(
      'Please enter the mnemonic',
      name: 'inputMnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic verification failed`
  String get mnemonicCheckError {
    return Intl.message(
      'Mnemonic verification failed',
      name: 'mnemonicCheckError',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Search username`
  String get searchName {
    return Intl.message(
      'Search username',
      name: 'searchName',
      desc: '',
      args: [],
    );
  }

  /// `Add friends`
  String get addFriend {
    return Intl.message(
      'Add friends',
      name: 'addFriend',
      desc: '',
      args: [],
    );
  }

  /// `BeeChat meeting`
  String get meetingTitle {
    return Intl.message(
      'BeeChat meeting',
      name: 'meetingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get scan {
    return Intl.message(
      'Scan',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Start chatting`
  String get startChat {
    return Intl.message(
      'Start chatting',
      name: 'startChat',
      desc: '',
      args: [],
    );
  }

  /// `Create group chats`
  String get createGroupChat {
    return Intl.message(
      'Create group chats',
      name: 'createGroupChat',
      desc: '',
      args: [],
    );
  }

  /// `Search group chats`
  String get searchGroupChat {
    return Intl.message(
      'Search group chats',
      name: 'searchGroupChat',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// ` online`
  String get presentNumOnline {
    return Intl.message(
      ' online',
      name: 'presentNumOnline',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `Group chat`
  String get groupChat {
    return Intl.message(
      'Group chat',
      name: 'groupChat',
      desc: '',
      args: [],
    );
  }

  /// `Jump to unread`
  String get jumpToUnread {
    return Intl.message(
      'Jump to unread',
      name: 'jumpToUnread',
      desc: '',
      args: [],
    );
  }

  /// `Select contact`
  String get chooseContact {
    return Intl.message(
      'Select contact',
      name: 'chooseContact',
      desc: '',
      args: [],
    );
  }

  /// `Group info`
  String get groupInfo {
    return Intl.message(
      'Group info',
      name: 'groupInfo',
      desc: '',
      args: [],
    );
  }

  /// `Group introduction`
  String get groupIntroduction {
    return Intl.message(
      'Group introduction',
      name: 'groupIntroduction',
      desc: '',
      args: [],
    );
  }

  /// `No introduction...`
  String get noIntroduction {
    return Intl.message(
      'No introduction...',
      name: 'noIntroduction',
      desc: '',
      args: [],
    );
  }

  /// `Group members`
  String get groupMember {
    return Intl.message(
      'Group members',
      name: 'groupMember',
      desc: '',
      args: [],
    );
  }

  /// `group members`
  String get groupMember1 {
    return Intl.message(
      'group members',
      name: 'groupMember1',
      desc: '',
      args: [],
    );
  }

  /// `Look`
  String get look {
    return Intl.message(
      'Look',
      name: 'look',
      desc: '',
      args: [],
    );
  }

  /// `Invited`
  String get invited {
    return Intl.message(
      'Invited',
      name: 'invited',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Quit`
  String get exit {
    return Intl.message(
      'Quit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Quit Group chats`
  String get exitGroup {
    return Intl.message(
      'Quit Group chats',
      name: 'exitGroup',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to quit group`
  String get exitGroupTip {
    return Intl.message(
      'Are you sure you want to quit group',
      name: 'exitGroupTip',
      desc: '',
      args: [],
    );
  }

  /// `top`
  String get setTop {
    return Intl.message(
      'top',
      name: 'setTop',
      desc: '',
      args: [],
    );
  }

  /// `set-top`
  String get setTop1 {
    return Intl.message(
      'set-top',
      name: 'setTop1',
      desc: '',
      args: [],
    );
  }

  /// `Cancel top`
  String get cancelTop {
    return Intl.message(
      'Cancel top',
      name: 'cancelTop',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Members of group`
  String get groupInMember {
    return Intl.message(
      'Members of group',
      name: 'groupInMember',
      desc: '',
      args: [],
    );
  }

  /// `Chat conversion`
  String get chatConversion {
    return Intl.message(
      'Chat conversion',
      name: 'chatConversion',
      desc: '',
      args: [],
    );
  }

  /// `Group name`
  String get groupName {
    return Intl.message(
      'Group name',
      name: 'groupName',
      desc: '',
      args: [],
    );
  }

  /// `My Group nickname`
  String get myGroupName {
    return Intl.message(
      'My Group nickname',
      name: 'myGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Not set`
  String get notSet {
    return Intl.message(
      'Not set',
      name: 'notSet',
      desc: '',
      args: [],
    );
  }

  /// `Modification failed`
  String get changeFail {
    return Intl.message(
      'Modification failed',
      name: 'changeFail',
      desc: '',
      args: [],
    );
  }

  /// `Modification successful`
  String get changeSuccess {
    return Intl.message(
      'Modification successful',
      name: 'changeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Share group`
  String get shareGroup {
    return Intl.message(
      'Share group',
      name: 'shareGroup',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the group name `
  String get inputGroupName {
    return Intl.message(
      'Please enter the group name ',
      name: 'inputGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter my nickname for group`
  String get inputMyGroupName {
    return Intl.message(
      'Please enter my nickname for group',
      name: 'inputMyGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the group introduction`
  String get inputGroupIntroduction {
    return Intl.message(
      'Please enter the group introduction',
      name: 'inputGroupIntroduction',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get follow {
    return Intl.message(
      'Follow',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `Followed`
  String get followed {
    return Intl.message(
      'Followed',
      name: 'followed',
      desc: '',
      args: [],
    );
  }

  /// `Hot`
  String get hotDynamic {
    return Intl.message(
      'Hot',
      name: 'hotDynamic',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Hot`
  String get hot {
    return Intl.message(
      'Hot',
      name: 'hot',
      desc: '',
      args: [],
    );
  }

  /// `Fall list`
  String get fallList {
    return Intl.message(
      'Fall list',
      name: 'fallList',
      desc: '',
      args: [],
    );
  }

  /// `Rise list`
  String get riseList {
    return Intl.message(
      'Rise list',
      name: 'riseList',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get sortName {
    return Intl.message(
      'Name',
      name: 'sortName',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get sortPrice {
    return Intl.message(
      'Price',
      name: 'sortPrice',
      desc: '',
      args: [],
    );
  }

  /// `24H Volume`
  String get sort24HVolume {
    return Intl.message(
      '24H Volume',
      name: 'sort24HVolume',
      desc: '',
      args: [],
    );
  }

  /// `24H Fall`
  String get sort24HFall {
    return Intl.message(
      '24H Fall',
      name: 'sort24HFall',
      desc: '',
      args: [],
    );
  }

  /// `24H Rise`
  String get sort24HRise {
    return Intl.message(
      '24H Rise',
      name: 'sort24HRise',
      desc: '',
      args: [],
    );
  }

  /// `Recommend APP`
  String get recommendAPP {
    return Intl.message(
      'Recommend APP',
      name: 'recommendAPP',
      desc: '',
      args: [],
    );
  }

  /// `Hot APP`
  String get hotAPP {
    return Intl.message(
      'Hot APP',
      name: 'hotAPP',
      desc: '',
      args: [],
    );
  }

  /// `Collection`
  String get collection {
    return Intl.message(
      'Collection',
      name: 'collection',
      desc: '',
      args: [],
    );
  }

  /// `New versions`
  String get findNewVersion {
    return Intl.message(
      'New versions',
      name: 'findNewVersion',
      desc: '',
      args: [],
    );
  }

  /// `Version update:`
  String get versionUpdate {
    return Intl.message(
      'Version update:',
      name: 'versionUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Updated now`
  String get nowUpdate {
    return Intl.message(
      'Updated now',
      name: 'nowUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Fans`
  String get fans {
    return Intl.message(
      'Fans',
      name: 'fans',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get sendMessage {
    return Intl.message(
      'Chat',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get callVideo {
    return Intl.message(
      'Call',
      name: 'callVideo',
      desc: '',
      args: [],
    );
  }

  /// `+Friend`
  String get addFriend1 {
    return Intl.message(
      '+Friend',
      name: 'addFriend1',
      desc: '',
      args: [],
    );
  }

  /// `IM is not login, please login again`
  String get imNotLogin {
    return Intl.message(
      'IM is not login, please login again',
      name: 'imNotLogin',
      desc: '',
      args: [],
    );
  }

  /// `File path error`
  String get filePathError {
    return Intl.message(
      'File path error',
      name: 'filePathError',
      desc: '',
      args: [],
    );
  }

  /// `Upload signature error`
  String get uploadSignError {
    return Intl.message(
      'Upload signature error',
      name: 'uploadSignError',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed`
  String get uploadError {
    return Intl.message(
      'Upload failed',
      name: 'uploadError',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded successfully`
  String get uploadSuccess {
    return Intl.message(
      'Uploaded successfully',
      name: 'uploadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Fill in a clear group name`
  String get inputGroupName1 {
    return Intl.message(
      'Fill in a clear group name',
      name: 'inputGroupName1',
      desc: '',
      args: [],
    );
  }

  /// `Describe the highlights, content, suitable people, and theme of the Group chats. Ask everyone to participate together`
  String get groupNameHintText {
    return Intl.message(
      'Describe the highlights, content, suitable people, and theme of the Group chats. Ask everyone to participate together',
      name: 'groupNameHintText',
      desc: '',
      args: [],
    );
  }

  /// `Join confirmation`
  String get groupJoinConfirmation {
    return Intl.message(
      'Join confirmation',
      name: 'groupJoinConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `After confirmation is enabled, joining users need to be confirmed by the administrator`
  String get groupJoinConfirmationTip {
    return Intl.message(
      'After confirmation is enabled, joining users need to be confirmed by the administrator',
      name: 'groupJoinConfirmationTip',
      desc: '',
      args: [],
    );
  }

  /// `Group chats private`
  String get groupPrivate {
    return Intl.message(
      'Group chats private',
      name: 'groupPrivate',
      desc: '',
      args: [],
    );
  }

  /// `After turning on privacy, it cannot be searched. and can only be invited by the administrator`
  String get groupPrivateTip {
    return Intl.message(
      'After turning on privacy, it cannot be searched. and can only be invited by the administrator',
      name: 'groupPrivateTip',
      desc: '',
      args: [],
    );
  }

  /// `Cut`
  String get cutting {
    return Intl.message(
      'Cut',
      name: 'cutting',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get album {
    return Intl.message(
      'Album',
      name: 'album',
      desc: '',
      args: [],
    );
  }

  /// `Please select a group avatar`
  String get selectGroupAvatar {
    return Intl.message(
      'Please select a group avatar',
      name: 'selectGroupAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create Group`
  String get createGroupFail {
    return Intl.message(
      'Failed to create Group',
      name: 'createGroupFail',
      desc: '',
      args: [],
    );
  }

  /// `Success to create Group`
  String get createGroupSuccess {
    return Intl.message(
      'Success to create Group',
      name: 'createGroupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join {
    return Intl.message(
      'Join',
      name: 'join',
      desc: '',
      args: [],
    );
  }

  /// `The request to join Group chats was sent successfully`
  String get sendJoinSuccess {
    return Intl.message(
      'The request to join Group chats was sent successfully',
      name: 'sendJoinSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send request to join Group chats`
  String get sendJoinFail {
    return Intl.message(
      'Failed to send request to join Group chats',
      name: 'sendJoinFail',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get groupLeader {
    return Intl.message(
      'Owner',
      name: 'groupLeader',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get groupAdmin {
    return Intl.message(
      'Admin',
      name: 'groupAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Remove group members`
  String get removeGroupMember {
    return Intl.message(
      'Remove group members',
      name: 'removeGroupMember',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove the selected group members?`
  String get removeGroupMemberTip {
    return Intl.message(
      'Are you sure you want to remove the selected group members?',
      name: 'removeGroupMemberTip',
      desc: '',
      args: [],
    );
  }

  /// `Remove group members successfully`
  String get removeGroupMemberSuccess {
    return Intl.message(
      'Remove group members successfully',
      name: 'removeGroupMemberSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to remove group members`
  String get removeGroupMemberFail {
    return Intl.message(
      'Failed to remove group members',
      name: 'removeGroupMemberFail',
      desc: '',
      args: [],
    );
  }

  /// `Invite new members`
  String get invitedNewMember {
    return Intl.message(
      'Invite new members',
      name: 'invitedNewMember',
      desc: '',
      args: [],
    );
  }

  /// `Invitation failed`
  String get invitedFail {
    return Intl.message(
      'Invitation failed',
      name: 'invitedFail',
      desc: '',
      args: [],
    );
  }

  /// `Invitation successful`
  String get invitedSuccess {
    return Intl.message(
      'Invitation successful',
      name: 'invitedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get downloading {
    return Intl.message(
      'Downloading...',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `download is complete`
  String get downloadCompleted {
    return Intl.message(
      'download is complete',
      name: 'downloadCompleted',
      desc: '',
      args: [],
    );
  }

  /// `assets`
  String get assets {
    return Intl.message(
      'assets',
      name: 'assets',
      desc: '',
      args: [],
    );
  }

  /// `Custody Wallet`
  String get custodyWallet {
    return Intl.message(
      'Custody Wallet',
      name: 'custodyWallet',
      desc: '',
      args: [],
    );
  }

  /// `WEB3 Wallet`
  String get web3Wallet {
    return Intl.message(
      'WEB3 Wallet',
      name: 'web3Wallet',
      desc: '',
      args: [],
    );
  }

  /// `Total Balance`
  String get totalBalance {
    return Intl.message(
      'Total Balance',
      name: 'totalBalance',
      desc: '',
      args: [],
    );
  }

  /// `Recharge`
  String get recharge {
    return Intl.message(
      'Recharge',
      name: 'recharge',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal`
  String get withdrawal {
    return Intl.message(
      'Withdrawal',
      name: 'withdrawal',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message(
      'Transfer',
      name: 'transfer',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Not Display`
  String get notShow {
    return Intl.message(
      'Not Display',
      name: 'notShow',
      desc: '',
      args: [],
    );
  }

  /// `System message`
  String get systemMsg {
    return Intl.message(
      'System message',
      name: 'systemMsg',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get notice {
    return Intl.message(
      'Notice',
      name: 'notice',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Request notice`
  String get requestNotice {
    return Intl.message(
      'Request notice',
      name: 'requestNotice',
      desc: '',
      args: [],
    );
  }

  /// `click & look`
  String get clickLook {
    return Intl.message(
      'click & look',
      name: 'clickLook',
      desc: '',
      args: [],
    );
  }

  /// `apply to join Group chats`
  String get applyJoinGroup {
    return Intl.message(
      'apply to join Group chats',
      name: 'applyJoinGroup',
      desc: '',
      args: [],
    );
  }

  /// `apply to add friends`
  String get applyAddFriend {
    return Intl.message(
      'apply to add friends',
      name: 'applyAddFriend',
      desc: '',
      args: [],
    );
  }

  /// `Agreed`
  String get agree {
    return Intl.message(
      'Agreed',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `Refuse`
  String get refuse {
    return Intl.message(
      'Refuse',
      name: 'refuse',
      desc: '',
      args: [],
    );
  }

  /// `Agreed`
  String get agreed {
    return Intl.message(
      'Agreed',
      name: 'agreed',
      desc: '',
      args: [],
    );
  }

  /// `Refused`
  String get refused {
    return Intl.message(
      'Refused',
      name: 'refused',
      desc: '',
      args: [],
    );
  }

  /// `apply to join Group`
  String get applyJoinGroupTip {
    return Intl.message(
      'apply to join Group',
      name: 'applyJoinGroupTip',
      desc: '',
      args: [],
    );
  }

  /// `Group Requisition`
  String get applyJoinGroupTitle {
    return Intl.message(
      'Group Requisition',
      name: 'applyJoinGroupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Group ID`
  String get groupNum {
    return Intl.message(
      'Group ID',
      name: 'groupNum',
      desc: '',
      args: [],
    );
  }

  /// `Scan the QR code and join Group`
  String get groupShareTip {
    return Intl.message(
      'Scan the QR code and join Group',
      name: 'groupShareTip',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get saved {
    return Intl.message(
      'Saved',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `Saved to album`
  String get savedToAlbum {
    return Intl.message(
      'Saved to album',
      name: 'savedToAlbum',
      desc: '',
      args: [],
    );
  }

  /// `Save failed`
  String get saveFail {
    return Intl.message(
      'Save failed',
      name: 'saveFail',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Edit Assets`
  String get editAssets {
    return Intl.message(
      'Edit Assets',
      name: 'editAssets',
      desc: '',
      args: [],
    );
  }

  /// `Coin Pair`
  String get coinPair {
    return Intl.message(
      'Coin Pair',
      name: 'coinPair',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get selectAll {
    return Intl.message(
      'Select All',
      name: 'selectAll',
      desc: '',
      args: [],
    );
  }

  /// `Asset Records`
  String get assetsRecord {
    return Intl.message(
      'Asset Records',
      name: 'assetsRecord',
      desc: '',
      args: [],
    );
  }

  /// `Recharge Record`
  String get rechargeRecord {
    return Intl.message(
      'Recharge Record',
      name: 'rechargeRecord',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Record`
  String get withdrawalRecord {
    return Intl.message(
      'Withdrawal Record',
      name: 'withdrawalRecord',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Record`
  String get transferRecord {
    return Intl.message(
      'Transfer Record',
      name: 'transferRecord',
      desc: '',
      args: [],
    );
  }

  /// `Activity Record`
  String get activityRecord {
    return Intl.message(
      'Activity Record',
      name: 'activityRecord',
      desc: '',
      args: [],
    );
  }

  /// `Red Envelope`
  String get redEnvelope {
    return Intl.message(
      'Red Envelope',
      name: 'redEnvelope',
      desc: '',
      args: [],
    );
  }

  /// `Reward`
  String get reward {
    return Intl.message(
      'Reward',
      name: 'reward',
      desc: '',
      args: [],
    );
  }

  /// `Invitation`
  String get invitation {
    return Intl.message(
      'Invitation',
      name: 'invitation',
      desc: '',
      args: [],
    );
  }

  /// `New User Registration`
  String get newUserRegistration {
    return Intl.message(
      'New User Registration',
      name: 'newUserRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Registration Rewards`
  String get registrationRewards {
    return Intl.message(
      'Registration Rewards',
      name: 'registrationRewards',
      desc: '',
      args: [],
    );
  }

  /// `Invite New Users`
  String get inviteNewUsers {
    return Intl.message(
      'Invite New Users',
      name: 'inviteNewUsers',
      desc: '',
      args: [],
    );
  }

  /// `Invitation Rewards`
  String get invitationRewards {
    return Intl.message(
      'Invitation Rewards',
      name: 'invitationRewards',
      desc: '',
      args: [],
    );
  }

  /// `Invited Users`
  String get invitedUsers {
    return Intl.message(
      'Invited Users',
      name: 'invitedUsers',
      desc: '',
      args: [],
    );
  }

  /// `Set`
  String get setting {
    return Intl.message(
      'Set',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Remarks`
  String get remarks {
    return Intl.message(
      'Remarks',
      name: 'remarks',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a comment`
  String get remarksHintText {
    return Intl.message(
      'Please enter a comment',
      name: 'remarksHintText',
      desc: '',
      args: [],
    );
  }

  /// `Remarks cannot exceed 10`
  String get remarksMoreThan {
    return Intl.message(
      'Remarks cannot exceed 10',
      name: 'remarksMoreThan',
      desc: '',
      args: [],
    );
  }

  /// `Modify remarks`
  String get changeRemark {
    return Intl.message(
      'Modify remarks',
      name: 'changeRemark',
      desc: '',
      args: [],
    );
  }

  /// `Delete friends`
  String get deleteFriend {
    return Intl.message(
      'Delete friends',
      name: 'deleteFriend',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure delete your friends?`
  String get deleteFriendTip {
    return Intl.message(
      'Are you sure delete your friends?',
      name: 'deleteFriendTip',
      desc: '',
      args: [],
    );
  }

  /// `Message not disturb`
  String get messageNotDisturb {
    return Intl.message(
      'Message not disturb',
      name: 'messageNotDisturb',
      desc: '',
      args: [],
    );
  }

  /// `Observe Wallet`
  String get observeWallet {
    return Intl.message(
      'Observe Wallet',
      name: 'observeWallet',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Collection`
  String get collectionPayments {
    return Intl.message(
      'Collection',
      name: 'collectionPayments',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Introduced`
  String get introduced {
    return Intl.message(
      'Introduced',
      name: 'introduced',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get goOpen {
    return Intl.message(
      'Open',
      name: 'goOpen',
      desc: '',
      args: [],
    );
  }

  /// `VIP`
  String get vip {
    return Intl.message(
      'VIP',
      name: 'vip',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy 8 benefits when opening`
  String get vipTip {
    return Intl.message(
      'Enjoy 8 benefits when opening',
      name: 'vipTip',
      desc: '',
      args: [],
    );
  }

  /// `Praise`
  String get praise {
    return Intl.message(
      'Praise',
      name: 'praise',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get lookHistory {
    return Intl.message(
      'History',
      name: 'lookHistory',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draftBox {
    return Intl.message(
      'Draft',
      name: 'draftBox',
      desc: '',
      args: [],
    );
  }

  /// `AD center`
  String get advertisingCenter {
    return Intl.message(
      'AD center',
      name: 'advertisingCenter',
      desc: '',
      args: [],
    );
  }

  /// `User info`
  String get userInfo {
    return Intl.message(
      'User info',
      name: 'userInfo',
      desc: '',
      args: [],
    );
  }

  /// `Please enter 2-16 digit nickname`
  String get inputNickname1 {
    return Intl.message(
      'Please enter 2-16 digit nickname',
      name: 'inputNickname1',
      desc: '',
      args: [],
    );
  }

  /// `Introduction cannot be more than 100 characters`
  String get introductionMoreThan {
    return Intl.message(
      'Introduction cannot be more than 100 characters',
      name: 'introductionMoreThan',
      desc: '',
      args: [],
    );
  }

  /// `System Settings`
  String get systemSettings {
    return Intl.message(
      'System Settings',
      name: 'systemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Chat Settings`
  String get chatSettings {
    return Intl.message(
      'Chat Settings',
      name: 'chatSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Security And Binding`
  String get securityBinding {
    return Intl.message(
      'Security And Binding',
      name: 'securityBinding',
      desc: '',
      args: [],
    );
  }

  /// `New Message Notification Settings`
  String get notificationSettings {
    return Intl.message(
      'New Message Notification Settings',
      name: 'notificationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Latest Version`
  String get lastVersion {
    return Intl.message(
      'Latest Version',
      name: 'lastVersion',
      desc: '',
      args: [],
    );
  }

  /// `Log Out Of Account`
  String get logOutAccount {
    return Intl.message(
      'Log Out Of Account',
      name: 'logOutAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message(
      'Log Out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutTips {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutTips',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get inviteFriends {
    return Intl.message(
      'Invite',
      name: 'inviteFriends',
      desc: '',
      args: [],
    );
  }

  /// `Join The World Of BeeChat Together!`
  String get joinTogether {
    return Intl.message(
      'Join The World Of BeeChat Together!',
      name: 'joinTogether',
      desc: '',
      args: [],
    );
  }

  /// `Copied To Clipboard Successfully`
  String get copiedClipboardSuccessfully {
    return Intl.message(
      'Copied To Clipboard Successfully',
      name: 'copiedClipboardSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Save To Album Successfully`
  String get saveAlbumSuccessfully {
    return Intl.message(
      'Save To Album Successfully',
      name: 'saveAlbumSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR Code`
  String get scanQRCode {
    return Intl.message(
      'Scan QR Code',
      name: 'scanQRCode',
      desc: '',
      args: [],
    );
  }

  /// `My Invitation Code`
  String get myInvitationCode {
    return Intl.message(
      'My Invitation Code',
      name: 'myInvitationCode',
      desc: '',
      args: [],
    );
  }

  /// `Disband Group`
  String get disbandGroup {
    return Intl.message(
      'Disband Group',
      name: 'disbandGroup',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to disband your Group?`
  String get disbandGroupTip {
    return Intl.message(
      'Are you sure to disband your Group?',
      name: 'disbandGroupTip',
      desc: '',
      args: [],
    );
  }

  /// `Join Group`
  String get joinGroup {
    return Intl.message(
      'Join Group',
      name: 'joinGroup',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to join Group?`
  String get joinGroupTip {
    return Intl.message(
      'Confirm to join Group?',
      name: 'joinGroupTip',
      desc: '',
      args: [],
    );
  }

  /// `Please look forward to`
  String get lookForward {
    return Intl.message(
      'Please look forward to',
      name: 'lookForward',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the account`
  String get accountTip {
    return Intl.message(
      'Please enter the account',
      name: 'accountTip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the account`
  String get userAccountHintText {
    return Intl.message(
      'Please enter the account',
      name: 'userAccountHintText',
      desc: '',
      args: [],
    );
  }

  /// `Prompt`
  String get prompt {
    return Intl.message(
      'Prompt',
      name: 'prompt',
      desc: '',
      args: [],
    );
  }

  /// `The account is logged in elsewhere`
  String get accountLogged {
    return Intl.message(
      'The account is logged in elsewhere',
      name: 'accountLogged',
      desc: '',
      args: [],
    );
  }

  /// `Choose Currency`
  String get selectCoin {
    return Intl.message(
      'Choose Currency',
      name: 'selectCoin',
      desc: '',
      args: [],
    );
  }

  /// `Crypto Currency`
  String get passCoin {
    return Intl.message(
      'Crypto Currency',
      name: 'passCoin',
      desc: '',
      args: [],
    );
  }

  /// `please choose`
  String get pleaseSelect {
    return Intl.message(
      'please choose',
      name: 'pleaseSelect',
      desc: '',
      args: [],
    );
  }

  /// `Scan to recharge`
  String get scanRecharge {
    return Intl.message(
      'Scan to recharge',
      name: 'scanRecharge',
      desc: '',
      args: [],
    );
  }

  /// `Copy deposit address`
  String get copyRechargeAddress {
    return Intl.message(
      'Copy deposit address',
      name: 'copyRechargeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Currency`
  String get withdrawalCoinType {
    return Intl.message(
      'Withdrawal Currency',
      name: 'withdrawalCoinType',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Address`
  String get withdrawalAddress {
    return Intl.message(
      'Withdrawal Address',
      name: 'withdrawalAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter`
  String get pleasesInputWithdrawalAddress {
    return Intl.message(
      'Please Enter',
      name: 'pleasesInputWithdrawalAddress',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Amount`
  String get withdrawalNum {
    return Intl.message(
      'Withdrawal Amount',
      name: 'withdrawalNum',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get canWithdrawalNum {
    return Intl.message(
      'Available',
      name: 'canWithdrawalNum',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Range`
  String get withdrawalRange {
    return Intl.message(
      'Withdrawal Range',
      name: 'withdrawalRange',
      desc: '',
      args: [],
    );
  }

  /// `Actual Receipt`
  String get realNum {
    return Intl.message(
      'Actual Receipt',
      name: 'realNum',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Fee`
  String get withdrawalFee {
    return Intl.message(
      'Withdrawal Fee',
      name: 'withdrawalFee',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Withdrawal`
  String get confirmWithdrawal {
    return Intl.message(
      'Confirm Withdrawal',
      name: 'confirmWithdrawal',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient Balance`
  String get insufficientBalance {
    return Intl.message(
      'Insufficient Balance',
      name: 'insufficientBalance',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Success`
  String get withdrawalSuccess {
    return Intl.message(
      'Withdrawal Success',
      name: 'withdrawalSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Success`
  String get transferSuccess {
    return Intl.message(
      'Transfer Success',
      name: 'transferSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Verification Failed`
  String get verificationFailed {
    return Intl.message(
      'Verification Failed',
      name: 'verificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Google Verification Code`
  String get pleaseEnterGoogleCode {
    return Intl.message(
      'Please Enter Google Verification Code',
      name: 'pleaseEnterGoogleCode',
      desc: '',
      args: [],
    );
  }

  /// `Receiving Account`
  String get receivingAccount {
    return Intl.message(
      'Receiving Account',
      name: 'receivingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Currency`
  String get transferCurrency {
    return Intl.message(
      'Transfer Currency',
      name: 'transferCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Amount`
  String get transferNum {
    return Intl.message(
      'Transfer Amount',
      name: 'transferNum',
      desc: '',
      args: [],
    );
  }

  /// `transfer Fee`
  String get transferFee {
    return Intl.message(
      'transfer Fee',
      name: 'transferFee',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Transfer`
  String get confirmTransfer {
    return Intl.message(
      'Confirm Transfer',
      name: 'confirmTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Transferable`
  String get transferable {
    return Intl.message(
      'Transferable',
      name: 'transferable',
      desc: '',
      args: [],
    );
  }

  /// `Select Receiving Account`
  String get selectReceivingAccount {
    return Intl.message(
      'Select Receiving Account',
      name: 'selectReceivingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Search User Nickname Or User ID`
  String get searchNicknameID {
    return Intl.message(
      'Search User Nickname Or User ID',
      name: 'searchNicknameID',
      desc: '',
      args: [],
    );
  }

  /// `User Nickname`
  String get userNickname {
    return Intl.message(
      'User Nickname',
      name: 'userNickname',
      desc: '',
      args: [],
    );
  }

  /// `Known Users`
  String get knownUsers {
    return Intl.message(
      'Known Users',
      name: 'knownUsers',
      desc: '',
      args: [],
    );
  }

  /// `温馨提示`
  String get KindTips {
    return Intl.message(
      '温馨提示',
      name: 'KindTips',
      desc: '',
      args: [],
    );
  }

  /// `Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n①The platform only supports BEP-20 type blockchain digital currency collection. To ensure your recharge is smooth, please check the selected channel before transferring and ensure that your transfer type is correct. We will not be responsible for the situation of transferring the wrong type.\n②To avoid loss of money, please do not save the payment address. The wrong address will cause your recharge to fail to arrive.\n③In order to avoid differences in text understanding, our company reserves the right of final interpretation.\n④If you have any questions, please submit a work order to contact customer service, and we will help you as soon as possible.`
  String get KindTipsRecharge {
    return Intl.message(
      'Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n①The platform only supports BEP-20 type blockchain digital currency collection. To ensure your recharge is smooth, please check the selected channel before transferring and ensure that your transfer type is correct. We will not be responsible for the situation of transferring the wrong type.\n②To avoid loss of money, please do not save the payment address. The wrong address will cause your recharge to fail to arrive.\n③In order to avoid differences in text understanding, our company reserves the right of final interpretation.\n④If you have any questions, please submit a work order to contact customer service, and we will help you as soon as possible.',
      name: 'KindTipsRecharge',
      desc: '',
      args: [],
    );
  }

  /// `Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n① The withdrawal application platform charges a handling fee commission: BECP-BEP20 of 1% of the withdrawal amount.\n② Please provide the correct wallet payment address information. If the loss is caused by the incorrect wallet address provided, our company will not be responsible.\n③ Due to the factors of the on-chain network and processing speed, the withdrawal time may vary. Please wait patiently.\n④ In order to avoid differences in text understanding, our company reserves the right of final interpretation.\n⑤ If you have any questions, please submit a work order to contact`
  String get KindTipsWithdrawal {
    return Intl.message(
      'Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n① The withdrawal application platform charges a handling fee commission: BECP-BEP20 of 1% of the withdrawal amount.\n② Please provide the correct wallet payment address information. If the loss is caused by the incorrect wallet address provided, our company will not be responsible.\n③ Due to the factors of the on-chain network and processing speed, the withdrawal time may vary. Please wait patiently.\n④ In order to avoid differences in text understanding, our company reserves the right of final interpretation.\n⑤ If you have any questions, please submit a work order to contact',
      name: 'KindTipsWithdrawal',
      desc: '',
      args: [],
    );
  }

  /// `Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n① The transfer application platform charges a commission fee: BECP-BEP20, which is 1% of the withdrawal amount.\n② The transfer operation is irreversible. Once the operation is performed, our company will not be responsible. Please operate with caution.\n③ In order to avoid differences in text understanding, our company reserves the right of final interpretation.`
  String get KindTipsTransfer {
    return Intl.message(
      'Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n① The transfer application platform charges a commission fee: BECP-BEP20, which is 1% of the withdrawal amount.\n② The transfer operation is irreversible. Once the operation is performed, our company will not be responsible. Please operate with caution.\n③ In order to avoid differences in text understanding, our company reserves the right of final interpretation.',
      name: 'KindTipsTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Invitation Record`
  String get invitationRecord {
    return Intl.message(
      'Invitation Record',
      name: 'invitationRecord',
      desc: '',
      args: [],
    );
  }

  /// `Select members`
  String get chooseMember {
    return Intl.message(
      'Select members',
      name: 'chooseMember',
      desc: '',
      args: [],
    );
  }

  /// `Selected quantity cannot be greater than`
  String get maxNumTip {
    return Intl.message(
      'Selected quantity cannot be greater than',
      name: 'maxNumTip',
      desc: '',
      args: [],
    );
  }

  /// `Invitation Time`
  String get invitationTime {
    return Intl.message(
      'Invitation Time',
      name: 'invitationTime',
      desc: '',
      args: [],
    );
  }

  /// `Recharge Amount`
  String get rechargeAmount {
    return Intl.message(
      'Recharge Amount',
      name: 'rechargeAmount',
      desc: '',
      args: [],
    );
  }

  /// `Amount Received`
  String get amountReceived {
    return Intl.message(
      'Amount Received',
      name: 'amountReceived',
      desc: '',
      args: [],
    );
  }

  /// `Total Paid`
  String get totalPaid {
    return Intl.message(
      'Total Paid',
      name: 'totalPaid',
      desc: '',
      args: [],
    );
  }

  /// `Recharge`
  String get rechargeAgain {
    return Intl.message(
      'Recharge',
      name: 'rechargeAgain',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed2 {
    return Intl.message(
      'Completed',
      name: 'completed2',
      desc: '',
      args: [],
    );
  }

  /// `IN Review`
  String get waitingForReview {
    return Intl.message(
      'IN Review',
      name: 'waitingForReview',
      desc: '',
      args: [],
    );
  }

  /// `Confirming`
  String get waitingForConfirmation {
    return Intl.message(
      'Confirming',
      name: 'waitingForConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get withdrawalFailed {
    return Intl.message(
      'Failed',
      name: 'withdrawalFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get transferFailed {
    return Intl.message(
      'Failed',
      name: 'transferFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get rechargeFailed {
    return Intl.message(
      'Failed',
      name: 'rechargeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get withdrawalAmount {
    return Intl.message(
      'Amount',
      name: 'withdrawalAmount',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get withdrawalTo {
    return Intl.message(
      'To',
      name: 'withdrawalTo',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get actualReceived {
    return Intl.message(
      'Received',
      name: 'actualReceived',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdrawAgain {
    return Intl.message(
      'Withdraw',
      name: 'withdrawAgain',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get transferAmount {
    return Intl.message(
      'Amount',
      name: 'transferAmount',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get transferTo {
    return Intl.message(
      'To',
      name: 'transferTo',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transferAgain {
    return Intl.message(
      'Transfer',
      name: 'transferAgain',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get withdrawalFee2 {
    return Intl.message(
      'Fee',
      name: 'withdrawalFee2',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get transferFee2 {
    return Intl.message(
      'Fee',
      name: 'transferFee2',
      desc: '',
      args: [],
    );
  }

  /// `Group Chat Settings`
  String get groupSettings {
    return Intl.message(
      'Group Chat Settings',
      name: 'groupSettings',
      desc: '',
      args: [],
    );
  }

  /// `Automatically Accept Group Invitations`
  String get autoAcceptGroup {
    return Intl.message(
      'Automatically Accept Group Invitations',
      name: 'autoAcceptGroup',
      desc: '',
      args: [],
    );
  }

  /// `Delete Replies & Records When Exiting Group`
  String get exitingDelete {
    return Intl.message(
      'Delete Replies & Records When Exiting Group',
      name: 'exitingDelete',
      desc: '',
      args: [],
    );
  }

  /// `Google Authenticator`
  String get googleAuthenticator {
    return Intl.message(
      'Google Authenticator',
      name: 'googleAuthenticator',
      desc: '',
      args: [],
    );
  }

  /// `Go To Bind`
  String get goBind {
    return Intl.message(
      'Go To Bind',
      name: 'goBind',
      desc: '',
      args: [],
    );
  }

  /// `DownloadNow`
  String get downloadNow {
    return Intl.message(
      'DownloadNow',
      name: 'downloadNow',
      desc: '',
      args: [],
    );
  }

  /// `Bind Google Authenticator`
  String get bindGoogleAuthenticator {
    return Intl.message(
      'Bind Google Authenticator',
      name: 'bindGoogleAuthenticator',
      desc: '',
      args: [],
    );
  }

  /// `Please use Google Authenticator to scan the following QR code to get the verification code to complete the binding`
  String get bindGoogleAuthenticatorTip {
    return Intl.message(
      'Please use Google Authenticator to scan the following QR code to get the verification code to complete the binding',
      name: 'bindGoogleAuthenticatorTip',
      desc: '',
      args: [],
    );
  }

  /// `Bind Now`
  String get bindNow {
    return Intl.message(
      'Bind Now',
      name: 'bindNow',
      desc: '',
      args: [],
    );
  }

  /// `After turning it off, system notifications will not display message previews`
  String get noticeTips {
    return Intl.message(
      'After turning it off, system notifications will not display message previews',
      name: 'noticeTips',
      desc: '',
      args: [],
    );
  }

  /// `Notifications Display Message Previews`
  String get notificationsDisplayPreviews {
    return Intl.message(
      'Notifications Display Message Previews',
      name: 'notificationsDisplayPreviews',
      desc: '',
      args: [],
    );
  }

  /// `Sound Reminders`
  String get soundReminders {
    return Intl.message(
      'Sound Reminders',
      name: 'soundReminders',
      desc: '',
      args: [],
    );
  }

  /// `Alert Sounds`
  String get alertSounds {
    return Intl.message(
      'Alert Sounds',
      name: 'alertSounds',
      desc: '',
      args: [],
    );
  }

  /// `Vibration Reminders`
  String get vibrationReminders {
    return Intl.message(
      'Vibration Reminders',
      name: 'vibrationReminders',
      desc: '',
      args: [],
    );
  }

  /// `Message Alert Sounds`
  String get messageAlertSounds {
    return Intl.message(
      'Message Alert Sounds',
      name: 'messageAlertSounds',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get defaultText {
    return Intl.message(
      'Default',
      name: 'defaultText',
      desc: '',
      args: [],
    );
  }

  /// `Sound {index}`
  String notificationSound(Object index) {
    return Intl.message(
      'Sound $index',
      name: 'notificationSound',
      desc: '',
      args: [index],
    );
  }

  /// `Already Bound`
  String get alreadyBound {
    return Intl.message(
      'Already Bound',
      name: 'alreadyBound',
      desc: '',
      args: [],
    );
  }

  /// `Send Red Envelopes`
  String get sendRedBag {
    return Intl.message(
      'Send Red Envelopes',
      name: 'sendRedBag',
      desc: '',
      args: [],
    );
  }

  /// `Red Envelope Records`
  String get redBagRecords {
    return Intl.message(
      'Red Envelope Records',
      name: 'redBagRecords',
      desc: '',
      args: [],
    );
  }

  /// `Red Envelope Type`
  String get redBagType {
    return Intl.message(
      'Red Envelope Type',
      name: 'redBagType',
      desc: '',
      args: [],
    );
  }

  /// `Try Your Luck`
  String get luck {
    return Intl.message(
      'Try Your Luck',
      name: 'luck',
      desc: '',
      args: [],
    );
  }

  /// `Exclusive`
  String get Exclusive {
    return Intl.message(
      'Exclusive',
      name: 'Exclusive',
      desc: '',
      args: [],
    );
  }

  /// `Red Envelope Title`
  String get redBagTitle {
    return Intl.message(
      'Red Envelope Title',
      name: 'redBagTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please input`
  String get redBagTitleTip {
    return Intl.message(
      'Please input',
      name: 'redBagTitleTip',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get coinType {
    return Intl.message(
      'Currency',
      name: 'coinType',
      desc: '',
      args: [],
    );
  }

  /// `Currency Quantity`
  String get coinNum {
    return Intl.message(
      'Currency Quantity',
      name: 'coinNum',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get currentText {
    return Intl.message(
      'Current',
      name: 'currentText',
      desc: '',
      args: [],
    );
  }

  /// `Exclusive Red Envelope`
  String get ExclusiveRedBag {
    return Intl.message(
      'Exclusive Red Envelope',
      name: 'ExclusiveRedBag',
      desc: '',
      args: [],
    );
  }

  /// `Red Envelope Quantity`
  String get redBagNum {
    return Intl.message(
      'Red Envelope Quantity',
      name: 'redBagNum',
      desc: '',
      args: [],
    );
  }

  /// `Chat records`
  String get chatRecord {
    return Intl.message(
      'Chat records',
      name: 'chatRecord',
      desc: '',
      args: [],
    );
  }

  /// `After 24 hours, the unclaimed portion of the token red envelope will be returned`
  String get sendRedBagTip {
    return Intl.message(
      'After 24 hours, the unclaimed portion of the token red envelope will be returned',
      name: 'sendRedBagTip',
      desc: '',
      args: [],
    );
  }

  /// `Currency cannot be less than 0.1`
  String get cannotLess {
    return Intl.message(
      'Currency cannot be less than 0.1',
      name: 'cannotLess',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message(
      'Received',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Issue`
  String get issue {
    return Intl.message(
      'Issue',
      name: 'issue',
      desc: '',
      args: [],
    );
  }

  /// `Accumulated Receipts`
  String get accumulatedReceipts {
    return Intl.message(
      'Accumulated Receipts',
      name: 'accumulatedReceipts',
      desc: '',
      args: [],
    );
  }

  /// `Has been expired`
  String get redEnvelopeTip {
    return Intl.message(
      'Has been expired',
      name: 'redEnvelopeTip',
      desc: '',
      args: [],
    );
  }

  /// `Has been received`
  String get redEnvelopeTip2 {
    return Intl.message(
      'Has been received',
      name: 'redEnvelopeTip2',
      desc: '',
      args: [],
    );
  }

  /// `Have been collected`
  String get redEnvelopeTip3 {
    return Intl.message(
      'Have been collected',
      name: 'redEnvelopeTip3',
      desc: '',
      args: [],
    );
  }

  /// `May fortune be with you`
  String get redEnvelopeTitle {
    return Intl.message(
      'May fortune be with you',
      name: 'redEnvelopeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Accumulated Issuance`
  String get accumulatedIssuance {
    return Intl.message(
      'Accumulated Issuance',
      name: 'accumulatedIssuance',
      desc: '',
      args: [],
    );
  }

  /// `Have A Good One`
  String get moneyMuch {
    return Intl.message(
      'Have A Good One',
      name: 'moneyMuch',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get alreadyGet {
    return Intl.message(
      'Received',
      name: 'alreadyGet',
      desc: '',
      args: [],
    );
  }

  /// `Unclaimed`
  String get waiteGet {
    return Intl.message(
      'Unclaimed',
      name: 'waiteGet',
      desc: '',
      args: [],
    );
  }

  /// `Returned`
  String get alreadyBack {
    return Intl.message(
      'Returned',
      name: 'alreadyBack',
      desc: '',
      args: [],
    );
  }

  /// `Receive Red Envelopes`
  String get getRed {
    return Intl.message(
      'Receive Red Envelopes',
      name: 'getRed',
      desc: '',
      args: [],
    );
  }

  /// `Send Red Envelopes`
  String get sendRed {
    return Intl.message(
      'Send Red Envelopes',
      name: 'sendRed',
      desc: '',
      args: [],
    );
  }

  /// `Send To`
  String get sendTo {
    return Intl.message(
      'Send To',
      name: 'sendTo',
      desc: '',
      args: [],
    );
  }

  /// `Red Envelopes From`
  String get redSource {
    return Intl.message(
      'Red Envelopes From',
      name: 'redSource',
      desc: '',
      args: [],
    );
  }

  /// `Remind Who To Watch`
  String get remindWhoWatch {
    return Intl.message(
      'Remind Who To Watch',
      name: 'remindWhoWatch',
      desc: '',
      args: [],
    );
  }

  /// `Contacts Friends`
  String get contactsFriends {
    return Intl.message(
      'Contacts Friends',
      name: 'contactsFriends',
      desc: '',
      args: [],
    );
  }

  /// `Where Are You`
  String get whereYou {
    return Intl.message(
      'Where Are You',
      name: 'whereYou',
      desc: '',
      args: [],
    );
  }

  /// `Recommend To Contacts`
  String get recommendToContacts {
    return Intl.message(
      'Recommend To Contacts',
      name: 'recommendToContacts',
      desc: '',
      args: [],
    );
  }

  /// `Visible To Everyone`
  String get visibleToEveryone {
    return Intl.message(
      'Visible To Everyone',
      name: 'visibleToEveryone',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `message`
  String get message1 {
    return Intl.message(
      'message',
      name: 'message1',
      desc: '',
      args: [],
    );
  }

  /// `Forward`
  String get forward {
    return Intl.message(
      'Forward',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `Not Collected`
  String get removeFavorites {
    return Intl.message(
      'Not Collected',
      name: 'removeFavorites',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Cancel this favorite message?`
  String get CancelFavorite {
    return Intl.message(
      'Cancel this favorite message?',
      name: 'CancelFavorite',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `Collection successfully`
  String get collectSuccess {
    return Intl.message(
      'Collection successfully',
      name: 'collectSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Collection failed`
  String get collectFailed {
    return Intl.message(
      'Collection failed',
      name: 'collectFailed',
      desc: '',
      args: [],
    );
  }

  /// `Cancel collection successfully`
  String get removeFavoritesSuccess {
    return Intl.message(
      'Cancel collection successfully',
      name: 'removeFavoritesSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel collection`
  String get removeFavoritesFailed {
    return Intl.message(
      'Failed to cancel collection',
      name: 'removeFavoritesFailed',
      desc: '',
      args: [],
    );
  }

  /// `{type} not supported collection`
  String notSupportCollection(Object type) {
    return Intl.message(
      '$type not supported collection',
      name: 'notSupportCollection',
      desc: '',
      args: [type],
    );
  }

  /// `Merger message`
  String get mergerMessage {
    return Intl.message(
      'Merger message',
      name: 'mergerMessage',
      desc: '',
      args: [],
    );
  }

  /// `Text message`
  String get textMessage {
    return Intl.message(
      'Text message',
      name: 'textMessage',
      desc: '',
      args: [],
    );
  }

  /// `Image message`
  String get imageMessage {
    return Intl.message(
      'Image message',
      name: 'imageMessage',
      desc: '',
      args: [],
    );
  }

  /// `Video message`
  String get videoMessage {
    return Intl.message(
      'Video message',
      name: 'videoMessage',
      desc: '',
      args: [],
    );
  }

  /// `Voice message`
  String get voiceMessage {
    return Intl.message(
      'Voice message',
      name: 'voiceMessage',
      desc: '',
      args: [],
    );
  }

  /// `File message`
  String get fileMessage {
    return Intl.message(
      'File message',
      name: 'fileMessage',
      desc: '',
      args: [],
    );
  }

  /// `Location message`
  String get locationMessage {
    return Intl.message(
      'Location message',
      name: 'locationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sound message`
  String get soundMessage {
    return Intl.message(
      'Sound message',
      name: 'soundMessage',
      desc: '',
      args: [],
    );
  }

  /// `Face message`
  String get faceMessage {
    return Intl.message(
      'Face message',
      name: 'faceMessage',
      desc: '',
      args: [],
    );
  }

  /// `Red Envelope message`
  String get redEnvelopeMessage {
    return Intl.message(
      'Red Envelope message',
      name: 'redEnvelopeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Custom message`
  String get customMessage {
    return Intl.message(
      'Custom message',
      name: 'customMessage',
      desc: '',
      args: [],
    );
  }

  /// `File Preview`
  String get filePreview {
    return Intl.message(
      'File Preview',
      name: 'filePreview',
      desc: '',
      args: [],
    );
  }

  /// `Forward To`
  String get forwardTo {
    return Intl.message(
      'Forward To',
      name: 'forwardTo',
      desc: '',
      args: [],
    );
  }

  /// `More Friend`
  String get moreFriend {
    return Intl.message(
      'More Friend',
      name: 'moreFriend',
      desc: '',
      args: [],
    );
  }

  /// `Other Apps Open`
  String get otherAPPOpen {
    return Intl.message(
      'Other Apps Open',
      name: 'otherAPPOpen',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Fail`
  String get fail {
    return Intl.message(
      'Fail',
      name: 'fail',
      desc: '',
      args: [],
    );
  }

  /// `Find chats`
  String get findChats {
    return Intl.message(
      'Find chats',
      name: 'findChats',
      desc: '',
      args: [],
    );
  }

  /// `Picture`
  String get picture {
    return Intl.message(
      'Picture',
      name: 'picture',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Voice`
  String get voice {
    return Intl.message(
      'Voice',
      name: 'voice',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get custom {
    return Intl.message(
      'Custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `Forward message`
  String get forwardMessage {
    return Intl.message(
      'Forward message',
      name: 'forwardMessage',
      desc: '',
      args: [],
    );
  }

  /// `Message reminder`
  String get messageReminderMethod {
    return Intl.message(
      'Message reminder',
      name: 'messageReminderMethod',
      desc: '',
      args: [],
    );
  }

  /// `Only receive`
  String get onlyReceive {
    return Intl.message(
      'Only receive',
      name: 'onlyReceive',
      desc: '',
      args: [],
    );
  }

  /// `Masking`
  String get maskingMessage {
    return Intl.message(
      'Masking',
      name: 'maskingMessage',
      desc: '',
      args: [],
    );
  }

  /// `Group management`
  String get groupManager {
    return Intl.message(
      'Group management',
      name: 'groupManager',
      desc: '',
      args: [],
    );
  }

  /// `Group invitation confirmation`
  String get groupInviteConfirmed {
    return Intl.message(
      'Group invitation confirmation',
      name: 'groupInviteConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `After enabled, group members need confirmation from the group owner or group administrator before inviting friends to join the group. Scanning QR codes to enter groups will be disabled at the same time.`
  String get groupInviteConfirmedTip {
    return Intl.message(
      'After enabled, group members need confirmation from the group owner or group administrator before inviting friends to join the group. Scanning QR codes to enter groups will be disabled at the same time.',
      name: 'groupInviteConfirmedTip',
      desc: '',
      args: [],
    );
  }

  /// `Only group owners/administrators can modify group names`
  String get onlyManagerChangeGroupName {
    return Intl.message(
      'Only group owners/administrators can modify group names',
      name: 'onlyManagerChangeGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Group owner transfer`
  String get groupOwnerTransfer {
    return Intl.message(
      'Group owner transfer',
      name: 'groupOwnerTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to transfer group owner permissions to {name}?`
  String groupOwnerTransferTip(Object name) {
    return Intl.message(
      'Are you sure you want to transfer group owner permissions to $name?',
      name: 'groupOwnerTransferTip',
      desc: '',
      args: [name],
    );
  }

  /// `Group administrator`
  String get groupManagers {
    return Intl.message(
      'Group administrator',
      name: 'groupManagers',
      desc: '',
      args: [],
    );
  }

  /// `Join confirmation`
  String get joinConfirmation {
    return Intl.message(
      'Join confirmation',
      name: 'joinConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `After enabled, joining users need to be confirmed by the administrator.`
  String get joinConfirmationTip {
    return Intl.message(
      'After enabled, joining users need to be confirmed by the administrator.',
      name: 'joinConfirmationTip',
      desc: '',
      args: [],
    );
  }

  /// `Private group`
  String get privateGroup {
    return Intl.message(
      'Private group',
      name: 'privateGroup',
      desc: '',
      args: [],
    );
  }

  /// `Set administrator`
  String get setGroupManagers {
    return Intl.message(
      'Set administrator',
      name: 'setGroupManagers',
      desc: '',
      args: [],
    );
  }

  /// `1. Administrators can assist group owners in managing Group chats and have the ability to invite new members and remove group members.\n2. Only the group owner has the ability to set up a group administrator. The ability to disband Group chats.\n3. Up to 5 administrators can be set up`
  String get setGroupManagersTip {
    return Intl.message(
      '1. Administrators can assist group owners in managing Group chats and have the ability to invite new members and remove group members.\n2. Only the group owner has the ability to set up a group administrator. The ability to disband Group chats.\n3. Up to 5 administrators can be set up',
      name: 'setGroupManagersTip',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to cancel the administrator rights of “{name}”?`
  String setGroupManagersTip1(Object name) {
    return Intl.message(
      'Are you sure to cancel the administrator rights of “$name”?',
      name: 'setGroupManagersTip1',
      desc: '',
      args: [name],
    );
  }

  /// `Add administrators`
  String get addGroupManagers {
    return Intl.message(
      'Add administrators',
      name: 'addGroupManagers',
      desc: '',
      args: [],
    );
  }

  /// `Up to 5 administrators can be set up`
  String get addGroupManagersTip {
    return Intl.message(
      'Up to 5 administrators can be set up',
      name: 'addGroupManagersTip',
      desc: '',
      args: [],
    );
  }

  /// `No permission`
  String get noPermission {
    return Intl.message(
      'No permission',
      name: 'noPermission',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Delete chat history`
  String get deleteChatHistory {
    return Intl.message(
      'Delete chat history',
      name: 'deleteChatHistory',
      desc: '',
      args: [],
    );
  }

  /// `After deleting, the chat history will not be restored. Are you sure you want to delete it?`
  String get deleteChatHistoryTip {
    return Intl.message(
      'After deleting, the chat history will not be restored. Are you sure you want to delete it?',
      name: 'deleteChatHistoryTip',
      desc: '',
      args: [],
    );
  }

  /// `Deleted successfully`
  String get deleteChatHistorySuccessTip {
    return Intl.message(
      'Deleted successfully',
      name: 'deleteChatHistorySuccessTip',
      desc: '',
      args: [],
    );
  }

  /// `Delete failed`
  String get deleteChatHistoryFailedTip {
    return Intl.message(
      'Delete failed',
      name: 'deleteChatHistoryFailedTip',
      desc: '',
      args: [],
    );
  }

  /// `Search for specific content`
  String get searchSpecifiedContent {
    return Intl.message(
      'Search for specific content',
      name: 'searchSpecifiedContent',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message(
      'Link',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message(
      'Hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get minute {
    return Intl.message(
      'Minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get one {
    return Intl.message(
      'Mon',
      name: 'one',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get two {
    return Intl.message(
      'Tue',
      name: 'two',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get three {
    return Intl.message(
      'Wed',
      name: 'three',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get four {
    return Intl.message(
      'Thu',
      name: 'four',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get five {
    return Intl.message(
      'Fri',
      name: 'five',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get six {
    return Intl.message(
      'Sat',
      name: 'six',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get seven {
    return Intl.message(
      'Sun',
      name: 'seven',
      desc: '',
      args: [],
    );
  }

  /// `Category Search`
  String get categorySearch {
    return Intl.message(
      'Category Search',
      name: 'categorySearch',
      desc: '',
      args: [],
    );
  }

  /// `Search File Name`
  String get searchFileName {
    return Intl.message(
      'Search File Name',
      name: 'searchFileName',
      desc: '',
      args: [],
    );
  }

  /// `{num} Files In Total`
  String numFilesTotal(Object num) {
    return Intl.message(
      '$num Files In Total',
      name: 'numFilesTotal',
      desc: '',
      args: [num],
    );
  }

  /// `Search Link Name`
  String get searchLinkName {
    return Intl.message(
      'Search Link Name',
      name: 'searchLinkName',
      desc: '',
      args: [],
    );
  }

  /// `Choice`
  String get choice {
    return Intl.message(
      'Choice',
      name: 'choice',
      desc: '',
      args: [],
    );
  }

  /// `Visible Range`
  String get visibleRange {
    return Intl.message(
      'Visible Range',
      name: 'visibleRange',
      desc: '',
      args: [],
    );
  }

  /// `Visible to everyone`
  String get visibleRange1 {
    return Intl.message(
      'Visible to everyone',
      name: 'visibleRange1',
      desc: '',
      args: [],
    );
  }

  /// `Visible only to home page`
  String get visibleRange2 {
    return Intl.message(
      'Visible only to home page',
      name: 'visibleRange2',
      desc: '',
      args: [],
    );
  }

  /// `Others can only see it on your homepage`
  String get visibleRange2Tip {
    return Intl.message(
      'Others can only see it on your homepage',
      name: 'visibleRange2Tip',
      desc: '',
      args: [],
    );
  }

  /// `Visible only to strangers`
  String get visibleRange3 {
    return Intl.message(
      'Visible only to strangers',
      name: 'visibleRange3',
      desc: '',
      args: [],
    );
  }

  /// `All related friends and group members are invisible`
  String get visibleRange3Tip {
    return Intl.message(
      'All related friends and group members are invisible',
      name: 'visibleRange3Tip',
      desc: '',
      args: [],
    );
  }

  /// `Visible only to myself`
  String get visibleRange4 {
    return Intl.message(
      'Visible only to myself',
      name: 'visibleRange4',
      desc: '',
      args: [],
    );
  }

  /// `Visible only to dynamic square`
  String get visibleRange5 {
    return Intl.message(
      'Visible only to dynamic square',
      name: 'visibleRange5',
      desc: '',
      args: [],
    );
  }

  /// `Only visible in the dynamic square`
  String get visibleRange5Tip {
    return Intl.message(
      'Only visible in the dynamic square',
      name: 'visibleRange5Tip',
      desc: '',
      args: [],
    );
  }

  /// `Not visible to others`
  String get visibleRange6 {
    return Intl.message(
      'Not visible to others',
      name: 'visibleRange6',
      desc: '',
      args: [],
    );
  }

  /// `Not visible to specified users`
  String get visibleRange6Tip {
    return Intl.message(
      'Not visible to specified users',
      name: 'visibleRange6Tip',
      desc: '',
      args: [],
    );
  }

  /// `Permissions`
  String get permissions {
    return Intl.message(
      'Permissions',
      name: 'permissions',
      desc: '',
      args: [],
    );
  }

  /// `Download Prohibited`
  String get downloadProhibited {
    return Intl.message(
      'Download Prohibited',
      name: 'downloadProhibited',
      desc: '',
      args: [],
    );
  }

  /// `Share Prohibited`
  String get shareProhibited {
    return Intl.message(
      'Share Prohibited',
      name: 'shareProhibited',
      desc: '',
      args: [],
    );
  }

  /// `Who can comment on me`
  String get whoCanComment {
    return Intl.message(
      'Who can comment on me',
      name: 'whoCanComment',
      desc: '',
      args: [],
    );
  }

  /// `Everyone can comment`
  String get whoCanComment1 {
    return Intl.message(
      'Everyone can comment',
      name: 'whoCanComment1',
      desc: '',
      args: [],
    );
  }

  /// `People I follow can comment`
  String get whoCanComment2 {
    return Intl.message(
      'People I follow can comment',
      name: 'whoCanComment2',
      desc: '',
      args: [],
    );
  }

  /// `People who follow me can comment`
  String get whoCanComment3 {
    return Intl.message(
      'People who follow me can comment',
      name: 'whoCanComment3',
      desc: '',
      args: [],
    );
  }

  /// `No one can comment`
  String get whoCanComment4 {
    return Intl.message(
      'No one can comment',
      name: 'whoCanComment4',
      desc: '',
      args: [],
    );
  }

  /// `Save Draft`
  String get saveDraft {
    return Intl.message(
      'Save Draft',
      name: 'saveDraft',
      desc: '',
      args: [],
    );
  }

  /// `Not Save`
  String get notSave {
    return Intl.message(
      'Not Save',
      name: 'notSave',
      desc: '',
      args: [],
    );
  }

  /// `Message sending failed`
  String get sendFail {
    return Intl.message(
      'Message sending failed',
      name: 'sendFail',
      desc: '',
      args: [],
    );
  }

  /// `Search history`
  String get searchHistory {
    return Intl.message(
      'Search history',
      name: 'searchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Hot top`
  String get hotTop {
    return Intl.message(
      'Hot top',
      name: 'hotTop',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour2 {
    return Intl.message(
      'Hour',
      name: 'hour2',
      desc: '',
      args: [],
    );
  }

  /// `Select the duration of the hot post`
  String get selectDurationHotPost {
    return Intl.message(
      'Select the duration of the hot post',
      name: 'selectDurationHotPost',
      desc: '',
      args: [],
    );
  }

  /// `Current remaining`
  String get currentRemaining {
    return Intl.message(
      'Current remaining',
      name: 'currentRemaining',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get otherDuration {
    return Intl.message(
      'Other',
      name: 'otherDuration',
      desc: '',
      args: [],
    );
  }

  /// `Current payment required`
  String get currentPaymentRequired {
    return Intl.message(
      'Current payment required',
      name: 'currentPaymentRequired',
      desc: '',
      args: [],
    );
  }

  /// `Pay now`
  String get payNow {
    return Intl.message(
      'Pay now',
      name: 'payNow',
      desc: '',
      args: [],
    );
  }

  /// `Hot post successful`
  String get hotPostSuccessful {
    return Intl.message(
      'Hot post successful',
      name: 'hotPostSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Failed, insufficient balance`
  String get verificationFailedInsufficientBalance {
    return Intl.message(
      'Failed, insufficient balance',
      name: 'verificationFailedInsufficientBalance',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic verification`
  String get mnemonicVerification {
    return Intl.message(
      'Mnemonic verification',
      name: 'mnemonicVerification',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get verified {
    return Intl.message(
      'Verified',
      name: 'verified',
      desc: '',
      args: [],
    );
  }

  /// `To verify`
  String get toVerified {
    return Intl.message(
      'To verify',
      name: 'toVerified',
      desc: '',
      args: [],
    );
  }

  /// `Prompt`
  String get tip {
    return Intl.message(
      'Prompt',
      name: 'tip',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic words are used to retrieve passwords. If you skip them, you cannot retrieve them. You can set them in your personal center. Are you sure to skip?`
  String get mnemonicTip2 {
    return Intl.message(
      'Mnemonic words are used to retrieve passwords. If you skip them, you cannot retrieve them. You can set them in your personal center. Are you sure to skip?',
      name: 'mnemonicTip2',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text1 {
    return Intl.message(
      'Text',
      name: 'text1',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get like {
    return Intl.message(
      'Like',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `By Heat`
  String get byHeat {
    return Intl.message(
      'By Heat',
      name: 'byHeat',
      desc: '',
      args: [],
    );
  }

  /// `By Time`
  String get byTime {
    return Intl.message(
      'By Time',
      name: 'byTime',
      desc: '',
      args: [],
    );
  }

  /// `Delete This Comment?`
  String get deleteComment {
    return Intl.message(
      'Delete This Comment?',
      name: 'deleteComment',
      desc: '',
      args: [],
    );
  }

  /// `When a comment is deleted, the reply under the comment will also be deleted. Are you sure you want to delete it?`
  String get deleteCommentTip {
    return Intl.message(
      'When a comment is deleted, the reply under the comment will also be deleted. Are you sure you want to delete it?',
      name: 'deleteCommentTip',
      desc: '',
      args: [],
    );
  }

  /// `Delete Successfully`
  String get deleteSuccess {
    return Intl.message(
      'Delete Successfully',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Liked Successfully`
  String get likeSuccess {
    return Intl.message(
      'Liked Successfully',
      name: 'likeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Liked Fail`
  String get likeFailed {
    return Intl.message(
      'Liked Fail',
      name: 'likeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribed Like Successfully`
  String get cancelLikeSuccess {
    return Intl.message(
      'Unsubscribed Like Successfully',
      name: 'cancelLikeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribed Like Fail`
  String get cancelLikeFailed {
    return Intl.message(
      'Unsubscribed Like Fail',
      name: 'cancelLikeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Follow Success`
  String get followSuccess {
    return Intl.message(
      'Follow Success',
      name: 'followSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Follow Fail`
  String get followFailed {
    return Intl.message(
      'Follow Fail',
      name: 'followFailed',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribed Successfully`
  String get unfollowSuccess {
    return Intl.message(
      'Unsubscribed Successfully',
      name: 'unfollowSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribed Fail`
  String get unfollowFailed {
    return Intl.message(
      'Unsubscribed Fail',
      name: 'unfollowFailed',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Reward Successful`
  String get rewardSuccessful {
    return Intl.message(
      'Reward Successful',
      name: 'rewardSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Select The Tipping Amount`
  String get selectTippingAmount {
    return Intl.message(
      'Select The Tipping Amount',
      name: 'selectTippingAmount',
      desc: '',
      args: [],
    );
  }

  /// `Other Amounts`
  String get otherAmounts {
    return Intl.message(
      'Other Amounts',
      name: 'otherAmounts',
      desc: '',
      args: [],
    );
  }

  /// `Reward Immediately`
  String get rewardImmediately {
    return Intl.message(
      'Reward Immediately',
      name: 'rewardImmediately',
      desc: '',
      args: [],
    );
  }

  /// `Discussions`
  String get participateDiscussions {
    return Intl.message(
      'Discussions',
      name: 'participateDiscussions',
      desc: '',
      args: [],
    );
  }

  /// `The user has set the permission to comment`
  String get notCommentTip {
    return Intl.message(
      'The user has set the permission to comment',
      name: 'notCommentTip',
      desc: '',
      args: [],
    );
  }

  /// `The user has set the permission to share`
  String get notShareTip {
    return Intl.message(
      'The user has set the permission to share',
      name: 'notShareTip',
      desc: '',
      args: [],
    );
  }

  /// `{name} published dynamic`
  String publishDynamic(Object name) {
    return Intl.message(
      '$name published dynamic',
      name: 'publishDynamic',
      desc: '',
      args: [name],
    );
  }

  /// `Cancel Collect Success`
  String get cancelCollectSuccess {
    return Intl.message(
      'Cancel Collect Success',
      name: 'cancelCollectSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Collect Failed`
  String get cancelCollectFailed {
    return Intl.message(
      'Cancel Collect Failed',
      name: 'cancelCollectFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delete Failed`
  String get deleteFailed {
    return Intl.message(
      'Delete Failed',
      name: 'deleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delete record prompt`
  String get deleteRecordPrompt {
    return Intl.message(
      'Delete record prompt',
      name: 'deleteRecordPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear the record?`
  String get deleteRecordPromptTip {
    return Intl.message(
      'Are you sure you want to clear the record?',
      name: 'deleteRecordPromptTip',
      desc: '',
      args: [],
    );
  }

  /// `Views Record`
  String get viewsRecord {
    return Intl.message(
      'Views Record',
      name: 'viewsRecord',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Push`
  String get push {
    return Intl.message(
      'Push',
      name: 'push',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Collect`
  String get cancelCollect {
    return Intl.message(
      'Cancel Collect',
      name: 'cancelCollect',
      desc: '',
      args: [],
    );
  }

  /// `Help Hot`
  String get helpHot {
    return Intl.message(
      'Help Hot',
      name: 'helpHot',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this dynamic?`
  String get deleteDynamicTip {
    return Intl.message(
      'Are you sure to delete this dynamic?',
      name: 'deleteDynamicTip',
      desc: '',
      args: [],
    );
  }

  /// `Mutual`
  String get mutualFollow {
    return Intl.message(
      'Mutual',
      name: 'mutualFollow',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to unfollow?`
  String get unfollowTip {
    return Intl.message(
      'Do you want to unfollow?',
      name: 'unfollowTip',
      desc: '',
      args: [],
    );
  }

  /// `Visited Yesterday`
  String get visitedYesterday {
    return Intl.message(
      'Visited Yesterday',
      name: 'visitedYesterday',
      desc: '',
      args: [],
    );
  }

  /// `My Visit`
  String get myVisit {
    return Intl.message(
      'My Visit',
      name: 'myVisit',
      desc: '',
      args: [],
    );
  }

  /// `Number Visitors`
  String get numberVisitors {
    return Intl.message(
      'Number Visitors',
      name: 'numberVisitors',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic Tipping`
  String get dynamicTipping {
    return Intl.message(
      'Dynamic Tipping',
      name: 'dynamicTipping',
      desc: '',
      args: [],
    );
  }

  /// `Reward Amount`
  String get rewardAmount {
    return Intl.message(
      'Reward Amount',
      name: 'rewardAmount',
      desc: '',
      args: [],
    );
  }

  /// `Reward Time`
  String get rewardTime {
    return Intl.message(
      'Reward Time',
      name: 'rewardTime',
      desc: '',
      args: [],
    );
  }

  /// `Reward To`
  String get rewardTo {
    return Intl.message(
      'Reward To',
      name: 'rewardTo',
      desc: '',
      args: [],
    );
  }

  /// `Amount Reward Received`
  String get amountRewardReceived {
    return Intl.message(
      'Amount Reward Received',
      name: 'amountRewardReceived',
      desc: '',
      args: [],
    );
  }

  /// `Time Being Rewarded`
  String get timeBeingRewarded {
    return Intl.message(
      'Time Being Rewarded',
      name: 'timeBeingRewarded',
      desc: '',
      args: [],
    );
  }

  /// `Giver`
  String get giver {
    return Intl.message(
      'Giver',
      name: 'giver',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Record your life, because you are different from others.`
  String get recordYourLife {
    return Intl.message(
      'Record your life, because you are different from others.',
      name: 'recordYourLife',
      desc: '',
      args: [],
    );
  }

  /// `Recently Used`
  String get recentlyUsed {
    return Intl.message(
      'Recently Used',
      name: 'recentlyUsed',
      desc: '',
      args: [],
    );
  }

  /// `All Expressions`
  String get allExpressions {
    return Intl.message(
      'All Expressions',
      name: 'allExpressions',
      desc: '',
      args: [],
    );
  }

  /// `The image or video cannot be larger than 100MB`
  String get imageVideoNot100MB {
    return Intl.message(
      'The image or video cannot be larger than 100MB',
      name: 'imageVideoNot100MB',
      desc: '',
      args: [],
    );
  }

  /// `Partial Return`
  String get partialReturn {
    return Intl.message(
      'Partial Return',
      name: 'partialReturn',
      desc: '',
      args: [],
    );
  }

  /// `Refund Amount`
  String get refundAmount {
    return Intl.message(
      'Refund Amount',
      name: 'refundAmount',
      desc: '',
      args: [],
    );
  }

  /// `Share Success`
  String get shareSuccess {
    return Intl.message(
      'Share Success',
      name: 'shareSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Share Failed`
  String get shareFailed {
    return Intl.message(
      'Share Failed',
      name: 'shareFailed',
      desc: '',
      args: [],
    );
  }

  /// `Allow members add friends`
  String get allowMembersAddFriends {
    return Intl.message(
      'Allow members add friends',
      name: 'allowMembersAddFriends',
      desc: '',
      args: [],
    );
  }

  /// `Setting successful`
  String get muteGroupSuccess {
    return Intl.message(
      'Setting successful',
      name: 'muteGroupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Setting failed`
  String get muteGroupFailed {
    return Intl.message(
      'Setting failed',
      name: 'muteGroupFailed',
      desc: '',
      args: [],
    );
  }

  /// `Mute all`
  String get muteGroupAll {
    return Intl.message(
      'Mute all',
      name: 'muteGroupAll',
      desc: '',
      args: [],
    );
  }

  /// `Mute`
  String get muteGroup {
    return Intl.message(
      'Mute',
      name: 'muteGroup',
      desc: '',
      args: [],
    );
  }

  /// `After the mute, the member will not be able to speak.`
  String get muteGroupTip {
    return Intl.message(
      'After the mute, the member will not be able to speak.',
      name: 'muteGroupTip',
      desc: '',
      args: [],
    );
  }

  /// `After mute all member, only group owners and administrators are allowed to speak.`
  String get muteGroupAllTip {
    return Intl.message(
      'After mute all member, only group owners and administrators are allowed to speak.',
      name: 'muteGroupAllTip',
      desc: '',
      args: [],
    );
  }

  /// `Add mute members`
  String get addMuteMembers {
    return Intl.message(
      'Add mute members',
      name: 'addMuteMembers',
      desc: '',
      args: [],
    );
  }

  /// `Mute setting`
  String get muteSetting {
    return Intl.message(
      'Mute setting',
      name: 'muteSetting',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get modifyPassword {
    return Intl.message(
      'Change password',
      name: 'modifyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Avatar`
  String get avatar {
    return Intl.message(
      'Avatar',
      name: 'avatar',
      desc: '',
      args: [],
    );
  }

  /// `QR Code Card`
  String get qrCard {
    return Intl.message(
      'QR Code Card',
      name: 'qrCard',
      desc: '',
      args: [],
    );
  }

  /// `Scan the QR code above and add me as a friend`
  String get qrCardTip {
    return Intl.message(
      'Scan the QR code above and add me as a friend',
      name: 'qrCardTip',
      desc: '',
      args: [],
    );
  }

  /// `Select Payment Address`
  String get selectCoinAddress {
    return Intl.message(
      'Select Payment Address',
      name: 'selectCoinAddress',
      desc: '',
      args: [],
    );
  }

  /// `Not Remarks`
  String get noRemarks {
    return Intl.message(
      'Not Remarks',
      name: 'noRemarks',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Select`
  String get confirmSelect {
    return Intl.message(
      'Confirm Select',
      name: 'confirmSelect',
      desc: '',
      args: [],
    );
  }

  /// `coin Address`
  String get coinAddress {
    return Intl.message(
      'coin Address',
      name: 'coinAddress',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add Payment Address`
  String get addCoinAddress {
    return Intl.message(
      'Add Payment Address',
      name: 'addCoinAddress',
      desc: '',
      args: [],
    );
  }

  /// `Edit Payment Address`
  String get editCoinAddress {
    return Intl.message(
      'Edit Payment Address',
      name: 'editCoinAddress',
      desc: '',
      args: [],
    );
  }

  /// `Edit Password`
  String get editPassword {
    return Intl.message(
      'Edit Password',
      name: 'editPassword',
      desc: '',
      args: [],
    );
  }

  /// `Input Old Password`
  String get inputOldPassword {
    return Intl.message(
      'Input Old Password',
      name: 'inputOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Edit Password Success`
  String get editPasswordSuccess {
    return Intl.message(
      'Edit Password Success',
      name: 'editPasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Edit Password Fail`
  String get editPasswordFail {
    return Intl.message(
      'Edit Password Fail',
      name: 'editPasswordFail',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
