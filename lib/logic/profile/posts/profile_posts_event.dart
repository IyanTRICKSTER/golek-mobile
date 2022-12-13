part of 'profile_posts_bloc.dart';

abstract class ProfilePostEvent extends Equatable {
  const ProfilePostEvent();

  @override
  List<Object> get props => [];
}

class LoadProfilePostEvent extends ProfilePostEvent {}
