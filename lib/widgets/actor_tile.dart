import 'package:flutter/material.dart';
import 'package:movies/types/actor.dart';

class ActorTile extends StatelessWidget {
  final Actor _actor;
  const ActorTile(this._actor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
            child: Column(children: [
          _actor.profilePath.toString().isNotEmpty
              ? SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(_actor.profilePath, loadingBuilder:
                      (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }))
              : Container(width: 80, height: 80, color: Colors.black12),
          SizedBox(
            width: 50,
            height: 25,
            child: Text(_actor.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                maxLines: 2),
          )
        ]))
      ],
    );
  }
}
