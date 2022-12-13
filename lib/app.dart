import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golek_mobile/injector/injector.dart';
import 'package:golek_mobile/logic/auth/auth_bloc.dart';
import 'package:golek_mobile/logic/bookmark/bookmark_bloc.dart';
import 'package:golek_mobile/logic/navigation/navigation_cubit.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';
import 'package:golek_mobile/ui/camera/camera.dart';
import 'package:golek_mobile/ui/confirmation.dart';
import 'package:golek_mobile/ui/create_post.dart';
import 'package:golek_mobile/ui/home.dart';
import 'package:golek_mobile/ui/login.dart';
import 'package:golek_mobile/ui/notification.dart';
import 'package:golek_mobile/ui/profile.dart';
import 'package:golek_mobile/ui/search.dart';

class App extends StatelessWidget {
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    bool? isAlreadyLoggedIn = _sharedPreferencesManager.isKeyExists(SharedPreferencesManager.keyIsLoggedIn)!
        ? _sharedPreferencesManager.getBool(SharedPreferencesManager.keyIsLoggedIn)
        : false;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => BookmarkBloc()..add(BookmarkRefreshEvent()),
        ),
        // BlocProvider(create: (context) => PostBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Golek',
        home: isAlreadyLoggedIn! ? const MainScreen() : LoginScreen(),
        // home: const CreatePostScreen(),
        navigatorKey: locator<NavigationService>().navigatorKey,
        routes: {
          '/login_screen': (context) => LoginScreen(),
          '/main_screen': (context) => const MainScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  final HomeScreen _homeScreen = const HomeScreen();
  final SearchScreen _searchScreen = const SearchScreen();
  final ProfileScreen _profileScreen = const ProfileScreen();
  final PageController pageController = PageController();
  int tabIndex = 0;

  void onPageChanged(int index) {
    if (index == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
        );
      });
      return;
    }
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildAppTitle() {
      return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 76,
                  height: 30,
                  decoration: const BoxDecoration(),
                  child: Image.asset("assets/images/logo.png"),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                        }),
                      },
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Color.fromARGB(221, 29, 28, 28),
                        size: 32,
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: ((context) {
                        return const [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text("Logout"),
                          ),
                        ];
                      }),
                      onSelected: ((value) {
                        if (value == 0) {
                          BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                          Navigator.pushNamedAndRemoveUntil(context, "/login_screen", (route) => false);
                        }
                      }),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    BottomNavigationBarItem buildHomeNavigationButtion() {
      return BottomNavigationBarItem(
          label: "",
          icon: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/home.png"))),
          ));
    }

    BottomNavigationBarItem buildCameraNavigationButton() {
      return BottomNavigationBarItem(
          label: "",
          icon: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/camera.png"))),
          ));
    }

    BottomNavigationBarItem buildSearchNavigationButton() {
      return BottomNavigationBarItem(
        label: "",
        icon: Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/search.png"))),
        ),
      );
    }

    BottomNavigationBarItem buildProfileNavigationButton() {
      return BottomNavigationBarItem(
          label: "",
          icon: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile.png"),
              ),
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: buildAppTitle(),
        foregroundColor: Colors.pink[800],
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xffDADADA),
                  width: 0.5,
                ),
              ),
            ),
            height: 62,
            child: BottomNavigationBar(
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              items: [
                buildHomeNavigationButtion(),
                buildCameraNavigationButton(),
                buildSearchNavigationButton(),
                buildProfileNavigationButton(),
              ],
              currentIndex: tabIndex,
              onTap: (index) {
                if (index == 1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraScreen(),
                      ),
                    );
                  });
                } else {
                  pageController.jumpToPage(index);
                }

                // if (index == 0) {
                //   BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.home);
                // } else if (index == 1) {
                //   BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.camera);
                // } else if (index == 2) {
                //   BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.search);
                // } else if (index == 3) {
                //   BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.profile);
                // }
              },
            ),
          );
        },
      ),
      // body: BlocBuilder<NavigationCubit, NavigationState>(
      //   builder: (context, state) {
      //     if (state.navbarItem == NavbarItem.home) {
      //       return _homeScreen;
      //     } else if (state.navbarItem == NavbarItem.camera) {
      //       WidgetsBinding.instance.addPostFrameCallback((_) {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const CameraPage(),
      //           ),
      //         );
      //       });
      //     } else if (state.navbarItem == NavbarItem.search) {
      //       return _searchScreen;
      //     } else if (state.navbarItem == NavbarItem.profile) {
      //       return _profileScreen;
      //     }

      //     BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.home);
      //     return Container();
      //   },
      // ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          _homeScreen,
          Container(),
          _searchScreen,
          _profileScreen,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConfirmationPostScreen(),
              ),
            );
          });
        },
        backgroundColor: const Color.fromRGBO(161, 20, 68, 1.0),
        child: const Icon(Icons.check_outlined),
      ),
    );
  }
}
