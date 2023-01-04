import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:predictive_app/modules/app_container/app_container.dart';
import 'package:predictive_app/modules/home/home.dart';
import 'package:predictive_app/modules/tabs/app_tab.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AppTabs();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        // GoRoute(
        //   path: 'recovery',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const PasswordRecovery();
        //   },
        // ),
      ],
    ),
  ],
);
