import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleiolapaz/core/ia/ia_impl.dart';
import 'package:googleiolapaz/page/principal/bloc/principal_bloc.dart';
import 'package:googleiolapaz/page/principal/screen/principal_screen.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrincipalBloc(
        ia: IAimpl(),
      ),
      child: BlocListener<PrincipalBloc, PrincipalState>(
        listener: (context, state) {},
        child: PrincipalScreen(),
      ),
    );
  }
}
