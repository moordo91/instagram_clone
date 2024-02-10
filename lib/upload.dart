import 'package:flutter/material.dart';

class Upload extends StatelessWidget {
  const Upload({super.key, this.userImage});
  final userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('Upload page'),
          TextField(),
        ],
      ),
    );
  }
}
