// Overrides and adds customized javascripts in this file
// Read more on documentation:
// * English: https://github.com/consul/consul/blob/master/CUSTOMIZE_EN.md#javascript
// * Spanish: https://github.com/consul/consul/blob/master/CUSTOMIZE_ES.md#javascript
//
//

(function() {
    "use strict";
    App.Forms = {
      disableDecimalsForInvestmentPrice: function() {
        var inputField = document.querySelector('#budget_investment_price');
        if (inputField) {
            inputField.onkeydown = function(event) {
                // Only allow if the e.key value is a number or if it's 'Backspace'
                if(isNaN(event.key) && event.key !== 'Backspace') {
                    event.preventDefault();
                }
            };
        }
      },
      initialize: function() {
        App.Forms.disableDecimalsForInvestmentPrice();
      }
    };
  }).call(this);
  