function isValidOrderId(order_id) {
  var order_id_format = /^(VF|UP|1-|SR1-)[a-zA-Z0-9]+$/i;
  return order_id.length <= 15 && order_id_format.test(order_id);
}

function orderIdEntered() {
  return $.trim( $("#tracking_id").val());
}
