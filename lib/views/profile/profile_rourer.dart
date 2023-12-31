import 'package:fluro/fluro.dart';
import 'package:flutter_wechat/routers/router_init.dart';

import 'package:flutter_wechat/views/profile/setting/setting_page.dart';
import 'package:flutter_wechat/views/profile/about_us/about_us_page.dart';
import 'package:flutter_wechat/views/profile/account_security/account_security_page.dart';
import 'package:flutter_wechat/views/profile/general/general_page.dart';
import 'package:flutter_wechat/views/profile/message_notify/message_notify_page.dart';
import 'package:flutter_wechat/views/profile/privates/privates_page.dart';
import 'package:flutter_wechat/views/profile/more_security_setting/more_security_setting_page.dart';
import 'package:flutter_wechat/views/profile/chat_background/chat_background_page.dart';
import 'package:flutter_wechat/views/profile/discover_manager/discover_manager_page.dart';
import 'package:flutter_wechat/views/profile/resource/resource_page.dart';
import 'package:flutter_wechat/views/profile/chat_record_backup/chat_record_backup.dart';
import 'package:flutter_wechat/views/profile/binding_mailbox/binding_mailbox_page.dart';
import 'package:flutter_wechat/views/profile/add_way/add_way_page.dart';
import 'package:flutter_wechat/views/profile/check_scope/check_scope_page.dart';
import 'package:flutter_wechat/views/profile/user_info/user_info_page.dart';
import 'package:flutter_wechat/views/profile/more_info/more_info_page.dart';
import 'package:flutter_wechat/views/profile/setting_gender/setting_gender_page.dart';
import 'package:flutter_wechat/views/profile/signature/signature_page.dart';

import 'profile_page.dart';

class ProfileRouter implements IRouterProvider {
  /// 我root页
  static String profilePage = "/profile";

  /// 设置
  static String settingPage = "/profile/setting";

  /// 关于微信
  static String aboutUsPage = "/profile/about-us";

  /// 账号与安全
  static String accountSecurityPage = "/profile/account-security";

  /// 新消息通知
  static String messageNotifyPage = "/profile/message-notify";

  /// 隐私
  static String privatesPage = "/profile/privates";

  /// 通用
  static String generalPage = "/profile/general";

  /// 更多安全设置
  static String moreSecuritySettingPage = "/profile/more-security-setting";

  /// 聊天背景
  static String chatBackgroundPage = "/profile/chat-background";

  /// 照片、视频和文件
  static String resourcePage = "/profile/resource";

  /// 发现页管理
  static String discoverManagerPage = "/profile/discover-manager";

  /// 聊天记录备份与迁移
  static String chatRecordBackupPage = "/profile/chat-record-backup";

  /// 绑定邮箱
  static String bindingMailboxPage = "/profile/binding-mailbox";

  /// 添加我的方式
  static String addWayPage = "/profile/add-way";

  /// 允许朋友查看朋友圈的范围
  static String checkScopePage = "/profile/check-scope";

  /// 用户信息
  static String userInfoPage = "/profile/user-info";

  /// 更多信息
  static String moreInfoPage = "/profile/more-info";

  /// 设置性别
  static String settingGenderPage = "/profile/setting-gender";

  /// 个性签名
  static String signaturePage = "/profile/signature";

  /// 重写
  @override
  void initRouter(Router router) {
    // 我root页
    router.define(
      profilePage,
      handler: Handler(handlerFunc: (_, params) => ProfilePage()),
    );
    // 设置
    router.define(
      settingPage,
      handler: Handler(handlerFunc: (_, params) => SettingPage()),
    );
    // 关于微信
    router.define(
      aboutUsPage,
      handler: Handler(handlerFunc: (_, params) => AboutUsPage()),
    );
    // 账号与安全
    router.define(
      accountSecurityPage,
      handler: Handler(handlerFunc: (_, params) => AccountSecurityPage()),
    );
    // 新消息通知
    router.define(
      messageNotifyPage,
      handler: Handler(handlerFunc: (_, params) => MessageNotifyPage()),
    );
    // 隐私
    router.define(
      privatesPage,
      handler: Handler(handlerFunc: (_, params) => PrivatesPage()),
    );
    // 通用
    router.define(
      generalPage,
      handler: Handler(handlerFunc: (_, params) => GeneralPage()),
    );
    // 更多安全设置
    router.define(
      moreSecuritySettingPage,
      handler: Handler(handlerFunc: (_, params) => MoreSecuritySettingPage()),
    );
    // 聊天背景
    router.define(
      chatBackgroundPage,
      handler: Handler(handlerFunc: (_, params) => ChatBackgroundPage()),
    );
    // 照片、视频和文件
    router.define(
      resourcePage,
      handler: Handler(handlerFunc: (_, params) => ResourcePage()),
    );

    // 发现页管理
    router.define(
      discoverManagerPage,
      handler: Handler(handlerFunc: (_, params) => DiscoverManagerPage()),
    );

    // 聊天记录备份与迁移
    router.define(
      chatRecordBackupPage,
      handler: Handler(handlerFunc: (_, params) => ChatRecordBackupPage()),
    );

    // 绑定邮箱
    router.define(
      bindingMailboxPage,
      handler: Handler(handlerFunc: (_, params) => BindingMailboxPage()),
    );

    // 添加方式
    router.define(
      addWayPage,
      handler: Handler(handlerFunc: (_, params) => AddWayPage()),
    );
    // 允许朋友查看朋友圈的范围
    router.define(
      checkScopePage,
      handler: Handler(handlerFunc: (_, params) {
        final String value = params['value']?.first;
        return CheckScopePage(value: value);
      }),
    );

    // 用户信息
    router.define(
      userInfoPage,
      handler: Handler(handlerFunc: (_, params) => UserInfoPage()),
    );

    // 更多信息
    router.define(
      moreInfoPage,
      handler: Handler(handlerFunc: (_, params) => MoreInfoPage()),
    );

    // 设置性别
    router.define(
      settingGenderPage,
      handler: Handler(handlerFunc: (_, params) {
        final String value = params['value']?.first;
        return SettingGenderPage(value: value);
      }),
    );

    // 个性签名
    router.define(
      signaturePage,
      handler: Handler(handlerFunc: (_, params) {
        final String text = params['text']?.first;
        return SignaturePage(text: text);
      }),
    );
  }
}
