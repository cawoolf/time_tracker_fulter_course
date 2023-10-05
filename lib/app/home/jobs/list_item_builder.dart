import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {super.key, required this.snapshot, required this.itemBuilder});
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;

      // List has data, build a list of Jobs
      if (items!.isNotEmpty) {
        return _buildList(items);
      }

      // If the list is empty and has no data, return a placeholder
      else {
        return const EmptyContent(
            title: 'Nothing here', message: 'Add a new item to get started.');
      }
    }

    // If the there is an Error, return this placeholder
    else if (snapshot.hasError) {
      print(snapshot.error.toString());
      return const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }

    // If the list data is still loading, return a loading screen
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated( // Special ListView constructor for adding Dividers between the Items
      itemCount: items.length + 2, // Trick for adding lines with Containers above the first and Below the last Item.
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 0.5,
      ),
      itemBuilder: (context, index) { // Trick for adding lines with Containers above the first and Below the last Item. See 317.
        if(index == 0 || index == items.length +1){
          return Container();
        }
        return itemBuilder(context, items[index -1]);},
    );
  }
}
