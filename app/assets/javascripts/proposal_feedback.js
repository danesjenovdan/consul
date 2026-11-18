(function() {
  "use strict";
  App.ProposalFeedback = {
    params: function(form, resourceType) {
      var params;
      params = form.serializeArray().filter(function(item) {
        return item.name !== "_method";
      });
      params.push({ name: "resource_type", value: resourceType });
      return $.param(params);
    },
    showError: function(box) {
      var error = $("<small class='error'></small>").text(box.data("error-message"));
      box.find(".proposal-feedback-results").html(error);
    },
    initialize: function() {
      $("body").on("click", ".js-proposal-feedback", function() {
        var form, dataString, button, box;
        button = $(this);
        form = button.closest("form");
        box = button.closest(".proposal-feedback");

        button.prop("disabled", true);
        button.addClass("is-loading");
        box.find(".proposal-feedback-results").empty();

        if (typeof CKEDITOR !== "undefined") {
          for (var name in CKEDITOR.instances) {
            CKEDITOR.instances[name].updateElement();
          }
        }

        dataString = App.ProposalFeedback.params(form, box.data("resource-type"));
        $.ajax({
          url: "/proposal_feedback",
          type: "POST",
          data: dataString,
          dataType: "text",
          success: function(script) {
            $.globalEval(script);
          },
          error: function() {
            App.ProposalFeedback.showError(box);
            button.prop("disabled", false);
            button.removeClass("is-loading");
          }
        });
      });
    }
  };
}).call(this);
