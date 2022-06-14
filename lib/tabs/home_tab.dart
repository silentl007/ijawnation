import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:ijawnation/blocs/featured_bloc.dart';
import 'package:ijawnation/blocs/latest_articles_bloc.dart';
import 'package:ijawnation/blocs/popular_articles_bloc.dart';
import 'package:ijawnation/blocs/tab_index_bloc.dart';
import 'package:ijawnation/config/wp_config.dart';
import 'package:ijawnation/pages/notifications.dart';
import 'package:ijawnation/pages/search.dart';
import 'package:ijawnation/services/app_service.dart';
import 'package:ijawnation/utils/next_screen.dart';
import 'package:ijawnation/widgets/drawer.dart';
import 'package:ijawnation/widgets/tab_medium.dart';
import '../config/config.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {


  late TabController _tabController ;
  final scaffoldKey = GlobalKey<ScaffoldState>();

    List<Tab> _tabs = [
    Tab(
      text: "explore".tr(),
    ),
    Tab(
      text: WpConfig.selectedCategories['1'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['2'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['3'][1],
    ),
    Tab(
      text: WpConfig.selectedCategories['4'][1],
    ),
  ];



  _fetchData () async{
    await AppService().checkInternet().then((bool? hasInternet){
      if(hasInternet != null && hasInternet == true){
        context.read<FeaturedBloc>().fetchData();
        context.read<PopularArticlesBloc>().fetchData();
        context.read<LatestArticlesBloc>().fetchData();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, initialIndex: 0, vsync: this);
    _tabController.addListener(() { 
      context.read<TabIndexBloc>().setTabIndex(_tabController.index);
    });
    _fetchData();
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  

  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

        drawer: CustomDrawer(),
        key: scaffoldKey,
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 0,
              title: Image(image: AssetImage(Config.logo,), height: 60,),
              leading: IconButton(
                icon: Icon(
                  Feather.menu,
                  size: 25,
                ),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
              elevation: 1,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    AntDesign.search1,
                    size: 22,
                  ),
                  onPressed: () {
                    nextScreen(context, SearchPage());
                  },
                ),

                SizedBox(width: 3),

                IconButton(
                padding: EdgeInsets.only(right: 8),
                constraints: BoxConstraints(),
                icon: Icon(
                  AntDesign.bells,
                  size: 20,
                ),
                onPressed: () => nextScreen(context, Notifications()),
              ),
                SizedBox(
                  width: 10,
                )
              ],
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                labelStyle: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.red,
                unselectedLabelColor: Color(0xFF1E0F4F), //niceish grey
                isScrollable: true,
                indicator: MD2Indicator(
                  indicatorHeight: 3,
                  indicatorColor: Colors.red,
                  indicatorSize: MD2IndicatorSize.normal,
                ),
                tabs: _tabs,
              ),
            ),
          ];
        }, 
        
        body: Builder(
          builder: (BuildContext context) {
            final innerScrollController = PrimaryScrollController.of(context);
            return TabMedium(
              sc: innerScrollController!,
              tc: _tabController,
              scaffoldKey: scaffoldKey,
            );
          },
        )
      ),
      );
  }

  @override
  bool get wantKeepAlive => true;
}

