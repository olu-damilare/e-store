# my_shop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
"# e-store" 

```json

{
    "data": [
        {
            "type": "hotel-offers",
            "hotel": {
                "type": "hotel",
                "hotelId": "HLLON101",
                "chainCode": "HL",
                "dupeId": "700027723",
                "name": "THE TRAFALGAR",
                "cityCode": "LON",
                "latitude": 51.50729,
                "longitude": -0.12889
            },
            "available": true,
            "offers": [
                {
                    "id": "FU5IWGRRMB",
                    "checkInDate": "2022-01-14",
                    "checkOutDate": "2022-01-15",
                    "rateCode": "RAC",
                    "rateFamilyEstimated": {
                        "code": "BAR",
                        "type": "P"
                    },
                    "commission": {
                        "percentage": "8.00"
                    },
                    "room": {
                        "type": "M1K",
                        "typeEstimated": {
                            "category": "STANDARD_ROOM",
                            "beds": 1,
                            "bedType": "KING"
                        },
                        "description": {
                            "text": "FLEXIBLE RATE\nTRAFALGAR KING ROOM\nCOMP WIFI/COFFEE-TEA FACILITIES/USB PORT",
                            "lang": "EN"
                        }
                    },
                    "guests": {
                        "adults": 1
                    },
                    "price": {
                        "currency": "GBP",
                        "base": "251.00",
                        "total": "251.00",
                        "taxes": [
                            {
                                "code": "TOTAL_TAX",
                                "amount": "0.00",
                                "currency": "GBP",
                                "included": true
                            }
                        ],
                        "variations": {
                            "average": {
                                "base": "251.00"
                            },
                            "changes": [
                                {
                                    "startDate": "2022-01-14",
                                    "endDate": "2022-01-15",
                                    "total": "251.00"
                                }
                            ]
                        }
                    },
                    "policies": {
                        "paymentType": "guarantee",
                        "cancellation": {
                            "deadline": "2022-01-13T23:59:00Z"
                        }
                    },
                    "self": "https://test.api.amadeus.com/v3/shopping/hotel-offers/FU5IWGRRMB"
                }
            ],
            "self": "https://test.api.amadeus.com/v3/shopping/hotel-offers?hotelIds=HLLON101&adults=1"
        }
    ]
}
```
