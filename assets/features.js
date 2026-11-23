(function () {
  var dialog = document.querySelector(".feature-dialog");
  if (!dialog) return;

  function open(card) {
    document.getElementById("fd-ico").textContent = card.querySelector(".ico").textContent;
    document.getElementById("fd-title").textContent = card.querySelector("h3").textContent;
    document.getElementById("fd-list").innerHTML = card.querySelector(".more").innerHTML;
    dialog.showModal();
  }

  document.querySelectorAll(".feature[role=button]").forEach(function (card) {
    card.addEventListener("click", function () { open(card); });
    card.addEventListener("keydown", function (e) {
      if (e.key === "Enter" || e.key === " ") { e.preventDefault(); open(card); }
    });
  });

  dialog.addEventListener("click", function (e) {
    if (e.target === dialog) dialog.close();
  });
})();
