App.cources = App.cable.subscriptions.create("CourcesChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    $('#dollar-value').text(data.dollar_value);
    $('#euro-value').text(data.euro_value);
  }
});
