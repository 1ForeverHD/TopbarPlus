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

var inner = document.body.innerHTML
inner = inner.replace(/{read-only}/g, '<p class="tag read-only">read-only</p>');
inner = inner.replace(/{static}/g, '<p class="tag static">static</p>');
inner = inner.replace(/{server-only}/g, '<p class="tag server-only">server-only</p>');
inner = inner.replace(/{client-only}/g, '<p class="tag client-only">client-only</p>');
inner = inner.replace(/{deprecated}/g, '<p class="tag deprecated">deprecated</p>');
inner = inner.replace(/{chainable}/g, '<p class="tag chainable">chainable</p>');
inner = inner.replace(/{unstable}/g, '<p class="tag unstable">unstable</p>');
inner = inner.replace(/{toggleable}/g, '<p class="tag toggleable">toggleable</p>');
document.body.innerHTML = inner

const styleElement = document.createElement("style")
styleElement.innerHTML = style

document.head.appendChild(styleElement)

function cleaner(el) {
	if (el.innerHTML === '&nbsp;' || el.innerHTML === '') {
		el.parentNode.removeChild(el);
	}
}

const elements = document.querySelectorAll('p');
elements.forEach(cleaner);