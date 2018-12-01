import 'package:chik_chak/chikchak_bloc.dart';
import 'package:flutter/material.dart';

// The View in a Stream-based architecture takes two arguments: The State Stream
// and the onTextChanged callback. In our case, the onTextChanged callback will
// emit the latest String to a Stream<String> whenever it is called.
//
// The State will use the Stream<String> to send new search requests to the
// GithubApi.
class ChikChakGame extends StatefulWidget {
  ChikChakGame({Key key}) : super(key: key);

  @override
  ChikChakGameState createState() => ChikChakGameState();
}

class ChikChakGameState extends State<ChikChakGame> {
  ChikChakBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ChikChakBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChikChakTile>>(
      stream: bloc.gameState,
      builder:
          (BuildContext context, AsyncSnapshot<List<ChikChakTile>> snapshot) {
        final _curState = snapshot.data;
        return GridView.count(
          crossAxisCount: 3,
          children: List.generate(9, (index) {
            return GestureDetector(
              child: Center(
                child: Text(
                  '${_curState[index]}',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              onTap: () {
                bloc.clicks.add(index);
              },
            );
          }),
        );
      },
    );
  }
}
