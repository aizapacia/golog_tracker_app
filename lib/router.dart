// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/auth/login.dart';
import 'package:tracker/auth/otp_screen.dart';
import 'package:tracker/pages/home.dart';
import 'package:tracker/pages/profile.dart';
import 'package:tracker/pages/search.dart';
import 'package:tracker/pages/support.dart';
import 'package:tracker/pages/trackerPage/specificpage.dart';
import 'package:tracker/pages/tracker_main.dart';
import 'package:tracker/pages/welcome.dart';

import 'login_cubit.dart';
import 'login_state.dart';

class AppRouter {
  final LoginCubit loginCubit;
  AppRouter(this.loginCubit);

  late final GoRouter router = GoRouter(
    //debugLogDiagnostics: true,
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (context, state) {
          return const LoginScreen();
        },
        routes: [
          GoRoute(
            path: 'verify',
            name: 'Verify',
            builder: (context, state) {
              return const OtpScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/',
        name: 'Home',
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
            path: 'contactsupport',
            name: 'ContactSupport',
            builder: (context, state) {
              return const ContactSupportScreen();
            },
          ),
          GoRoute(
              path: 'ordertracker',
              name: 'OrderTracker',
              builder: (context, state) {
                return const TrackerMainScreen();
              },
              routes: [
                GoRoute(
                  path: ':status/:id',
                  name: 'SpecificOrder',
                  builder: (context, state) {
                    return SpecificOrderPage(
                        id: int.parse(state.params['id'].toString()),
                        status: int.parse(state.params['status'].toString()));
                  },
                ),
              ]),
          GoRoute(
            path: 'profile',
            name: 'Profile',
            builder: (context, state) {
              return const ProfileScreen();
            },
          ),
          GoRoute(
            path: 'search',
            name: 'Search',
            builder: (context, state) {
              return const SearchPage();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/welcome',
        name: 'Welcome',
        builder: (context, state) {
          return const WelcomeScreen();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      //Check if user is logged in
      final bool loggedIn = loginCubit.state.status == AuthStatus.authenticated;
      //Check if the user is in log in page
      final bool loggingIn = state.subloc == '/login';

      //IF NOT AUTHENTICATED -> REDIRECT TO LOGIN PAGE
      if (loggedIn == false) {
        switch (state.subloc) {
          case '/welcome':
          case '/login':
          case '/login/verify':
            return null;
            break;
          default:
            return '/login';
            break;
        }
      }
      //IF AUTHENTICATED -> REDIRECT TO HOME PAGE
      if (loggingIn == true) {
        return '/';
      }
      return null;
    },
  );
}
