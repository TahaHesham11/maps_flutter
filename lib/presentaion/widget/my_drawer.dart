import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_flutter/constants/my_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Widget buildDrawerHeader(context){
    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(50, 30, 70, 10),

          child: Image.asset(
            'assets/images/taha.JPG',
            width: 100,
            height: 120,

            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5,),
        Text(
          'Taha Hesham',
          maxLines: 1,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
        Text('01094127527',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        ),
      ],
    );

  }
  Widget buildDrawerListItem({
  required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  })
  {
   return ListTile(
    leading: Icon(leadingIcon,color: color?? MyColors.blue,),
     title: Text(title),
     trailing: trailing ??= Icon(Icons.arrow_right,color: MyColors.blue,),
     onTap: onTap,
   );

  }


  Widget buildDrawerListItemDivider(){

    return Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

  Future<void> launchUrl(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  Widget buildIcon(IconData icon , String url){

    return InkWell(
      onTap: (){
        launchUrl(url);
        },
      child: Icon(icon,color: MyColors.blue,size: 35,),

    );

  }

  Widget buildSocialMediaIcon(){
    return Padding(padding: EdgeInsetsDirectional.only(start: 16),
    child: Row(
      children: [
        buildIcon(
            FontAwesomeIcons.facebook,
            'https://www.facebook.com/?locale=ar_AR'),
        SizedBox(width: 15,),
        buildIcon(
            FontAwesomeIcons.youtube,
            'https://www.youtube.com/'),
        SizedBox(width: 20,),
        buildIcon(
            FontAwesomeIcons.telegram,
            'https://telegram.org/android'),
      ],
    ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 300,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[100],
              ),
              child: buildDrawerHeader(context),
            ),
          ),
          SizedBox(height: 50,),
          buildDrawerListItem(
              leadingIcon: Icons.person,
              title: 'My Profile'),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
              leadingIcon: Icons.history,
              title: 'Places History',
            onTap: (){},
          ),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
              leadingIcon: Icons.settings,
              title: 'Settings',
          ),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.help,
            title: 'Help',
          ),
          buildDrawerListItemDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.login,color: Colors.red,
            title: 'Logout',
          ),
          buildDrawerListItemDivider(),
          SizedBox(height: 50,),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(
                color: Colors.grey[600]
              ),
            ),
          ),
          buildSocialMediaIcon()

        ],
      ),
    );
  }
}
