/**
 * Created by hayle on 2022-09-20.
 */

public with sharing class AladinApiController {

        public static void getBookInfo_1(){

            String BASE_URL_BeforeQuery = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbtrstyq0151001&Query=';
            String BASE_URL_AfterQuery = '&Sort=PublishTime&QueryType=Title&MaxResults=50&start=1&Cover=Big&SearchTarget=Book&output=JS&Version=20131101';

            List<Book__c> ListBooks = [SELECT Id, Name, Volume__c, Type__c FROM Book__c WHERE f_Order__c  >= 1 and f_Order__c < 20];
            List<BookByVolume__c> ListBookByVolume = new List<BookByVolume__c>();
            Integer i = 1;

            for(Book__c LB : ListBooks){

                String searchWord = LB.Name;

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(BASE_URL_BeforeQuery + EncodingUtil.urlEncode(searchWord,'UTF-8') + BASE_URL_AfterQuery);
                request.setMethod('GET');
                HttpResponse response = http.send(request);

                List<Object> Books = new List<Object>();
                Object Book;
                Integer price;


                if (response.getStatusCode() == 200) {

                    Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Books = (List<Object>) responseBooks.get('item');

                    System.debug(Books);

                    if(Books.isEmpty()){
                        LB.HasNoResult__c = true;
                        update LB;
                    }else{
                        for(Object objectBook : Books){

                            Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectBook));

                            BookByVolume__c BookByVolume = new BookByVolume__c();
                            BookByVolume.Name = (String) result1.get('title');
                            BookByVolume.ISBN13__c = (String) result1.get('isbn13');
                            price = (Integer) result1.get('priceSales');
                            BookByVolume.Price__c = String.valueOf(price);
                            BookByVolume.Cover__c = (String) result1.get('cover');
                            BookByVolume.Book__c = LB.Id;
                            // BookByVolume.Volume__c = BookByVolume.Name.remove(LB.Name).substring(1,3).trim();
                            ListBookByVolume.add(BookByVolume);
                        }

                    }
                }
            }

            insert ListBookByVolume;
        }

        public static void getBookInfo_2(){

            String BASE_URL_BeforeQuery = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbtrstyq0151001&Query=';
            String BASE_URL_AfterQuery = '&QueryType=Title&MaxResults=50&start=1&Cover=Big&SearchTarget=Book&output=JS&Version=20131101';


            List<Book__c> ListBooks = [SELECT Id, Name, Volume__c, Type__c From Book__c where f_Order__c  >= 60 and f_Order__c < 120];
            List<BookByVolume__c> ListBookByVolume = new List<BookByVolume__c>();

            for(Book__c LB : ListBooks){

                String searchWord = LB.Name;

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(BASE_URL_BeforeQuery + searchWord.replace(' ','%20') + BASE_URL_AfterQuery);
                request.setMethod('GET');
                HttpResponse response = http.send(request);

                List<Object> Books = new List<Object>();
                Object Book;
                Integer price;


                if (response.getStatusCode() == 200) {

                    Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Books = (List<Object>) responseBooks.get('item');

                    for(Object objectBook : Books){

                        Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectBook));

                        BookByVolume__c BookByVolume = new BookByVolume__c();
                        BookByVolume.Name = (String) result1.get('title');
                        BookByVolume.ISBN13__c = (String) result1.get('isbn13');
                        price = (Integer) result1.get('priceSales');
                        BookByVolume.Price__c = String.valueOf(price);
                        BookByVolume.Cover__c = (String) result1.get('cover');
                        BookByVolume.Book__c = LB.Id;
                        ListBookByVolume.add(BookByVolume);
                    }
                }
            }

            insert ListBookByVolume;
        }

        public static void getBookInfo_3(){

            String BASE_URL_BeforeQuery = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbtrstyq0151001&Query=';
            String BASE_URL_AfterQuery = '&QueryType=Title&MaxResults=50&start=1&Cover=Big&SearchTarget=Book&output=JS&Version=20131101';


            List<Book__c> ListBooks = [SELECT Id, Name, Volume__c, Type__c From Book__c where f_Order__c  >= 120 and f_Order__c < 180];
            List<BookByVolume__c> ListBookByVolume = new List<BookByVolume__c>();

            for(Book__c LB : ListBooks){

                String searchWord = LB.Name;

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(BASE_URL_BeforeQuery + searchWord.replace(' ','%20') + BASE_URL_AfterQuery);
                request.setMethod('GET');
                HttpResponse response = http.send(request);

                List<Object> Books = new List<Object>();
                Object Book;
                Integer price;


                if (response.getStatusCode() == 200) {

                    Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Books = (List<Object>) responseBooks.get('item');

                    for(Object objectBook : Books){

                        Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectBook));

                        BookByVolume__c BookByVolume = new BookByVolume__c();
                        BookByVolume.Name = (String) result1.get('title');
                        BookByVolume.ISBN13__c = (String) result1.get('isbn13');
                        price = (Integer) result1.get('priceSales');
                        BookByVolume.Price__c = String.valueOf(price);
                        BookByVolume.Cover__c = (String) result1.get('cover');
                        BookByVolume.Book__c = LB.Id;
                        ListBookByVolume.add(BookByVolume);
                    }
                }
            }

            insert ListBookByVolume;
        }

        public static void getBookInfo_4(){

            String BASE_URL_BeforeQuery = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbtrstyq0151001&Query=';
            String BASE_URL_AfterQuery = '&QueryType=Title&MaxResults=50&start=1&Cover=Big&SearchTarget=Book&output=JS&Version=20131101';


            List<Book__c> ListBooks = [SELECT Id, Name, Volume__c, Type__c From Book__c where f_Order__c  >= 180 and f_Order__c < 240];
            List<BookByVolume__c> ListBookByVolume = new List<BookByVolume__c>();

            for(Book__c LB : ListBooks){

                String searchWord = LB.Name;

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(BASE_URL_BeforeQuery + searchWord.replace(' ','%20') + BASE_URL_AfterQuery);
                request.setMethod('GET');
                HttpResponse response = http.send(request);

                List<Object> Books = new List<Object>();
                Object Book;
                Integer price;


                if (response.getStatusCode() == 200) {

                    Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Books = (List<Object>) responseBooks.get('item');

                    for(Object objectBook : Books){

                        Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectBook));

                        BookByVolume__c BookByVolume = new BookByVolume__c();
                        BookByVolume.Name = (String) result1.get('title');
                        BookByVolume.ISBN13__c = (String) result1.get('isbn13');
                        price = (Integer) result1.get('priceSales');
                        BookByVolume.Price__c = String.valueOf(price);
                        BookByVolume.Cover__c = (String) result1.get('cover');
                        BookByVolume.Book__c = LB.Id;
                        ListBookByVolume.add(BookByVolume);
                    }
                }
            }

            insert ListBookByVolume;
        }

        public static void getBookInfo_5(){

            String BASE_URL_BeforeQuery = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbtrstyq0151001&Query=';
            String BASE_URL_AfterQuery = '&QueryType=Title&MaxResults=50&start=1&Cover=Big&SearchTarget=Book&output=JS&Version=20131101';


            List<Book__c> ListBooks = [SELECT Id, Name, Volume__c, Type__c From Book__c where f_Order__c  >= 240 and f_Order__c < 300];
            List<BookByVolume__c> ListBookByVolume = new List<BookByVolume__c>();

            for(Book__c LB : ListBooks){

                String searchWord = LB.Name;

                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(BASE_URL_BeforeQuery + searchWord.replace(' ','%20') + BASE_URL_AfterQuery);
                request.setMethod('GET');
                HttpResponse response = http.send(request);

                List<Object> Books = new List<Object>();
                Object Book;
                Integer price;


                if (response.getStatusCode() == 200) {

                    Map<String, Object> responseBooks = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Books = (List<Object>) responseBooks.get('item');

                    for(Object objectBook : Books){

                        Map<String, Object> result1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objectBook));

                        BookByVolume__c BookByVolume = new BookByVolume__c();
                        BookByVolume.Name = (String) result1.get('title');
                        BookByVolume.ISBN13__c = (String) result1.get('isbn13');
                        price = (Integer) result1.get('priceSales');
                        BookByVolume.Price__c = String.valueOf(price);
                        BookByVolume.Cover__c = (String) result1.get('cover');
                        BookByVolume.Book__c = LB.Id;
                        ListBookByVolume.add(BookByVolume);
                    }
                }
            }

            insert ListBookByVolume;
        }

        public static String getBookListInfo(String searchWord){

            String BASE_URL_BeforeQuery = 'https://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=ttbtrstyq0151001&itemIdType=ISBN&ItemId=';
            String BASE_URL_AfterQuery = '&output=xml';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(BASE_URL_BeforeQuery + searchWord + BASE_URL_AfterQuery);
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            String returnValue;

            // If the request is successful, parse the JSON response
            if (response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                // Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                // System.debug('>>>>>'+response.getBody());
                // animals = result.get('animal');
                // System.debug(animals);
                returnValue = response.getBody();
            }

            return returnValue;
        }

        public static String getUsedBookInfo(String searchWord){

            String BASE_URL_BeforeQuery = 'http://www.aladin.co.kr/ttb/api/ItemOffStoreList.aspx?ttbkey=ttbtrstyq0151001&itemIdType=ItemId&ItemId=';
            String BASE_URL_AfterQuery = '&output=xml';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(BASE_URL_BeforeQuery + searchWord + BASE_URL_AfterQuery);
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            String returnValue;

            // If the request is successful, parse the JSON response
            if (response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                // Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                // System.debug('>>>>>'+response.getBody());
                // animals = result.get('animal');
                // System.debug(animals);
                returnValue = response.getBody();
            }

            return returnValue;
        }



}