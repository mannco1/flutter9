import 'package:flutter/material.dart';
import 'package:pr_8/models/item.dart';
import 'package:pr_8/pages/info_page.dart';
import 'package:pr_8/server_api/server_api.dart';
class ItemUi extends StatefulWidget {
  const ItemUi({super.key, required this.game, required this.bodyColor, required this.textColor});
  final Item game;
  final Color bodyColor;
  final Color textColor;

  @override
  State<ItemUi> createState() => _ItemUiState();
}

class _ItemUiState extends State<ItemUi> {
  late Item game;

  @override
  void initState() {
    super.initState();
    game = widget.game;
  }
  Future<void> _updateFavoriteStatus(bool isFavorite) async {
    try {
      await ApiService().updateFavoriteStatus(game.id, isFavorite);
      setState(() {
        game.isFavorite = isFavorite;
      });
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205,
      width: 161,
      child: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          Container(
            width: 161,
            height: 115,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(image:  NetworkImage(
                  game.image,
                ),
                fit: BoxFit.cover
              )
            ),
          ),
          Positioned(
            top: 7.0,
            left: 7.0,
            child: SizedBox(
              width: 147,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: widget.bodyColor,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _updateFavoriteStatus(!game.isFavorite);
                    },
                    child: Icon(
                      game.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.bodyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 87.25,
            child: Container(
              height: 115,
              width: 161,
              decoration: BoxDecoration(
                color: widget.bodyColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      left: 5.0,
                      bottom: 5.0,
                    ),
                    child: SizedBox(
                      width: 140,
                      child: Center(
                        child: Text(game.title, style: TextStyle(
                          fontSize: 12,
                          color: widget.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 0,
                    decoration:
                    BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1.0,
                          color: widget.textColor,
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 8.0,
                        right: 8.0
                    ),
                    child: SizedBox(
                      width: 140,
                      child: Text(game.description ,
                        style: TextStyle(
                          fontSize: 8,
                          color: widget.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${game.price} ₽', style: TextStyle(
                          fontSize: 12,
                          color: widget.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => InfoPage(game: game),
                              ),
                            );
                          }, child: Text('Подробнее >>',
                          style: TextStyle(
                            fontSize: 10,
                            color: widget.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0,
                    bottom: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        await ApiService().addToBasket(game.id);
                      },
                      child: Container(
                        width: 150,
                        height: 19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: widget.textColor,
                              width: 2
                          )
                        ),
                        child: Center(
                          child: Text('Добавить в корзину',
                          style: TextStyle(
                            fontSize: 9,
                            color: widget.textColor,
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                      ),
                    )
                  )
                ],
              )
            )
          ),
        ],
      ),
    );
  }
}

