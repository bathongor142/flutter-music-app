import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/components/custom_list_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  //Music List
  List musicList = [
    {
      'title': "Is It Hip-Hop",
      'singer': "Is It Hip-Hop",
      'url':
          "https://audio-previews.elements.envatousercontent.com/files/281404327/preview.mp3?response-content-disposition=attachment%3B+filename%3D%22GBUXGY3-is-it-hip-hop.mp3%22",
      "coverUrl": "https://afrobeat.co.za/download-mp3-music/twice-the-feels/",
    },
    {
      'title': "Nene",
      'singer': "Nana",
      'url':
          "https://audio-previews.elements.envatousercontent.com/files/281404327/preview.mp3?response-content-disposition=attachment%3B+filename%3D%22GBUXGY3-is-it-hip-hop.mp3%22",
      "coverUrl": "https://afrobeat.co.za/download-mp3-music/twice-the-feels/",
    },
    {
      'title': "Meme",
      'singer': "Meme",
      'url':
          "https://audio-previews.elements.envatousercontent.com/files/281404327/preview.mp3?response-content-disposition=attachment%3B+filename%3D%22GBUXGY3-is-it-hip-hop.mp3%22",
      "coverUrl": "https://afrobeat.co.za/download-mp3-music/twice-the-feels/",
    }
  ];
  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";
  IconData btnIcon = Icons.play_arrow;

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";
  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          btnIcon = Icons.play_arrow;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Playlist",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) => customListTile(
                      onTop: () {
                        playMusic(musicList[index]['url']);
                        setState(() {
                          currentTitle = musicList[index]['title'];
                          currentCover = musicList[index]['coverUrl'];
                          currentSinger = musicList[index]['singer'];
                        });
                      },
                      title: musicList[index]['title'],
                      singer: musicList[index]['singer'],
                      cover: musicList[index]['coverUrl'],
                    )),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color(0x55212121),
                blurRadius: 8.0,
              )
            ]),
            child: Column(
              children: [
                Slider.adaptive(
                  value: position.inSeconds.toDouble(),
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            image: DecorationImage(
                                image: NetworkImage(currentCover))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentTitle,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            currentSinger,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0),
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (isPlaying) {
                            audioPlayer.pause();
                            setState(() {
                              btnIcon = Icons.pause;
                              isPlaying = false;
                            });
                          } else {
                            audioPlayer.resume();
                            setState(() {
                              btnIcon = Icons.play_arrow;
                              isPlaying = true;
                            });
                          }
                        },
                        iconSize: 42.0,
                        icon: Icon(btnIcon),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
