import 'package:d2shop_admin/src/components/view_image.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title, subtitle, imageUrl, leading;
  final Widget trailing;
  final Function onTap;

  const CustomCard(
      {this.imageUrl,
      this.onTap,
      this.subtitle,
      this.leading,
      @required this.title,
      @required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: imageUrl != null
            ? GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewImage(imageUrl),
                  ),
                ),
                child: Hero(
                  tag: imageUrl,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
              )
            : leading != null
                ? CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Center(
                      child: Text(
                        '$leading%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : null,
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
      ),
    );
  }
}
