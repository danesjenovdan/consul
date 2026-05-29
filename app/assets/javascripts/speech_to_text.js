(function() {
  "use strict";
  App.SpeechToText = {
    MAX_RECORDING_MS: 60000,
    TIMESLICE_MS: 1000,
    initialize: function() {
      $("body").on("click", ".js-speech-to-text", function() {
        var button;
        button = $(this);
        if (button.data("state") === "recording") {
          App.SpeechToText.stopRecording(button);
        } else if (button.data("state") === "idle") {
          App.SpeechToText.startRecording(button);
        }
      });
    },
    wrapperFor: function(button) {
      return button.closest(".speech-to-text-wrapper");
    },
    textareaFor: function(wrapper) {
      return document.getElementById(wrapper.data("textarea-id"));
    },
    editorFor: function(textarea) {
      var instanceName;
      if (typeof CKEDITOR === "undefined" || !textarea) {
        return null;
      }
      instanceName = textarea.id || textarea.name;
      if (!instanceName) {
        return null;
      }
      return CKEDITOR.instances[instanceName];
    },
    updateButtonState: function(button, state) {
      var label;
      if (state === "recording") {
        label = button.data("label-recording");
      } else if (state === "loading") {
        label = button.data("label-loading");
      } else {
        label = button.data("label-idle");
      }
      button.data("state", state);
      button.attr("data-state", state);
      button.text(label);
      button.prop("disabled", state === "loading");
      button.attr("aria-busy", state === "loading");
    },
    showError: function(wrapper, message) {
      wrapper.find(".js-speech-to-text-error").text(message).removeClass("hide");
    },
    clearError: function(wrapper) {
      wrapper.find(".js-speech-to-text-error").text("").addClass("hide");
    },
    supportedMimeType: function() {
      var candidates;
      candidates = ["audio/webm;codecs=opus", "audio/webm", "audio/mp4", "audio/ogg"];
      if (typeof MediaRecorder === "undefined" || typeof MediaRecorder.isTypeSupported !== "function") {
        return "";
      }
      return candidates.find(function(candidate) {
        return MediaRecorder.isTypeSupported(candidate);
      }) || "";
    },
    captureInsertionAnchor: function(wrapper, textarea) {
      var editor, selection;
      editor = App.SpeechToText.editorFor(textarea);
      if (editor) {
        selection = editor.getSelection();
        if (selection) {
          wrapper.data("speech-bookmark", selection.createBookmarks(true));
        }
      } else if (textarea) {
        wrapper.data("selection-start", textarea.selectionStart || 0);
        wrapper.data("selection-end", textarea.selectionEnd || 0);
      }
    },
    startRecording: function(button) {
      var wrapper, textarea, mimeType;
      wrapper = App.SpeechToText.wrapperFor(button);
      textarea = App.SpeechToText.textareaFor(wrapper);
      App.SpeechToText.clearError(wrapper);
      if (!navigator.mediaDevices || typeof navigator.mediaDevices.getUserMedia !== "function") {
        App.SpeechToText.showError(wrapper, button.data("error-unsupported-browser"));
        return;
      }
      mimeType = App.SpeechToText.supportedMimeType();
      if (!mimeType) {
        App.SpeechToText.showError(wrapper, button.data("error-unsupported-browser"));
        return;
      }
      App.SpeechToText.captureInsertionAnchor(wrapper, textarea);
      navigator.mediaDevices.getUserMedia({ audio: true }).then(function(stream) {
        var chunks, recorder, timeoutId;
        chunks = [];
        recorder = new MediaRecorder(stream, { mimeType: mimeType });
        wrapper.data("speech-stream", stream);
        wrapper.data("speech-recorder", recorder);
        wrapper.data("speech-chunks", chunks);
        recorder.ondataavailable = function(event) {
          if (event.data && event.data.size > 0) {
            chunks.push(event.data);
          }
        };
        recorder.onerror = function() {
          App.SpeechToText.showError(wrapper, button.data("error-transcription-failed"));
          App.SpeechToText.reset(wrapper, button);
        };
        recorder.onstop = function() {
          var blob;
          stream.getTracks().forEach(function(track) {
            track.stop();
          });
          clearTimeout(wrapper.data("speech-timeout-id"));
          wrapper.removeData("speech-timeout-id");
          blob = new Blob(chunks, { type: recorder.mimeType });
          App.SpeechToText.sendAudio(wrapper, button, blob);
        };
        recorder.start(App.SpeechToText.TIMESLICE_MS);
        timeoutId = setTimeout(function() {
          App.SpeechToText.stopRecording(button);
        }, App.SpeechToText.MAX_RECORDING_MS);
        wrapper.data("speech-timeout-id", timeoutId);
        App.SpeechToText.updateButtonState(button, "recording");
      }).catch(function() {
        App.SpeechToText.showError(wrapper, button.data("error-microphone-blocked"));
      });
    },
    stopRecording: function(button) {
      var recorder, wrapper;
      wrapper = App.SpeechToText.wrapperFor(button);
      recorder = wrapper.data("speech-recorder");
      if (!recorder || recorder.state === "inactive") {
        App.SpeechToText.updateButtonState(button, "idle");
        return;
      }
      App.SpeechToText.updateButtonState(button, "loading");
      recorder.stop();
    },
    insertTranscript: function(wrapper, text) {
      var textarea, editor, bookmark, selectionStart, selectionEnd, value;
      textarea = App.SpeechToText.textareaFor(wrapper);
      editor = App.SpeechToText.editorFor(textarea);
      if (editor) {
        bookmark = wrapper.data("speech-bookmark");
        if (bookmark) {
          try {
            editor.getSelection().selectBookmarks(bookmark);
          } catch (error) {
          }
        }
        editor.insertText(text);
        wrapper.data("speech-bookmark", editor.getSelection().createBookmarks(true));
        editor.updateElement();
        return;
      }
      if (!textarea) {
        return;
      }
      selectionStart = wrapper.data("selection-start");
      selectionEnd = wrapper.data("selection-end");
      selectionStart = typeof selectionStart === "number" ? selectionStart : textarea.value.length;
      selectionEnd = typeof selectionEnd === "number" ? selectionEnd : selectionStart;
      value = textarea.value;
      textarea.value = value.slice(0, selectionStart) + text + value.slice(selectionEnd);
      wrapper.data("selection-start", selectionStart + text.length);
      wrapper.data("selection-end", selectionStart + text.length);
      textarea.dispatchEvent(new Event("input", { bubbles: true }));
    },
    sendAudio: function(wrapper, button, blob) {
      var endpoint, locale, csrfToken, formData;
      endpoint = wrapper.data("endpoint");
      locale = wrapper.data("locale");
      csrfToken = $("meta[name='csrf-token']").attr("content");
      formData = new FormData();
      formData.append("audio_file", blob, "dictation.webm");
      formData.append("locale", locale);
      $.ajax({
        url: endpoint,
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        dataType: "json",
        headers: { "X-CSRF-Token": csrfToken },
        success: function(response) {
          App.SpeechToText.insertTranscript(wrapper, response.text || "");
          App.SpeechToText.reset(wrapper, button);
        },
        error: function(xhr) {
          var message;
          message = xhr.responseJSON && xhr.responseJSON.errors ? xhr.responseJSON.errors : button.data("error-transcription-failed");
          App.SpeechToText.showError(wrapper, message);
          App.SpeechToText.reset(wrapper, button);
        }
      });
    },
    reset: function(wrapper, button) {
      App.SpeechToText.updateButtonState(button, "idle");
      wrapper.removeData("speech-recorder");
      wrapper.removeData("speech-stream");
      wrapper.removeData("speech-chunks");
    }
  };
}).call(this);
