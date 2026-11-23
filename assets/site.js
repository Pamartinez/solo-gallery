// Shared header/footer so every page stays identical. Pages set data-root to their path back to the site root.
(function () {
  var root = document.body.dataset.root || "";
  var here = location.pathname.replace(/index\.html$/, "");

  function link(href, label) {
    var full = root + href;
    var current = here.endsWith("/" + href.replace(/index\.html$/, "")) ? ' aria-current="page"' : "";
    return '<a href="' + full + '"' + current + ">" + label + "</a>";
  }

  var header = document.createElement("header");
  header.className = "site-header";
  header.innerHTML =
    '<div class="wrap">' +
    '<a class="brand" href="' + root + 'index.html"><img src="' + root + 'assets/logo.svg" alt=""><span>Solo Gallery</span></a>' +
    '<nav class="nav">' + link("index.html", "Apps") + link("support.html", "Support") + "</nav>" +
    "</div>";

  var footer = document.createElement("footer");
  footer.className = "site-footer";
  footer.innerHTML =
    '<div class="wrap">' +
    "<span>&copy; " + new Date().getFullYear() + " Pablo Martinez</span>" +
    "<nav>" +
    link("photos/privacy.html", "Solo Photos privacy") +
    link("videos/privacy.html", "Solo Videos privacy") +
    link("terms.html", "Terms") +
    link("support.html", "Support") +
    "</nav></div>";

  document.body.prepend(header);
  document.body.append(footer);
})();
