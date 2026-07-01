// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";

function copyClip(id) {
  let textarea = document.getElementById("clip-content-" + id);
  navigator.clipboard.writeText(textarea.value).then(function () {
    var msg = document.getElementById("copy-msg-" + id);
    msg.classList.remove("hidden");

    setTimeout(function () {
      msg.classList.add("hidden");
    }, 2000);
  });
}
