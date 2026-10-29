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
    initialize: function() {
      $("body").on("click", ".js-proposal-feedback", function() {
        var form, dataString, button, resourceType;
        button = $(this);
        form = button.closest("form");
        resourceType = button.closest(".proposal-feedback").data("resource-type");

        button.prop("disabled", true);
        button.addClass("is-loading");

        if (typeof CKEDITOR !== "undefined") {
          for (var name in CKEDITOR.instances) {
            CKEDITOR.instances[name].updateElement();
          }
        }

        dataString = App.ProposalFeedback.params(form, resourceType);
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
