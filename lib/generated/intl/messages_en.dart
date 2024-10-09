// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) =>
      "Are you sure you want to transfer group owner permissions to ${name}?";

  static String m1(type) => "${type} not supported collection";

  static String m2(index) => "Sound ${index}";

  static String m3(num) => "${num} Files In Total";

  static String m4(name) => "${name} published dynamic";

  static String m5(name) =>
      "Are you sure to cancel the administrator rights of “${name}”?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "CancelFavorite": MessageLookupByLibrary.simpleMessage(
            "Cancel this favorite message?"),
        "Exclusive": MessageLookupByLibrary.simpleMessage("Exclusive"),
        "ExclusiveRedBag":
            MessageLookupByLibrary.simpleMessage("Exclusive Red Envelope"),
        "KindTips": MessageLookupByLibrary.simpleMessage("温馨提示"),
        "KindTipsRecharge": MessageLookupByLibrary.simpleMessage(
            "Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n①The platform only supports BEP-20 type blockchain digital currency collection. To ensure your recharge is smooth, please check the selected channel before transferring and ensure that your transfer type is correct. We will not be responsible for the situation of transferring the wrong type.\n②To avoid loss of money, please do not save the payment address. The wrong address will cause your recharge to fail to arrive.\n③In order to avoid differences in text understanding, our company reserves the right of final interpretation.\n④If you have any questions, please submit a work order to contact customer service, and we will help you as soon as possible."),
        "KindTipsTransfer": MessageLookupByLibrary.simpleMessage(
            "Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n① The transfer application platform charges a commission fee: BECP-BEP20, which is 1% of the withdrawal amount.\n② The transfer operation is irreversible. Once the operation is performed, our company will not be responsible. Please operate with caution.\n③ In order to avoid differences in text understanding, our company reserves the right of final interpretation."),
        "KindTipsWithdrawal": MessageLookupByLibrary.simpleMessage(
            "Dear customers:\nIn order to provide you with safe and efficient services, please pay attention to the following matters when you save:\n① The withdrawal application platform charges a handling fee commission: BECP-BEP20 of 1% of the withdrawal amount.\n② Please provide the correct wallet payment address information. If the loss is caused by the incorrect wallet address provided, our company will not be responsible.\n③ Due to the factors of the on-chain network and processing speed, the withdrawal time may vary. Please wait patiently.\n④ In order to avoid differences in text understanding, our company reserves the right of final interpretation.\n⑤ If you have any questions, please submit a work order to contact"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountLogged": MessageLookupByLibrary.simpleMessage(
            "The account is logged in elsewhere"),
        "accountTip":
            MessageLookupByLibrary.simpleMessage("Please enter the account"),
        "accumulatedIssuance":
            MessageLookupByLibrary.simpleMessage("Accumulated Issuance"),
        "accumulatedReceipts":
            MessageLookupByLibrary.simpleMessage("Accumulated Receipts"),
        "activityRecord":
            MessageLookupByLibrary.simpleMessage("Activity Record"),
        "actualReceived": MessageLookupByLibrary.simpleMessage("Received"),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addCoinAddress":
            MessageLookupByLibrary.simpleMessage("Add Payment Address"),
        "addFriend": MessageLookupByLibrary.simpleMessage("Add friends"),
        "addFriend1": MessageLookupByLibrary.simpleMessage("+Friend"),
        "addGroupManagers":
            MessageLookupByLibrary.simpleMessage("Add administrators"),
        "addGroupManagersTip": MessageLookupByLibrary.simpleMessage(
            "Up to 5 administrators can be set up"),
        "addMuteMembers":
            MessageLookupByLibrary.simpleMessage("Add mute members"),
        "advertisingCenter": MessageLookupByLibrary.simpleMessage("AD center"),
        "agree": MessageLookupByLibrary.simpleMessage("Agreed"),
        "agreed": MessageLookupByLibrary.simpleMessage("Agreed"),
        "album": MessageLookupByLibrary.simpleMessage("Album"),
        "alertSounds": MessageLookupByLibrary.simpleMessage("Alert Sounds"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "allExpressions":
            MessageLookupByLibrary.simpleMessage("All Expressions"),
        "allowMembersAddFriends":
            MessageLookupByLibrary.simpleMessage("Allow members add friends"),
        "alreadyBack": MessageLookupByLibrary.simpleMessage("Returned"),
        "alreadyBound": MessageLookupByLibrary.simpleMessage("Already Bound"),
        "alreadyGet": MessageLookupByLibrary.simpleMessage("Received"),
        "amountReceived":
            MessageLookupByLibrary.simpleMessage("Amount Received"),
        "amountRewardReceived":
            MessageLookupByLibrary.simpleMessage("Amount Reward Received"),
        "appName": MessageLookupByLibrary.simpleMessage("BeeChat"),
        "applyAddFriend":
            MessageLookupByLibrary.simpleMessage("apply to add friends"),
        "applyJoinGroup":
            MessageLookupByLibrary.simpleMessage("apply to join Group chats"),
        "applyJoinGroupTip":
            MessageLookupByLibrary.simpleMessage("apply to join Group"),
        "applyJoinGroupTitle":
            MessageLookupByLibrary.simpleMessage("Group Requisition"),
        "assets": MessageLookupByLibrary.simpleMessage("assets"),
        "assetsRecord": MessageLookupByLibrary.simpleMessage("Asset Records"),
        "autoAcceptGroup": MessageLookupByLibrary.simpleMessage(
            "Automatically Accept Group Invitations"),
        "avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
        "bindGoogleAuthenticator":
            MessageLookupByLibrary.simpleMessage("Bind Google Authenticator"),
        "bindGoogleAuthenticatorTip": MessageLookupByLibrary.simpleMessage(
            "Please use Google Authenticator to scan the following QR code to get the verification code to complete the binding"),
        "bindNow": MessageLookupByLibrary.simpleMessage("Bind Now"),
        "byHeat": MessageLookupByLibrary.simpleMessage("By Heat"),
        "byTime": MessageLookupByLibrary.simpleMessage("By Time"),
        "callVideo": MessageLookupByLibrary.simpleMessage("Call"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "canWithdrawalNum": MessageLookupByLibrary.simpleMessage("Available"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelCollect": MessageLookupByLibrary.simpleMessage("Cancel Collect"),
        "cancelCollectFailed":
            MessageLookupByLibrary.simpleMessage("Cancel Collect Failed"),
        "cancelCollectSuccess":
            MessageLookupByLibrary.simpleMessage("Cancel Collect Success"),
        "cancelLikeFailed":
            MessageLookupByLibrary.simpleMessage("Unsubscribed Like Fail"),
        "cancelLikeSuccess": MessageLookupByLibrary.simpleMessage(
            "Unsubscribed Like Successfully"),
        "cancelTop": MessageLookupByLibrary.simpleMessage("Cancel top"),
        "cannotLess": MessageLookupByLibrary.simpleMessage(
            "Currency cannot be less than 0.1"),
        "categorySearch":
            MessageLookupByLibrary.simpleMessage("Category Search"),
        "changeFail":
            MessageLookupByLibrary.simpleMessage("Modification failed"),
        "changeRemark": MessageLookupByLibrary.simpleMessage("Modify remarks"),
        "changeSuccess":
            MessageLookupByLibrary.simpleMessage("Modification successful"),
        "chat": MessageLookupByLibrary.simpleMessage("Chat"),
        "chatConversion":
            MessageLookupByLibrary.simpleMessage("Chat conversion"),
        "chatRecord": MessageLookupByLibrary.simpleMessage("Chat records"),
        "chatSettings": MessageLookupByLibrary.simpleMessage("Chat Settings"),
        "choice": MessageLookupByLibrary.simpleMessage("Choice"),
        "chooseContact": MessageLookupByLibrary.simpleMessage("Select contact"),
        "chooseMember": MessageLookupByLibrary.simpleMessage("Select members"),
        "clickLook": MessageLookupByLibrary.simpleMessage("click & look"),
        "coinAddress": MessageLookupByLibrary.simpleMessage("coin Address"),
        "coinNum": MessageLookupByLibrary.simpleMessage("Currency Quantity"),
        "coinPair": MessageLookupByLibrary.simpleMessage("Coin Pair"),
        "coinType": MessageLookupByLibrary.simpleMessage("Currency"),
        "collectFailed":
            MessageLookupByLibrary.simpleMessage("Collection failed"),
        "collectSuccess":
            MessageLookupByLibrary.simpleMessage("Collection successfully"),
        "collection": MessageLookupByLibrary.simpleMessage("Collection"),
        "collectionPayments":
            MessageLookupByLibrary.simpleMessage("Collection"),
        "comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "completed": MessageLookupByLibrary.simpleMessage("Completed"),
        "completed2": MessageLookupByLibrary.simpleMessage("Completed"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "confirmPasswordError": MessageLookupByLibrary.simpleMessage(
            "The confirmation password and password are inconsistent"),
        "confirmSelect": MessageLookupByLibrary.simpleMessage("Confirm Select"),
        "confirmTransfer":
            MessageLookupByLibrary.simpleMessage("Confirm Transfer"),
        "confirmWithdrawal":
            MessageLookupByLibrary.simpleMessage("Confirm Withdrawal"),
        "contact": MessageLookupByLibrary.simpleMessage("Contact"),
        "contactsFriends":
            MessageLookupByLibrary.simpleMessage("Contacts Friends"),
        "copiedClipboardSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Copied To Clipboard Successfully"),
        "copyRechargeAddress":
            MessageLookupByLibrary.simpleMessage("Copy deposit address"),
        "copyToClipboard":
            MessageLookupByLibrary.simpleMessage("Copy to clipboard"),
        "copyToClipboardSuccess":
            MessageLookupByLibrary.simpleMessage("Copied to clipboard"),
        "createGroupChat":
            MessageLookupByLibrary.simpleMessage("Create group chats"),
        "createGroupFail":
            MessageLookupByLibrary.simpleMessage("Failed to create Group"),
        "createGroupSuccess":
            MessageLookupByLibrary.simpleMessage("Success to create Group"),
        "currentPaymentRequired":
            MessageLookupByLibrary.simpleMessage("Current payment required"),
        "currentRemaining":
            MessageLookupByLibrary.simpleMessage("Current remaining"),
        "currentText": MessageLookupByLibrary.simpleMessage("Current"),
        "custodyWallet": MessageLookupByLibrary.simpleMessage("Custody Wallet"),
        "custom": MessageLookupByLibrary.simpleMessage("Custom"),
        "customMessage": MessageLookupByLibrary.simpleMessage("Custom message"),
        "cutting": MessageLookupByLibrary.simpleMessage("Cut"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "day": MessageLookupByLibrary.simpleMessage("Day"),
        "defaultText": MessageLookupByLibrary.simpleMessage("Default"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteChatHistory":
            MessageLookupByLibrary.simpleMessage("Delete chat history"),
        "deleteChatHistoryFailedTip":
            MessageLookupByLibrary.simpleMessage("Delete failed"),
        "deleteChatHistorySuccessTip":
            MessageLookupByLibrary.simpleMessage("Deleted successfully"),
        "deleteChatHistoryTip": MessageLookupByLibrary.simpleMessage(
            "After deleting, the chat history will not be restored. Are you sure you want to delete it?"),
        "deleteComment":
            MessageLookupByLibrary.simpleMessage("Delete This Comment?"),
        "deleteCommentTip": MessageLookupByLibrary.simpleMessage(
            "When a comment is deleted, the reply under the comment will also be deleted. Are you sure you want to delete it?"),
        "deleteDynamicTip": MessageLookupByLibrary.simpleMessage(
            "Are you sure to delete this dynamic?"),
        "deleteFailed": MessageLookupByLibrary.simpleMessage("Delete Failed"),
        "deleteFriend": MessageLookupByLibrary.simpleMessage("Delete friends"),
        "deleteFriendTip": MessageLookupByLibrary.simpleMessage(
            "Are you sure delete your friends?"),
        "deleteRecordPrompt":
            MessageLookupByLibrary.simpleMessage("Delete record prompt"),
        "deleteRecordPromptTip": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to clear the record?"),
        "deleteSuccess":
            MessageLookupByLibrary.simpleMessage("Delete Successfully"),
        "disbandGroup": MessageLookupByLibrary.simpleMessage("Disband Group"),
        "disbandGroupTip": MessageLookupByLibrary.simpleMessage(
            "Are you sure to disband your Group?"),
        "downloadCompleted":
            MessageLookupByLibrary.simpleMessage("download is complete"),
        "downloadNow": MessageLookupByLibrary.simpleMessage("DownloadNow"),
        "downloadProhibited":
            MessageLookupByLibrary.simpleMessage("Download Prohibited"),
        "downloading": MessageLookupByLibrary.simpleMessage("Downloading..."),
        "draftBox": MessageLookupByLibrary.simpleMessage("Draft"),
        "dynamic": MessageLookupByLibrary.simpleMessage("Dynamic"),
        "dynamicTipping":
            MessageLookupByLibrary.simpleMessage("Dynamic Tipping"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editAssets": MessageLookupByLibrary.simpleMessage("Edit Assets"),
        "editCoinAddress":
            MessageLookupByLibrary.simpleMessage("Edit Payment Address"),
        "editPassword": MessageLookupByLibrary.simpleMessage("Edit Password"),
        "editPasswordFail":
            MessageLookupByLibrary.simpleMessage("Edit Password Fail"),
        "editPasswordSuccess":
            MessageLookupByLibrary.simpleMessage("Edit Password Success"),
        "exit": MessageLookupByLibrary.simpleMessage("Quit"),
        "exitGroup": MessageLookupByLibrary.simpleMessage("Quit Group chats"),
        "exitGroupTip": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to quit group"),
        "exitingDelete": MessageLookupByLibrary.simpleMessage(
            "Delete Replies & Records When Exiting Group"),
        "experienceNow": MessageLookupByLibrary.simpleMessage("Experience now"),
        "export": MessageLookupByLibrary.simpleMessage("Export"),
        "faceMessage": MessageLookupByLibrary.simpleMessage("Face message"),
        "fail": MessageLookupByLibrary.simpleMessage("Fail"),
        "fallList": MessageLookupByLibrary.simpleMessage("Fall list"),
        "fans": MessageLookupByLibrary.simpleMessage("Fans"),
        "file": MessageLookupByLibrary.simpleMessage("File"),
        "fileMessage": MessageLookupByLibrary.simpleMessage("File message"),
        "filePathError":
            MessageLookupByLibrary.simpleMessage("File path error"),
        "filePreview": MessageLookupByLibrary.simpleMessage("File Preview"),
        "find": MessageLookupByLibrary.simpleMessage("Find"),
        "findChats": MessageLookupByLibrary.simpleMessage("Find chats"),
        "findNewVersion": MessageLookupByLibrary.simpleMessage("New versions"),
        "five": MessageLookupByLibrary.simpleMessage("Fri"),
        "follow": MessageLookupByLibrary.simpleMessage("Follow"),
        "followFailed": MessageLookupByLibrary.simpleMessage("Follow Fail"),
        "followSuccess": MessageLookupByLibrary.simpleMessage("Follow Success"),
        "followed": MessageLookupByLibrary.simpleMessage("Followed"),
        "forgetPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password"),
        "forward": MessageLookupByLibrary.simpleMessage("Forward"),
        "forwardMessage":
            MessageLookupByLibrary.simpleMessage("Forward message"),
        "forwardTo": MessageLookupByLibrary.simpleMessage("Forward To"),
        "four": MessageLookupByLibrary.simpleMessage("Thu"),
        "from": MessageLookupByLibrary.simpleMessage("From"),
        "getRed": MessageLookupByLibrary.simpleMessage("Receive Red Envelopes"),
        "giver": MessageLookupByLibrary.simpleMessage("Giver"),
        "goBind": MessageLookupByLibrary.simpleMessage("Go To Bind"),
        "goLogin": MessageLookupByLibrary.simpleMessage("Login"),
        "goOpen": MessageLookupByLibrary.simpleMessage("Open"),
        "goRegister": MessageLookupByLibrary.simpleMessage("to register>"),
        "googleAuthenticator":
            MessageLookupByLibrary.simpleMessage("Google Authenticator"),
        "groupAdmin": MessageLookupByLibrary.simpleMessage("Admin"),
        "groupChat": MessageLookupByLibrary.simpleMessage("Group chat"),
        "groupInMember":
            MessageLookupByLibrary.simpleMessage("Members of group"),
        "groupInfo": MessageLookupByLibrary.simpleMessage("Group info"),
        "groupIntroduction":
            MessageLookupByLibrary.simpleMessage("Group introduction"),
        "groupInviteConfirmed": MessageLookupByLibrary.simpleMessage(
            "Group invitation confirmation"),
        "groupInviteConfirmedTip": MessageLookupByLibrary.simpleMessage(
            "After enabled, group members need confirmation from the group owner or group administrator before inviting friends to join the group. Scanning QR codes to enter groups will be disabled at the same time."),
        "groupJoinConfirmation":
            MessageLookupByLibrary.simpleMessage("Join confirmation"),
        "groupJoinConfirmationTip": MessageLookupByLibrary.simpleMessage(
            "After confirmation is enabled, joining users need to be confirmed by the administrator"),
        "groupLeader": MessageLookupByLibrary.simpleMessage("Owner"),
        "groupManager":
            MessageLookupByLibrary.simpleMessage("Group management"),
        "groupManagers":
            MessageLookupByLibrary.simpleMessage("Group administrator"),
        "groupMember": MessageLookupByLibrary.simpleMessage("Group members"),
        "groupMember1": MessageLookupByLibrary.simpleMessage("group members"),
        "groupName": MessageLookupByLibrary.simpleMessage("Group name"),
        "groupNameHintText": MessageLookupByLibrary.simpleMessage(
            "Describe the highlights, content, suitable people, and theme of the Group chats. Ask everyone to participate together"),
        "groupNum": MessageLookupByLibrary.simpleMessage("Group ID"),
        "groupOwnerTransfer":
            MessageLookupByLibrary.simpleMessage("Group owner transfer"),
        "groupOwnerTransferTip": m0,
        "groupPrivate":
            MessageLookupByLibrary.simpleMessage("Group chats private"),
        "groupPrivateTip": MessageLookupByLibrary.simpleMessage(
            "After turning on privacy, it cannot be searched. and can only be invited by the administrator"),
        "groupSettings":
            MessageLookupByLibrary.simpleMessage("Group Chat Settings"),
        "groupShareTip": MessageLookupByLibrary.simpleMessage(
            "Scan the QR code and join Group"),
        "haveAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account"),
        "helpHot": MessageLookupByLibrary.simpleMessage("Help Hot"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "home": MessageLookupByLibrary.simpleMessage("Bee Chat"),
        "hot": MessageLookupByLibrary.simpleMessage("Hot"),
        "hotAPP": MessageLookupByLibrary.simpleMessage("Hot APP"),
        "hotDynamic": MessageLookupByLibrary.simpleMessage("Hot"),
        "hotPostSuccessful":
            MessageLookupByLibrary.simpleMessage("Hot post successful"),
        "hotTop": MessageLookupByLibrary.simpleMessage("Hot top"),
        "hour": MessageLookupByLibrary.simpleMessage("Hour"),
        "hour2": MessageLookupByLibrary.simpleMessage("Hour"),
        "imNotLogin": MessageLookupByLibrary.simpleMessage(
            "IM is not login, please login again"),
        "imageMessage": MessageLookupByLibrary.simpleMessage("Image message"),
        "imageVideoNot100MB": MessageLookupByLibrary.simpleMessage(
            "The image or video cannot be larger than 100MB"),
        "inputCaptcha": MessageLookupByLibrary.simpleMessage(
            "Please enter the graphic captcha"),
        "inputConfirmPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter confirmation password"),
        "inputGroupIntroduction": MessageLookupByLibrary.simpleMessage(
            "Please enter the group introduction"),
        "inputGroupName": MessageLookupByLibrary.simpleMessage(
            "Please enter the group name "),
        "inputGroupName1":
            MessageLookupByLibrary.simpleMessage("Fill in a clear group name"),
        "inputInvitedCode": MessageLookupByLibrary.simpleMessage(
            "Please enter invitation code(Optional)"),
        "inputLoginAccount":
            MessageLookupByLibrary.simpleMessage("Please enter login account"),
        "inputMnemonic":
            MessageLookupByLibrary.simpleMessage("Please enter the mnemonic"),
        "inputMyGroupName": MessageLookupByLibrary.simpleMessage(
            "Please enter my nickname for group"),
        "inputNewPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter the new password"),
        "inputNickname":
            MessageLookupByLibrary.simpleMessage("Please enter user nickname"),
        "inputNickname1": MessageLookupByLibrary.simpleMessage(
            "Please enter 2-16 digit nickname"),
        "inputOldPassword":
            MessageLookupByLibrary.simpleMessage("Input Old Password"),
        "inputOriginalPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter the original password"),
        "inputPassword":
            MessageLookupByLibrary.simpleMessage("Please enter the password"),
        "insufficientBalance":
            MessageLookupByLibrary.simpleMessage("Insufficient Balance"),
        "introduced": MessageLookupByLibrary.simpleMessage("Introduced"),
        "introductionMoreThan": MessageLookupByLibrary.simpleMessage(
            "Introduction cannot be more than 100 characters"),
        "invitation": MessageLookupByLibrary.simpleMessage("Invitation"),
        "invitationRecord":
            MessageLookupByLibrary.simpleMessage("Invitation Record"),
        "invitationRewards":
            MessageLookupByLibrary.simpleMessage("Invitation Rewards"),
        "invitationTime":
            MessageLookupByLibrary.simpleMessage("Invitation Time"),
        "inviteFriends": MessageLookupByLibrary.simpleMessage("Invite"),
        "inviteNewUsers":
            MessageLookupByLibrary.simpleMessage("Invite New Users"),
        "invited": MessageLookupByLibrary.simpleMessage("Invited"),
        "invitedError": MessageLookupByLibrary.simpleMessage(
            "Wrong format of invitation code"),
        "invitedFail":
            MessageLookupByLibrary.simpleMessage("Invitation failed"),
        "invitedNewMember":
            MessageLookupByLibrary.simpleMessage("Invite new members"),
        "invitedSuccess":
            MessageLookupByLibrary.simpleMessage("Invitation successful"),
        "invitedUsers": MessageLookupByLibrary.simpleMessage("Invited Users"),
        "issue": MessageLookupByLibrary.simpleMessage("Issue"),
        "join": MessageLookupByLibrary.simpleMessage("Join"),
        "joinConfirmation":
            MessageLookupByLibrary.simpleMessage("Join confirmation"),
        "joinConfirmationTip": MessageLookupByLibrary.simpleMessage(
            "After enabled, joining users need to be confirmed by the administrator."),
        "joinGroup": MessageLookupByLibrary.simpleMessage("Join Group"),
        "joinGroupTip":
            MessageLookupByLibrary.simpleMessage("Confirm to join Group?"),
        "joinTogether": MessageLookupByLibrary.simpleMessage(
            "Join The World Of BeeChat Together!"),
        "jumpToUnread": MessageLookupByLibrary.simpleMessage("Jump to unread"),
        "knownUsers": MessageLookupByLibrary.simpleMessage("Known Users"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "lastVersion": MessageLookupByLibrary.simpleMessage("Latest Version"),
        "like": MessageLookupByLibrary.simpleMessage("Like"),
        "likeFailed": MessageLookupByLibrary.simpleMessage("Liked Fail"),
        "likeSuccess":
            MessageLookupByLibrary.simpleMessage("Liked Successfully"),
        "link": MessageLookupByLibrary.simpleMessage("Link"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "location": MessageLookupByLibrary.simpleMessage("Location"),
        "locationMessage":
            MessageLookupByLibrary.simpleMessage("Location message"),
        "logOutAccount":
            MessageLookupByLibrary.simpleMessage("Log Out Of Account"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginAccount": MessageLookupByLibrary.simpleMessage("Login account"),
        "loginAccountTip": MessageLookupByLibrary.simpleMessage(
            "The account number is 6-20 English or numbers or @#%."),
        "logout": MessageLookupByLibrary.simpleMessage("Log Out"),
        "logoutTips": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to log out?"),
        "look": MessageLookupByLibrary.simpleMessage("Look"),
        "lookForward":
            MessageLookupByLibrary.simpleMessage("Please look forward to"),
        "lookHistory": MessageLookupByLibrary.simpleMessage("History"),
        "luck": MessageLookupByLibrary.simpleMessage("Try Your Luck"),
        "market": MessageLookupByLibrary.simpleMessage("Market"),
        "market1": MessageLookupByLibrary.simpleMessage("Market"),
        "maskingMessage": MessageLookupByLibrary.simpleMessage("Masking"),
        "maxNumTip": MessageLookupByLibrary.simpleMessage(
            "Selected quantity cannot be greater than"),
        "meetingTitle": MessageLookupByLibrary.simpleMessage("BeeChat meeting"),
        "mergerMessage": MessageLookupByLibrary.simpleMessage("Merger message"),
        "message": MessageLookupByLibrary.simpleMessage("Message"),
        "message1": MessageLookupByLibrary.simpleMessage("message"),
        "messageAlertSounds":
            MessageLookupByLibrary.simpleMessage("Message Alert Sounds"),
        "messageNotDisturb":
            MessageLookupByLibrary.simpleMessage("Message not disturb"),
        "messageReminderMethod":
            MessageLookupByLibrary.simpleMessage("Message reminder"),
        "mine": MessageLookupByLibrary.simpleMessage("Mine"),
        "minute": MessageLookupByLibrary.simpleMessage("Minute"),
        "mnemonic": MessageLookupByLibrary.simpleMessage("Mnemonic"),
        "mnemonicCheckError": MessageLookupByLibrary.simpleMessage(
            "Mnemonic verification failed"),
        "mnemonicFindAccount":
            MessageLookupByLibrary.simpleMessage("Mnemonic find account"),
        "mnemonicTip": MessageLookupByLibrary.simpleMessage(
            "Please record the mnemonic words on paper and keep them properly"),
        "mnemonicTip1": MessageLookupByLibrary.simpleMessage(
            "Please select the words in the correct order"),
        "mnemonicTip2": MessageLookupByLibrary.simpleMessage(
            "Mnemonic words are used to retrieve passwords. If you skip them, you cannot retrieve them. You can set them in your personal center. Are you sure to skip?"),
        "mnemonicVerification":
            MessageLookupByLibrary.simpleMessage("Mnemonic verification"),
        "modifyPassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "moneyMuch": MessageLookupByLibrary.simpleMessage("Have A Good One"),
        "month": MessageLookupByLibrary.simpleMessage("Month"),
        "moreFriend": MessageLookupByLibrary.simpleMessage("More Friend"),
        "muteGroup": MessageLookupByLibrary.simpleMessage("Mute"),
        "muteGroupAll": MessageLookupByLibrary.simpleMessage("Mute all"),
        "muteGroupAllTip": MessageLookupByLibrary.simpleMessage(
            "After mute all member, only group owners and administrators are allowed to speak."),
        "muteGroupFailed":
            MessageLookupByLibrary.simpleMessage("Setting failed"),
        "muteGroupSuccess":
            MessageLookupByLibrary.simpleMessage("Setting successful"),
        "muteGroupTip": MessageLookupByLibrary.simpleMessage(
            "After the mute, the member will not be able to speak."),
        "muteSetting": MessageLookupByLibrary.simpleMessage("Mute setting"),
        "mutualFollow": MessageLookupByLibrary.simpleMessage("Mutual"),
        "myGroupName":
            MessageLookupByLibrary.simpleMessage("My Group nickname"),
        "myInvitationCode":
            MessageLookupByLibrary.simpleMessage("My Invitation Code"),
        "myVisit": MessageLookupByLibrary.simpleMessage("My Visit"),
        "newUserRegistration":
            MessageLookupByLibrary.simpleMessage("New User Registration"),
        "next": MessageLookupByLibrary.simpleMessage("Next step"),
        "nickname": MessageLookupByLibrary.simpleMessage("Nickname"),
        "nicknameTip": MessageLookupByLibrary.simpleMessage(
            "The user\'s nickname is 2-8 digits of Chinese, English, and numbers"),
        "noAccount": MessageLookupByLibrary.simpleMessage("No account,"),
        "noIntroduction":
            MessageLookupByLibrary.simpleMessage("No introduction..."),
        "noPermission": MessageLookupByLibrary.simpleMessage("No permission"),
        "noRemarks": MessageLookupByLibrary.simpleMessage("Not Remarks"),
        "notCommentTip": MessageLookupByLibrary.simpleMessage(
            "The user has set the permission to comment"),
        "notSave": MessageLookupByLibrary.simpleMessage("Not Save"),
        "notSet": MessageLookupByLibrary.simpleMessage("Not set"),
        "notShareTip": MessageLookupByLibrary.simpleMessage(
            "The user has set the permission to share"),
        "notShow": MessageLookupByLibrary.simpleMessage("Not Display"),
        "notSupportCollection": m1,
        "notice": MessageLookupByLibrary.simpleMessage("Notice"),
        "noticeTips": MessageLookupByLibrary.simpleMessage(
            "After turning it off, system notifications will not display message previews"),
        "notificationSettings": MessageLookupByLibrary.simpleMessage(
            "New Message Notification Settings"),
        "notificationSound": m2,
        "notificationsDisplayPreviews": MessageLookupByLibrary.simpleMessage(
            "Notifications Display Message Previews"),
        "nowUpdate": MessageLookupByLibrary.simpleMessage("Updated now"),
        "numFilesTotal": m3,
        "numberVisitors":
            MessageLookupByLibrary.simpleMessage("Number Visitors"),
        "observeWallet": MessageLookupByLibrary.simpleMessage("Observe Wallet"),
        "offline": MessageLookupByLibrary.simpleMessage("Offline"),
        "one": MessageLookupByLibrary.simpleMessage("Mon"),
        "online": MessageLookupByLibrary.simpleMessage("Online"),
        "onlyManagerChangeGroupName": MessageLookupByLibrary.simpleMessage(
            "Only group owners/administrators can modify group names"),
        "onlyReceive": MessageLookupByLibrary.simpleMessage("Only receive"),
        "optional": MessageLookupByLibrary.simpleMessage("Optional"),
        "other": MessageLookupByLibrary.simpleMessage("Other"),
        "otherAPPOpen": MessageLookupByLibrary.simpleMessage("Other Apps Open"),
        "otherAmounts": MessageLookupByLibrary.simpleMessage("Other Amounts"),
        "otherDuration": MessageLookupByLibrary.simpleMessage("Other"),
        "partialReturn": MessageLookupByLibrary.simpleMessage("Partial Return"),
        "participateDiscussions":
            MessageLookupByLibrary.simpleMessage("Discussions"),
        "passCoin": MessageLookupByLibrary.simpleMessage("Crypto Currency"),
        "password":
            MessageLookupByLibrary.simpleMessage("Please enter user nickname"),
        "passwordTip": MessageLookupByLibrary.simpleMessage(
            "The password requires 8-20 digits and consists of numbers and letters"),
        "payNow": MessageLookupByLibrary.simpleMessage("Pay now"),
        "permissions": MessageLookupByLibrary.simpleMessage("Permissions"),
        "picture": MessageLookupByLibrary.simpleMessage("Picture"),
        "pleaseEnterGoogleCode": MessageLookupByLibrary.simpleMessage(
            "Please Enter Google Verification Code"),
        "pleaseSelect": MessageLookupByLibrary.simpleMessage("please choose"),
        "pleasesInputWithdrawalAddress":
            MessageLookupByLibrary.simpleMessage("Please Enter"),
        "praise": MessageLookupByLibrary.simpleMessage("Praise"),
        "presentNumOnline": MessageLookupByLibrary.simpleMessage(" online"),
        "privateGroup": MessageLookupByLibrary.simpleMessage("Private group"),
        "prompt": MessageLookupByLibrary.simpleMessage("Prompt"),
        "publishDynamic": m4,
        "push": MessageLookupByLibrary.simpleMessage("Push"),
        "qrCard": MessageLookupByLibrary.simpleMessage("QR Code Card"),
        "qrCardTip": MessageLookupByLibrary.simpleMessage(
            "Scan the QR code above and add me as a friend"),
        "realNum": MessageLookupByLibrary.simpleMessage("Actual Receipt"),
        "received": MessageLookupByLibrary.simpleMessage("Received"),
        "receivingAccount":
            MessageLookupByLibrary.simpleMessage("Receiving Account"),
        "recentlyUsed": MessageLookupByLibrary.simpleMessage("Recently Used"),
        "recharge": MessageLookupByLibrary.simpleMessage("Recharge"),
        "rechargeAgain": MessageLookupByLibrary.simpleMessage("Recharge"),
        "rechargeAmount":
            MessageLookupByLibrary.simpleMessage("Recharge Amount"),
        "rechargeFailed": MessageLookupByLibrary.simpleMessage("Failed"),
        "rechargeRecord":
            MessageLookupByLibrary.simpleMessage("Recharge Record"),
        "recommendAPP": MessageLookupByLibrary.simpleMessage("Recommend APP"),
        "recommendToContacts":
            MessageLookupByLibrary.simpleMessage("Recommend To Contacts"),
        "recordYourLife": MessageLookupByLibrary.simpleMessage(
            "Record your life, because you are different from others."),
        "redBagNum":
            MessageLookupByLibrary.simpleMessage("Red Envelope Quantity"),
        "redBagRecords":
            MessageLookupByLibrary.simpleMessage("Red Envelope Records"),
        "redBagTitle":
            MessageLookupByLibrary.simpleMessage("Red Envelope Title"),
        "redBagTitleTip": MessageLookupByLibrary.simpleMessage("Please input"),
        "redBagType": MessageLookupByLibrary.simpleMessage("Red Envelope Type"),
        "redEnvelope": MessageLookupByLibrary.simpleMessage("Red Envelope"),
        "redEnvelopeMessage":
            MessageLookupByLibrary.simpleMessage("Red Envelope message"),
        "redEnvelopeTip":
            MessageLookupByLibrary.simpleMessage("Has been expired"),
        "redEnvelopeTip2":
            MessageLookupByLibrary.simpleMessage("Has been received"),
        "redEnvelopeTip3":
            MessageLookupByLibrary.simpleMessage("Have been collected"),
        "redEnvelopeTitle":
            MessageLookupByLibrary.simpleMessage("May fortune be with you"),
        "redSource": MessageLookupByLibrary.simpleMessage("Red Envelopes From"),
        "refundAmount": MessageLookupByLibrary.simpleMessage("Refund Amount"),
        "refuse": MessageLookupByLibrary.simpleMessage("Refuse"),
        "refused": MessageLookupByLibrary.simpleMessage("Refused"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registrationRewards":
            MessageLookupByLibrary.simpleMessage("Registration Rewards"),
        "rejected": MessageLookupByLibrary.simpleMessage("Rejected"),
        "remarks": MessageLookupByLibrary.simpleMessage("Remarks"),
        "remarksHintText":
            MessageLookupByLibrary.simpleMessage("Please enter a comment"),
        "remarksMoreThan":
            MessageLookupByLibrary.simpleMessage("Remarks cannot exceed 10"),
        "remindWhoWatch":
            MessageLookupByLibrary.simpleMessage("Remind Who To Watch"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "removeFavorites":
            MessageLookupByLibrary.simpleMessage("Not Collected"),
        "removeFavoritesFailed":
            MessageLookupByLibrary.simpleMessage("Failed to cancel collection"),
        "removeFavoritesSuccess": MessageLookupByLibrary.simpleMessage(
            "Cancel collection successfully"),
        "removeGroupMember":
            MessageLookupByLibrary.simpleMessage("Remove group members"),
        "removeGroupMemberFail": MessageLookupByLibrary.simpleMessage(
            "Failed to remove group members"),
        "removeGroupMemberSuccess": MessageLookupByLibrary.simpleMessage(
            "Remove group members successfully"),
        "removeGroupMemberTip": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to remove the selected group members?"),
        "reply": MessageLookupByLibrary.simpleMessage("Reply"),
        "requestNotice": MessageLookupByLibrary.simpleMessage("Request notice"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
        "reward": MessageLookupByLibrary.simpleMessage("Reward"),
        "rewardAmount": MessageLookupByLibrary.simpleMessage("Reward Amount"),
        "rewardImmediately":
            MessageLookupByLibrary.simpleMessage("Reward Immediately"),
        "rewardSuccessful":
            MessageLookupByLibrary.simpleMessage("Reward Successful"),
        "rewardTime": MessageLookupByLibrary.simpleMessage("Reward Time"),
        "rewardTo": MessageLookupByLibrary.simpleMessage("Reward To"),
        "riseList": MessageLookupByLibrary.simpleMessage("Rise list"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saveAlbumSuccessfully":
            MessageLookupByLibrary.simpleMessage("Save To Album Successfully"),
        "saveDraft": MessageLookupByLibrary.simpleMessage("Save Draft"),
        "saveFail": MessageLookupByLibrary.simpleMessage("Save failed"),
        "saved": MessageLookupByLibrary.simpleMessage("Saved"),
        "savedToAlbum": MessageLookupByLibrary.simpleMessage("Saved to album"),
        "scan": MessageLookupByLibrary.simpleMessage("Scan"),
        "scanQRCode": MessageLookupByLibrary.simpleMessage("Scan QR Code"),
        "scanRecharge":
            MessageLookupByLibrary.simpleMessage("Scan to recharge"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "searchFileName":
            MessageLookupByLibrary.simpleMessage("Search File Name"),
        "searchGroupChat":
            MessageLookupByLibrary.simpleMessage("Search group chats"),
        "searchHistory": MessageLookupByLibrary.simpleMessage("Search history"),
        "searchLinkName":
            MessageLookupByLibrary.simpleMessage("Search Link Name"),
        "searchName": MessageLookupByLibrary.simpleMessage("Search username"),
        "searchNicknameID": MessageLookupByLibrary.simpleMessage(
            "Search User Nickname Or User ID"),
        "searchSpecifiedContent":
            MessageLookupByLibrary.simpleMessage("Search for specific content"),
        "second": MessageLookupByLibrary.simpleMessage("Second"),
        "securityBinding":
            MessageLookupByLibrary.simpleMessage("Security And Binding"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Select All"),
        "selectCoin": MessageLookupByLibrary.simpleMessage("Choose Currency"),
        "selectCoinAddress":
            MessageLookupByLibrary.simpleMessage("Select Payment Address"),
        "selectDurationHotPost": MessageLookupByLibrary.simpleMessage(
            "Select the duration of the hot post"),
        "selectGroupAvatar": MessageLookupByLibrary.simpleMessage(
            "Please select a group avatar"),
        "selectReceivingAccount":
            MessageLookupByLibrary.simpleMessage("Select Receiving Account"),
        "selectTippingAmount":
            MessageLookupByLibrary.simpleMessage("Select The Tipping Amount"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sendFail":
            MessageLookupByLibrary.simpleMessage("Message sending failed"),
        "sendJoinFail": MessageLookupByLibrary.simpleMessage(
            "Failed to send request to join Group chats"),
        "sendJoinSuccess": MessageLookupByLibrary.simpleMessage(
            "The request to join Group chats was sent successfully"),
        "sendMessage": MessageLookupByLibrary.simpleMessage("Chat"),
        "sendRed": MessageLookupByLibrary.simpleMessage("Send Red Envelopes"),
        "sendRedBag":
            MessageLookupByLibrary.simpleMessage("Send Red Envelopes"),
        "sendRedBagTip": MessageLookupByLibrary.simpleMessage(
            "After 24 hours, the unclaimed portion of the token red envelope will be returned"),
        "sendTo": MessageLookupByLibrary.simpleMessage("Send To"),
        "setGroupManagers":
            MessageLookupByLibrary.simpleMessage("Set administrator"),
        "setGroupManagersTip": MessageLookupByLibrary.simpleMessage(
            "1. Administrators can assist group owners in managing Group chats and have the ability to invite new members and remove group members.\n2. Only the group owner has the ability to set up a group administrator. The ability to disband Group chats.\n3. Up to 5 administrators can be set up"),
        "setGroupManagersTip1": m5,
        "setTop": MessageLookupByLibrary.simpleMessage("top"),
        "setTop1": MessageLookupByLibrary.simpleMessage("set-top"),
        "setting": MessageLookupByLibrary.simpleMessage("Set"),
        "seven": MessageLookupByLibrary.simpleMessage("Sun"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "shareFailed": MessageLookupByLibrary.simpleMessage("Share Failed"),
        "shareGroup": MessageLookupByLibrary.simpleMessage("Share group"),
        "shareProhibited":
            MessageLookupByLibrary.simpleMessage("Share Prohibited"),
        "shareSuccess": MessageLookupByLibrary.simpleMessage("Share Success"),
        "six": MessageLookupByLibrary.simpleMessage("Sat"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "sort24HFall": MessageLookupByLibrary.simpleMessage("24H Fall"),
        "sort24HRise": MessageLookupByLibrary.simpleMessage("24H Rise"),
        "sort24HVolume": MessageLookupByLibrary.simpleMessage("24H Volume"),
        "sortName": MessageLookupByLibrary.simpleMessage("Name"),
        "sortPrice": MessageLookupByLibrary.simpleMessage("Price"),
        "soundMessage": MessageLookupByLibrary.simpleMessage("Sound message"),
        "soundReminders":
            MessageLookupByLibrary.simpleMessage("Sound Reminders"),
        "square": MessageLookupByLibrary.simpleMessage("Square"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "startChat": MessageLookupByLibrary.simpleMessage("Start chatting"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "systemMsg": MessageLookupByLibrary.simpleMessage("System message"),
        "systemSettings":
            MessageLookupByLibrary.simpleMessage("System Settings"),
        "text": MessageLookupByLibrary.simpleMessage("Text"),
        "text1": MessageLookupByLibrary.simpleMessage("Text"),
        "textMessage": MessageLookupByLibrary.simpleMessage("Text message"),
        "three": MessageLookupByLibrary.simpleMessage("Wed"),
        "timeBeingRewarded":
            MessageLookupByLibrary.simpleMessage("Time Being Rewarded"),
        "tip": MessageLookupByLibrary.simpleMessage("Prompt"),
        "toVerified": MessageLookupByLibrary.simpleMessage("To verify"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
        "totalPaid": MessageLookupByLibrary.simpleMessage("Total Paid"),
        "transfer": MessageLookupByLibrary.simpleMessage("Transfer"),
        "transferAgain": MessageLookupByLibrary.simpleMessage("Transfer"),
        "transferAmount": MessageLookupByLibrary.simpleMessage("Amount"),
        "transferCurrency":
            MessageLookupByLibrary.simpleMessage("Transfer Currency"),
        "transferFailed": MessageLookupByLibrary.simpleMessage("Failed"),
        "transferFee": MessageLookupByLibrary.simpleMessage("transfer Fee"),
        "transferFee2": MessageLookupByLibrary.simpleMessage("Fee"),
        "transferNum": MessageLookupByLibrary.simpleMessage("Transfer Amount"),
        "transferRecord":
            MessageLookupByLibrary.simpleMessage("Transfer Record"),
        "transferSuccess":
            MessageLookupByLibrary.simpleMessage("Transfer Success"),
        "transferTo": MessageLookupByLibrary.simpleMessage("To"),
        "transferable": MessageLookupByLibrary.simpleMessage("Transferable"),
        "two": MessageLookupByLibrary.simpleMessage("Tue"),
        "unfollowFailed":
            MessageLookupByLibrary.simpleMessage("Unsubscribed Fail"),
        "unfollowSuccess":
            MessageLookupByLibrary.simpleMessage("Unsubscribed Successfully"),
        "unfollowTip":
            MessageLookupByLibrary.simpleMessage("Do you want to unfollow?"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "uploadError": MessageLookupByLibrary.simpleMessage("Upload failed"),
        "uploadSignError":
            MessageLookupByLibrary.simpleMessage("Upload signature error"),
        "uploadSuccess":
            MessageLookupByLibrary.simpleMessage("Uploaded successfully"),
        "userAccountHintText":
            MessageLookupByLibrary.simpleMessage("Please enter the account"),
        "userInfo": MessageLookupByLibrary.simpleMessage("User info"),
        "userName": MessageLookupByLibrary.simpleMessage("User Name"),
        "userNickname": MessageLookupByLibrary.simpleMessage("User Nickname"),
        "verificationFailed":
            MessageLookupByLibrary.simpleMessage("Verification Failed"),
        "verificationFailedInsufficientBalance":
            MessageLookupByLibrary.simpleMessage(
                "Failed, insufficient balance"),
        "verified": MessageLookupByLibrary.simpleMessage("Verified"),
        "versionUpdate":
            MessageLookupByLibrary.simpleMessage("Version update:"),
        "vibrationReminders":
            MessageLookupByLibrary.simpleMessage("Vibration Reminders"),
        "video": MessageLookupByLibrary.simpleMessage("Video"),
        "videoMessage": MessageLookupByLibrary.simpleMessage("Video message"),
        "viewsRecord": MessageLookupByLibrary.simpleMessage("Views Record"),
        "vip": MessageLookupByLibrary.simpleMessage("VIP"),
        "vipTip": MessageLookupByLibrary.simpleMessage(
            "Enjoy 8 benefits when opening"),
        "visibleRange": MessageLookupByLibrary.simpleMessage("Visible Range"),
        "visibleRange1":
            MessageLookupByLibrary.simpleMessage("Visible to everyone"),
        "visibleRange2":
            MessageLookupByLibrary.simpleMessage("Visible only to home page"),
        "visibleRange2Tip": MessageLookupByLibrary.simpleMessage(
            "Others can only see it on your homepage"),
        "visibleRange3":
            MessageLookupByLibrary.simpleMessage("Visible only to strangers"),
        "visibleRange3Tip": MessageLookupByLibrary.simpleMessage(
            "All related friends and group members are invisible"),
        "visibleRange4":
            MessageLookupByLibrary.simpleMessage("Visible only to myself"),
        "visibleRange5": MessageLookupByLibrary.simpleMessage(
            "Visible only to dynamic square"),
        "visibleRange5Tip": MessageLookupByLibrary.simpleMessage(
            "Only visible in the dynamic square"),
        "visibleRange6":
            MessageLookupByLibrary.simpleMessage("Not visible to others"),
        "visibleRange6Tip": MessageLookupByLibrary.simpleMessage(
            "Not visible to specified users"),
        "visibleToEveryone":
            MessageLookupByLibrary.simpleMessage("Visible To Everyone"),
        "visitedYesterday":
            MessageLookupByLibrary.simpleMessage("Visited Yesterday"),
        "voice": MessageLookupByLibrary.simpleMessage("Voice"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("Voice message"),
        "waiteGet": MessageLookupByLibrary.simpleMessage("Unclaimed"),
        "waitingForConfirmation":
            MessageLookupByLibrary.simpleMessage("Confirming"),
        "waitingForReview": MessageLookupByLibrary.simpleMessage("IN Review"),
        "web3Wallet": MessageLookupByLibrary.simpleMessage("WEB3 Wallet"),
        "whereYou": MessageLookupByLibrary.simpleMessage("Where Are You"),
        "whoCanComment":
            MessageLookupByLibrary.simpleMessage("Who can comment on me"),
        "whoCanComment1":
            MessageLookupByLibrary.simpleMessage("Everyone can comment"),
        "whoCanComment2":
            MessageLookupByLibrary.simpleMessage("People I follow can comment"),
        "whoCanComment3": MessageLookupByLibrary.simpleMessage(
            "People who follow me can comment"),
        "whoCanComment4":
            MessageLookupByLibrary.simpleMessage("No one can comment"),
        "withdrawAgain": MessageLookupByLibrary.simpleMessage("Withdraw"),
        "withdrawal": MessageLookupByLibrary.simpleMessage("Withdrawal"),
        "withdrawalAddress":
            MessageLookupByLibrary.simpleMessage("Withdrawal Address"),
        "withdrawalAmount": MessageLookupByLibrary.simpleMessage("Amount"),
        "withdrawalCoinType":
            MessageLookupByLibrary.simpleMessage("Withdrawal Currency"),
        "withdrawalFailed": MessageLookupByLibrary.simpleMessage("Failed"),
        "withdrawalFee": MessageLookupByLibrary.simpleMessage("Withdrawal Fee"),
        "withdrawalFee2": MessageLookupByLibrary.simpleMessage("Fee"),
        "withdrawalNum":
            MessageLookupByLibrary.simpleMessage("Withdrawal Amount"),
        "withdrawalRange":
            MessageLookupByLibrary.simpleMessage("Withdrawal Range"),
        "withdrawalRecord":
            MessageLookupByLibrary.simpleMessage("Withdrawal Record"),
        "withdrawalSuccess":
            MessageLookupByLibrary.simpleMessage("Withdrawal Success"),
        "withdrawalTo": MessageLookupByLibrary.simpleMessage("To"),
        "year": MessageLookupByLibrary.simpleMessage("Year")
      };
}
