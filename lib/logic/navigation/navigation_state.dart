part of 'navigation_cubit.dart';

abstract class NavigationState extends Equatable {
  final NavbarItem navbarItem;
  final int index;
  const NavigationState(this.navbarItem, this.index);

  @override
  List<Object> get props => [navbarItem, index];
}

class NavigationInitial extends NavigationState {
  const NavigationInitial(super.navbarItem, super.index);
}
