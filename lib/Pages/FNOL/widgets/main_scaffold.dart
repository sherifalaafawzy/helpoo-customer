import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Pages/FNOL/fnol_bloc.dart';


class MainScaffold extends StatelessWidget {
  final Widget scaffold;

  const MainScaffold({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FnolBloc, FnolState>(
      builder: (context, state) {
        return scaffold;
      },
    );
  }
}
