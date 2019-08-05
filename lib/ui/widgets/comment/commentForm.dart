import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/simple_line_icons.dart';
import 'package:guess_what/core/model/comment.dart';
import 'package:guess_what/core/model/guess.dart';
import 'package:guess_what/core/viewModel/commentViewModel.dart';

class CommentForm extends StatelessWidget {
  const CommentForm({
    Key key,
    @required GlobalKey<FormBuilderState> fbKey,
    @required this.model,
    @required this.guess,
  })  : _fbKey = fbKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _fbKey;
  final CommentViewModel model;
  final Guess guess;

  @override
  Widget build(BuildContext context) {
    var _focusNode = FocusNode();
    return Row(
      children: <Widget>[
        FormBuilder(
          key: _fbKey,
          child: Flexible(
            child: FormBuilderTextField(
              attribute: "comment",
              maxLines: 1,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                hintText: 'Enter a comment',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.zero),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.zero),
                  borderSide: BorderSide(color: Colors.white, width: 2.5),
                ),
              ),
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              maxLength: 350,
              maxLengthEnforced: true,
              validators: [
                FormBuilderValidators.required(
                    errorText: 'Your comment cannot be empty'),
                FormBuilderValidators.max(350),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            SimpleLineIcons.getIconData('paper-plane'),
            color: Colors.white,
          ),
          onPressed: () {
            _fbKey.currentState.save();
            if (_fbKey.currentState.validate()) {
              Comment newComment = Comment(
                text: _fbKey.currentState.value['comment'],
                creationDate: Timestamp.now(),
              );

              model.uploadComment(comment: newComment, guessID: guess.id);

              _fbKey.currentState.reset();
              model.scrollBotton();
            }
          },
        ),
      ],
    );
  }
}