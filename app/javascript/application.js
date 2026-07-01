// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";

window.copyClip = function (id) {
  var textarea = document.getElementById("clip-content-" + id);
  if (!textarea) return;

  navigator.clipboard.writeText(textarea.value).then(function () {
    var msg = document.getElementById("copy-msg-" + id);

    if (msg) {
      msg.classList.remove("hidden");

      setTimeout(function () {
        msg.classList.add("hidden");
      }, 2000);
    }
  });
};
