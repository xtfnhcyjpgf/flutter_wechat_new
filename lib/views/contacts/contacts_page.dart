import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/contacts_service.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/contacts/contacts_router.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/components/search_bar/search_bar.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  /// 联系人列表
  List<User> _contactsList = [];

  /// 悬浮view 高度 向上取整
  int _suspensionHeight =
      (ScreenUtil.getInstance().setHeight(99.0) as double).ceil();

  /// 每个item 高度 向上取整
  int _itemHeight =
      (ScreenUtil.getInstance().setHeight(168.0) as double).ceil();
  String _suspensionTag = "";

  /// 联系人总数
  String _contactsCount = '';

  /// 最后一个联系人
  User _lastContact;

  // 侧滑controller
  SlidableController _slidableController;
  // 是否展开
  bool _slideIsOpen = false;

  @override
  void initState() {
    super.initState();
    // 请求联系人
    _fetchContacts();
    // 配制数字居
    _slidableController = SlidableController(
      onSlideAnimationChanged: _handleSlideAnimationChanged,
      onSlideIsOpenChanged: _handleSlideIsOpenChanged,
    );
  }

  void _handleSlideAnimationChanged(Animation<double> slideAnimation) {
    // print('handleSlideAnimationChanged');
  }

  void _handleSlideIsOpenChanged(bool isOpen) {
    print('handleSlideIsOpenChanged $isOpen');
    setState(() {
      _slideIsOpen = isOpen;
    });
  }

  /// 请求联系人列表
  void _fetchContacts() async {
    List<User> list = [];
    if (ContactsService.sharedInstance.contactsList != null &&
        ContactsService.sharedInstance.contactsList.isNotEmpty) {
      list = ContactsService.sharedInstance.contactsList;
    } else {
      list = await ContactsService.sharedInstance.fetchContacts();
    }
    setState(() {
      _contactsList = list;
      _lastContact = list.last;
      _contactsCount = "${list.length}位联系人";
    });
  }

  /// 索引标签被点击
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  /// 构建头部
  Widget _buildHeader() {
    print('_buildHeader');
    return Column(
      children: <Widget>[
        SearchBar(),
        _buildItem(
          Constant.assetsImagesContacts + 'plugins_FriendNotify_36x36.png',
          '新的朋友',
          false,
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_addgroup_36x36.png',
          '群聊',
          false,
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'Contact_icon_ContactTag_36x36.png',
          '标签',
          false,
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_offical_36x36.png',
          '公众号',
          false,
        ),
      ],
    );
  }

  /// 构建悬浮部件
  Widget _buildSusWidget(String susTag, {bool isFloat = false}) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(51.0)),
      decoration: BoxDecoration(
        color: isFloat ? Colors.white : Style.pBackgroundColor,
        border: isFloat
            ? Border(bottom: BorderSide(color: Color(0xFFE6E6E6), width: 0.5))
            : null,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: ScreenUtil.getInstance().setSp(39.0),
          color: isFloat ? Style.pTintColor : Color(0xff777777),
        ),
      ),
    );
  }

  /// 构建列表项
  Widget _buildListItem(User user) {
    String susTag = user.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: user.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        Container(
          height: _itemHeight.toDouble(),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildItem(user.profileImageUrl, user.screenName, true,
                    needSlidable: true, onTap: (context0) {
                  print(
                      'onnnntap ${Slidable.of(context0)}    xxx  ${Slidable.of(context0)?.renderingMode} ');
                  // 下钻联系人信息
                  // _slideIsOpen
                  //     ? Slidable.of(context0)?.close()
                  //     : NavigatorUtils.push(context0,
                  //         '${ContactsRouter.contactInfoPage}?idstr=${user.idstr}');
                  Slidable.of(context0)?.renderingMode ==
                          SlidableRenderingMode.none
                      ? Slidable.of(context0)?.open()
                      : Slidable.of(context0)?.close();
                }),
              )
            ],
          ),
        ),
        Offstage(
          offstage: _lastContact.idstr != user.idstr,
          child: Container(
            width: double.infinity,
            height: ScreenUtil.getInstance().setHeight(150.0),
            alignment: Alignment.center,
            child: Text(
              _contactsCount,
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(48.0),
                  color: Style.sTextColor),
            ),
          ),
        ),
      ],
    );
  }

  /// 返回 item
  Widget _buildItem(
    String icon,
    String title,
    bool isNetwork, {
    void Function(BuildContext context) onTap,
    bool needSlidable = false,
  }) {
    final double iconWH = ScreenUtil.getInstance().setWidth(123.0);
    Widget leading = Padding(
        padding:
            EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(39.0)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: isNetwork
              ? CachedNetworkImage(
                  imageUrl: icon,
                  width: iconWH,
                  height: iconWH,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Image.asset(
                      Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                      width: iconWH,
                      height: iconWH,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                      width: iconWH,
                      height: iconWH,
                    );
                  },
                )
              : Image.asset(
                  icon,
                  width: iconWH,
                  height: iconWH,
                ),
        ));

    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Text(
        title,
        style: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(51.0),
            color: Style.pTextColor),
      ),
    );

    Widget listTile = MHListTile(
      dividerColor: Color(0xFFE6E6E6),
      onTapValue: onTap,
      allowTap: !_slideIsOpen,
      leading: leading,
      middle: middle,
      height: _itemHeight.toDouble(),
      dividerIndent: ScreenUtil.getInstance().setWidth(210.0),
    );

    // 不需要侧滑事件
    if (!needSlidable) {
      return listTile;
    }
    // 需要侧滑事件
    return Slidable(
      key: Key(title),
      controller: _slidableController,
      dismissal: SlidableDismissal(
        closeOnCanceled: true,
        dragDismissible: true,
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) {
          return false;
        },
      ),
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      child: listTile,
      secondaryActions: <Widget>[
        Container(
          color: Color(0xFFC7C7CB),
          child: Text(
            '备注',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getInstance().setSp(51.0),
              fontWeight: FontWeight.w400,
            ),
          ),
          alignment: Alignment.center,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通讯录'),
        actions: <Widget>[
          IconButton(
            icon: new SvgPicture.asset(
              Constant.assetsImagesContacts + 'icons_outlined_add-friends.svg',
              color: Color(0xFF333333),
            ),
            onPressed: () {
              NavigatorUtils.push(context, ContactsRouter.addFriendPage);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: AzListView(
                data: _contactsList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget:
                    _buildSusWidget(_suspensionTag, isFloat: true),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                header: AzListViewHeader(
                    // - [特殊字符](https://blog.csdn.net/cfxy666/article/details/87609526)
                    // - [特殊字符](http://www.fhdq.net/)
                    tag: "♀",
                    height: 5 * _itemHeight,
                    builder: (context) {
                      return _buildHeader();
                    }),
                indexHintBuilder: (context, hint) {
                  return Container(
                    alignment: Alignment.center,
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        color: Color(0xFFC7C7CB), shape: BoxShape.circle),
                    child: Text(hint,
                        style: TextStyle(color: Colors.white, fontSize: 30.0)),
                  );
                },
              )),
        ],
      ),
      // body: _buildList(context, Axis.horizontal),
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var user = _contactsList[index];
        return _buildItem(user.profileImageUrl, user.screenName, true,
            needSlidable: true, onTap: (context0) {
          print(
              'onnnntap ${Slidable.of(context0)}    xxx  ${Slidable.of(context0)?.renderingMode} ');
          // 下钻联系人信息
          // _slideIsOpen
          //     ? Slidable.of(context0)?.close()
          //     : NavigatorUtils.push(context0,
          //         '${ContactsRouter.contactInfoPage}?idstr=${user.idstr}');
          // Slidable.of(context0)?.renderingMode == SlidableRenderingMode.none
          //     ? Slidable.of(context0)?.open()
          //     : Slidable.of(context0)?.close();
        });
        // return VerticalListItem(user.screenName);
      },
      itemCount: _contactsList.length,
    );
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);
  final String item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(
            ' GestureDetector ooontap ${Slidable.of(context)?.renderingMode}');
        if (Slidable.of(context)?.renderingMode == SlidableRenderingMode.none) {
          Slidable.of(context)?.open(actionType: SlideActionType.primary);
          NavigatorUtils.push(context, ContactsRouter.addFriendPage);
        } else {
          Slidable.of(context)?.close();
        }
        //
      },
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Text('aa'),
            foregroundColor: Colors.white,
          ),
          title: Text(item),
        ),
      ),
    );
  }
}