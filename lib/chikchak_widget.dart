import 'package:chik_chak/chikchak_bloc.dart';
import 'package:flutter/material.dart';

class ChikChakGame extends StatefulWidget {
  ChikChakGame({Key key}) : super(key: key);

  @override
  ChikChakGameState createState() => ChikChakGameState();
}

class ChikChakGameState extends State<ChikChakGame> {
  ChikChakBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChikChakBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChikChakTile>>(
      stream: _bloc.gameState,
      builder:
          (BuildContext context, AsyncSnapshot<List<ChikChakTile>> snapshot) {
        return Column(
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: GridView.count(
                crossAxisCount: 5,
                children: snapshot.data.map((tile) {
                  if (tile.visible) {
                    return GestureDetector(
                      onTap: () {
                        _bloc.clicks.add(tile.num);
                      },
                      child: Card(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${tile.num}',
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Current number: 7",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
