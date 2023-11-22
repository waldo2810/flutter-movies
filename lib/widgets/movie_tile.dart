import 'package:flutter/material.dart';
import 'package:movies/types/movie.dart';

class MovieTile extends StatefulWidget {
  final Movie _movie;

  const MovieTile(this._movie,{super.key});

  @override
  State createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child:Card(
        child:InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/detail", arguments: <String,dynamic>{
              'id': widget._movie.id,
              'title': widget._movie.title,
              'posterPath': widget._movie.posterPath,
              'backdropPath': widget._movie.backdropPath,
              'voteAvg': widget._movie.voteAvg
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child:  widget._movie.posterPath.toString().contains("null")?
                      Container(
                        height: 80,
                        width: 80,
                        color: Colors.blueGrey,
                      ) :
                        SizedBox(
                          width: 80,
                          height: 120,
                          child: Image.network(
                            widget._movie.posterPath,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if(loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:loadingProgress.expectedTotalBytes != null ? 
                                  loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                                ),
                              );
                            } ,
                          ), 
                        )
                    )
                  ),
                  Expanded(flex:8,child: 
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:[
                          Text(
                            widget._movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, 
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:10),
                            child: Row(
                              children: [
                                const Icon(Icons.star,color: Colors.yellow),
                                Text(widget._movie.voteAvg.toString(), style: const TextStyle(fontSize: 16))
                              ]
                            ),
                          )
                        ]
                      )
                    ))
                  ]
                ),
              ),
            ]
          )
        )
      )
    );
  }
}
