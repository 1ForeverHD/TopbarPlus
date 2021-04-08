const style = `.tag {
    color: #ffffff;
    line-height: .8rem;
    padding: 5px;
    margin-left: 7px !important;
    margin: 0 !important; 
    background-clip: padding-box;
    border-radius: 3px;
    display: inline-block;
    font-size: .7rem;
    font-family: "Roboto";
    font-weight: normal;
}
.static {
    background-color: rgb(38, 70, 83);
}
.read-only {
    background-color: rgb(42, 157, 143);
}
.client-only {
    background-color: rgb(89, 140, 206);
}
.server-only {
    background-color: rgb(89, 140, 206);
}
.toggleable {
    background-color: rgb(178, 92, 162);
}
.chainable {
    background-color: rgb(122, 103, 231);
}
.unstable {
    background-color: rgb(204, 134, 80);
}
.deprecated {
    background-color: rgb(227, 87, 75);
}
h4 {
    display: inline;
}`

var replaceStuff = [
	["{read-only}", '<p class="tag read-only">read-only</p>'],
	["{static}", '<p class="tag static">static</p>'],
	["{server-only}", '<p class="tag server-only">server-only</p>'],
	["{client-only}", '<p class="tag client-only">client-only</p>'],
	["{deprecated}", '<p class="tag deprecated">deprecated</p>'],
	["{chainable}", '<p class="tag chainable">chainable</p>'],
	["{unstable}", '<p class="tag unstable">unstable</p>'],
	["{toggleable}", '<p class="tag toggleable">toggleable</p>'],
];

function replace(element, from, to) {
	if (element.childNodes.length) {
		element.childNodes.forEach(child => replace(child, from, to));
	} else {
		const cont = element.textContent;
		if (cont && cont.includes(from)) {
			var newElement = document.createElement("p");
			element.parentNode.replaceWith(newElement);
			newElement.outerHTML = to;
		}
	}
};

for (var i = 0; i < replaceStuff.length; i++) {
	replace(document.body, replaceStuff[i][0], replaceStuff[i][1]);
}

const styleElement = document.createElement("style")
styleElement.innerHTML = style

document.head.appendChild(styleElement)