document.addEventListener("DOMContentLoaded", () => {
  const menuButton = document.querySelector("[data-menu-button]");
  const menu = document.querySelector("[data-menu]");

  if (menuButton && menu) {
    const closeMenu = () => {
      menuButton.classList.remove("is-active");
      menuButton.setAttribute("aria-expanded", "false");
      menu.classList.remove("is-active");
    };

    menuButton.addEventListener("click", () => {
      const isOpen = menuButton.classList.toggle("is-active");
      menuButton.setAttribute("aria-expanded", String(isOpen));
      menu.classList.toggle("is-active", isOpen);
    });

    menu.querySelectorAll("a").forEach((link) => {
      link.addEventListener("click", closeMenu);
    });
  }

  const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const observedVideos = document.querySelectorAll("[data-observe-video]");

  if (!reducedMotion && "IntersectionObserver" in window) {
    const videoObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          const video = entry.target;
          if (entry.isIntersecting && video.muted && video.hasAttribute("data-autoplay")) {
            video.play().catch(() => {});
          } else if (!entry.isIntersecting && !video.paused) {
            video.pause();
          }
        });
      },
      { rootMargin: "120px 0px", threshold: 0.35 }
    );

    observedVideos.forEach((video) => videoObserver.observe(video));
  }

  const copyButton = document.querySelector("[data-copy-citation]");
  const citation = document.querySelector("#bibtex");

  if (copyButton && citation) {
    copyButton.addEventListener("click", async () => {
      try {
        await navigator.clipboard.writeText(citation.textContent.trim());
        copyButton.textContent = "Copied";
        window.setTimeout(() => {
          copyButton.textContent = "Copy BibTeX";
        }, 1800);
      } catch {
        copyButton.textContent = "Select text to copy";
      }
    });
  }
});
