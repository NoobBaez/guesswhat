import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

// ? Necesito terminar con el layaout de las descripciones.

class CostumDescription extends StatelessWidget {
  final String text;
  CostumDescription({this.text});

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Text('1000 Likes'),
      collapsed: Text(
        text,
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      expanded: Text(
        text,
        softWrap: true,
      ),
      tapHeaderToExpand: true,
      hasIcon: false,
    );
  }
}
