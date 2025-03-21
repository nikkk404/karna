import 'package:cygiene_ui/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:hackernews_api/hackernews_api.dart';

class BlogsView extends StatefulWidget {
  const BlogsView({Key? key}) : super(key: key);

  @override
  State<BlogsView> createState() => _BlogsViewState();
}

class _BlogsViewState extends State<BlogsView> {
  HackerNews news = HackerNews(
    newsType: NewsType.newStories,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        backgroundColor: primaryColor,
        title: const Text('Cyber News', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: news.getStories(),
              builder: (context, AsyncSnapshot<List<Story>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) return Text(snapshot.error.toString());
                if (!snapshot.hasData) return const Text('No Data');

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index];
                      var title = data.title;

                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),

    );

  }


}