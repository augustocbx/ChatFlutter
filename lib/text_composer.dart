import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Function({String text, File imgFile}) sendMessage;

  TextComposer(this.sendMessage);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = new TextEditingController();
  final picker = ImagePicker();
  File _image;
  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.camera);
                if (pickedFile == null) return;
                final imagePicker = File(pickedFile.path);
                widget.sendMessage(imgFile: imagePicker);

              }),
          Expanded(
              child: TextField(
                  controller: _controller,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Enviar uma mensagem'),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  onSubmitted: (text) {
                    widget.sendMessage(text: text);
                    _reset();
                  })),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing
                  ? () {
                      widget.sendMessage(text: _controller.text);
                      _reset();
                    }
                  : null)
        ],
      ),
    );
  }
}
