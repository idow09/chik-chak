import 'package:bquick/bquick_bloc.dart';
import 'package:flutter/material.dart';

class BQuickGame extends StatelessWidget {
  final BQuickBloc _bloc;

  const BQuickGame(this._bloc, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Dashboard(_bloc),
            ),
            Expanded(child: BQuickGrid(_bloc)),
          ],
        ),
        StatusTile(_bloc),
        Positioned(
          bottom: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
                stream: _bloc.gameStatus,
                builder:
                    (BuildContext context, AsyncSnapshot<GameStatus> snapshot) {
                  if (snapshot.data == GameStatus.running) {
                    return Tile(
                      color: Theme.of(context).accentColor,
                      child: StreamBuilder(
                        stream: _bloc.curNum,
                        builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) =>
                            Text(
                              "# ${snapshot.data}",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 25),
                            ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        )
      ],
    );
  }
}

class Dashboard extends StatelessWidget {
  final _bloc;

  const Dashboard(this._bloc, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: _bloc.highScore,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_upward),
                  ),
                  Text(
                    "${snapshot.data}",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: _bloc.curStopwatch,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.timer),
                  ),
                  Text(
                    "${snapshot.data}",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class StatusTile extends StatelessWidget {
  final _bloc;

  const StatusTile(this._bloc, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.gameStatus,
      builder: (BuildContext context, AsyncSnapshot<GameStatus> snapshot) {
        if (snapshot.data == GameStatus.finished) {
          return Center(
            child: Tile(
                child: Column(
              children: <Widget>[
                Icon(
                  Icons.check,
                  size: 150,
                ),
                StreamBuilder(
                  stream: _bloc.curStopwatch,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) =>
                          Text(
                            "${snapshot.data}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25),
                          ),
                ),
              ],
            )),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class BQuickGrid extends StatelessWidget {
  final _bloc;

  const BQuickGrid(this._bloc, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.gameState,
        builder:
            (BuildContext context, AsyncSnapshot<List<BQuickTile>> snapshot) {
          return GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: BQuickBloc.WIDTH,
            children: snapshot.data.map((tile) {
              if (tile.visible) {
                return GestureDetector(
                  onTap: () {
                    _bloc.clicks.add(tile.num);
                  },
                  child: Tile(child: Text('${tile.num}')),
                );
              } else {
                return Container();
              }
            }).toList(),
          );
        });
  }
}

class Tile extends StatelessWidget {
  final child;
  final color;

  const Tile({this.child, this.color, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color != null ? color : Theme.of(context).cardColor,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
