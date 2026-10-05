(function() {
  "use strict";
  App.ProposalFeedback = {
    initialize: function() {
      $("body").on("click", ".js-proposal-feedback", function() {
        var form, dataString, button;
        button = $(this);
        form = button.closest("form");

        button.prop("disabled", true);
        button.addClass("is-loading");

        if (typeof CKEDITOR !== "undefined") {
          for (var name in CKEDITOR.instances) {
            CKEDITOR.instances[name].updateElement();
          }
        }

        dataString = $.param(form.serializeArray().filter(function(item) {
          return item.name !== "_method";
        }));
        $.ajax({
          url: "/proposal_feedback",
          type: "POST",
          data: dataString,
          dataType: "text",
          success: function(script) {
            $.globalEval(script);
          },
          error: function() {
            button.prop("disabled", false);
            button.removeClass("is-loading");
          }
        });
      });
    }
  };
}).call(this);
