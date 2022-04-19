// Implement the calls we need for the Scryfall database

import 'package:dio/dio.dart';
import 'package:mtg_collection_manager/data/network/entity/mtg_card_entity.dart';

class KoException implements Exception {
  final int statusCode;
  final String? message;

  const KoException({required this.statusCode, this.message});

  @override
  String toString() {
    return 'KoException: statusCode: $statusCode, message: ${message ?? 'No message specified'}';
  }
}

class ApiClient {
  final String baseUrl;
  final String apiKey;

  ApiClient({
    required this.baseUrl,
    required this.apiKey,
  });

  Future<MtgCardListResponse> getCardsByName(String cardName) async {
    cardName.replaceAll(' ', '+');
    // Scryfall uses percent encoding 
    var cardNameQuery = '%21 + $cardName';
    try {
      final response = await Dio().get(
        'https://api.scryfall.com/cards/search',
        queryParameters: {
          'order': 'released',
          'q': cardNameQuery,
          'include': '%3Aextras',
          'unique': 'prints',
        },
        options: Options(
          headers: {
            'X-RapidAPI-Host': baseUrl,
          },
        ),
      );

      if (response.data != null) {
        final data = response.data;

        return MtgCardListResponse.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Could not parse response.');
      }
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != null) {
        throw KoException(
          statusCode: e.response!.statusCode!,
          message: e.response!.data.toString(),
        );
      } else {
        throw Exception(e.message);
      }
    }
  }
}