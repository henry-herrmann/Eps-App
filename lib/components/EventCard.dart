import 'package:event_planner/pages/EventView.dart';
import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final int eventid;
  final String eventname;
  final String description;
  final int date;
  final bool joined;
  final String type;
  final PageController controller;

  const EventCard(this.eventid, this.eventname, this.description, this.date, this.joined, this.type, this.controller, {Key? key}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {

    var startDate = DateTime.fromMillisecondsSinceEpoch(widget.date);

    var startDateString = startDate.day.toString() + "." + startDate.month.toString() + "." + startDate.year.toString() + " " + startDate.hour.toString() + ":" + (startDate.minute < 10 ? startDate.minute.toString() + "0" : startDate.minute.toString());

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventView(widget.eventid, widget.eventname, widget.description, widget.date, widget.joined, widget.type, widget.controller)));
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: Container(
                height: 125,
                width: MediaQuery.of(context).size.width-50,
                margin: const EdgeInsets.only(left: 10),
                decoration: widget.type == "Pflicht" ? BoxDecoration(
                    border: Border(
                      right: BorderSide( //                   <--- right side
                        color: Colors.orange,
                        width: 10,
                      ),
                    )
                ) : null,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(left: 1, top: 4, bottom: 5),
                              child: Text(widget.eventname, style: const TextStyle( fontSize: 15,fontWeight: FontWeight.bold))
                          ),
                          Icon(widget.joined ? Icons.check : Icons.clear, color: widget.joined ? Colors.green : Colors.red,),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.date_range_outlined,),
                          Padding(
                              padding: const EdgeInsets.only(left: 3, top: 2),
                              child: Text(startDateString, style: const TextStyle( fontSize: 14))
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.chat_bubble_outline_outlined),
                          Padding(
                              padding: const EdgeInsets.only(left: 1, top: 4),
                              child: Text(widget.description.length > 40 ? widget.description.substring(1, 36) + "..." : widget.description, style: const TextStyle( fontSize: 14,))
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.info_outline,),
                          Padding(
                              padding: const EdgeInsets.only(left: 1, top: 4),
                              child: Text(widget.type, style: const TextStyle( fontSize: 14,))
                          ),
                        ],
                      )
                    ],
                  ),
                )
            )
          )
      )
    );

  }
}
