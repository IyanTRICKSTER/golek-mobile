import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:golek_mobile/logic/navigation/navbar.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationInitial(NavbarItem.home, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(const NavigationInitial(NavbarItem.home, 0));
        break;
      case NavbarItem.camera:
        emit(const NavigationInitial(NavbarItem.camera, 1));
        break;
      case NavbarItem.search:
        emit(const NavigationInitial(NavbarItem.search, 2));
        break;
      case NavbarItem.profile:
        emit(const NavigationInitial(NavbarItem.profile, 3));
        break;
    }
  }
}
