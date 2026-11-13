function markExternalTabs() {
	for (const link of document.querySelectorAll('.md-tabs__link[href^="http"]')) {
		link.classList.add("hda-external-link");
		link.target = "_blank";
		link.rel = "noopener";
	}
}

if (window.document$) {
	window.document$.subscribe(markExternalTabs);
} else {
	markExternalTabs();
}
