$(document).ready( function(){

    if ($('#vodafone-status').length > 0) {
        VHA_A.record.push(['tnt', {
            trackingID: $('.order-number').html(),
            orderStatus: $('#vodafone-status').html()
        }]);
    }
});