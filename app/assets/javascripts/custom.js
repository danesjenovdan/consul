// Add calls to your custom JavaScript code using this file.
//
// We recommend creating your custom JavaScript code under the
// `app/assets/javascripts/custom/` folder and calling it from here.
//
// See the `docs/en/customization/javascript.md` file for more information.

var initialize_modules = function() {
  "use strict";

  // Add calls to your custom code here; this will be called when
  // loading a page.
};

var destroy_non_idempotent_modules = function() {
  "use strict";

  // Add calls to your custom code here when your JavaScript code added
  // in `initialize_modules` is not idempotent.
};

$(document).on("turbolinks:load", initialize_modules);
$(document).on("turbolinks:before-cache", destroy_non_idempotent_modules);

// TODO THIS SHOULD BE INTEGRATED SOMEHOW
// (function() {
//     "use strict";
//     App.Forms = {
//       disableDecimalsForInvestmentPrice: function() {
//         var inputField = document.querySelector('#budget_investment_price');
//         if (inputField) {
//             inputField.onkeydown = function(event) {
//                 // Only allow if the e.key value is a number or if it's 'Backspace'
//                 if(isNaN(event.key) && event.key !== 'Backspace') {
//                     event.preventDefault();
//                 }
//             };
//         }
//       },
//       initialize: function() {
//         App.Forms.disableDecimalsForInvestmentPrice();
//       }
//     };
//   }).call(this);
