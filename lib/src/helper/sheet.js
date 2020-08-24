function doGet(request) {
    var sheet = SpreadsheetApp.openById("1ZOFMt2MFzZBek_gadhxuJ1AiPKCzWDO4u2KLma6WgJg");
    var result = { 'status': 'SUCCESS' };

    try {

        var name = request.parameter.name;
        var number = request.parameter.number;
        var address = request.parameter.address;
        var products = request.parameter.products;
        var noOfProducts = request.parameter.noOfProducts;
        var orderDate = request.parameter.orderDate;
        var deliveryDate = request.parameter.deliveryDate;
        var price = request.parameter.price;

        sheet.appendRow([name, number, address, products, noOfProducts, orderDate, deliveryDate, price]);

    } catch (e) {
        var result = { 'status': 'FAILED', 'message': e };
    }

    return ContentService.createTextOutput(JSON.stringify(result)).setMimeType(ContentService.MimeType.JSON);
}