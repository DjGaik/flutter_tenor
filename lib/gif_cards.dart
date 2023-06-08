import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifCards extends StatelessWidget {
  final String gifUrl;

  const GifCards(this.gifUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            fit: BoxFit.fill,
            image: NetworkImage(gifUrl),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Share.share(gifUrl);
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.star_outline,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
