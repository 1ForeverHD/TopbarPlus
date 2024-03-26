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
.recommended {
    background-color: rgb(126, 194, 136);
}
.required {
    background-color: rgb(231, 101, 104);
}
.optional {
    background-color: rgb(188, 176, 116);
}
.unstable {
    background-color: rgb(204, 134, 80);
}
.deprecated {
    background-color: rgb(227, 87, 75);
}
.yields {
    background-color: rgb(163, 149, 79);
}
.critical {
    background-color: rgb(255, 0, 0);
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
    ["{yields}", '<p class="tag yields">yields</p>'],
    ["{critical}", '<p class="tag critical">critical</p>'],
    ["{chainable}", '<p class="tag chainable">chainable</p>'],
    ["{required}", '<p class="tag required">required</p>'],
    ["{optional}", '<p class="tag optional">optional</p>'],
    ["{recommended}", '<p class="tag recommended">recommended</p>'],
    ["{unstable}", '<p class="tag unstable">unstable</p>'],
    ["{toggleable}", '<p class="tag toggleable">toggleable</p>'],
];

function replace(element) {
    for (var i = 0; i < replaceStuff.length; i++) {
        var from = replaceStuff[i][0]
        var to = replaceStuff[i][1]
        if ((element.innerHTML && element.innerHTML.includes(from))) {
            element.innerHTML = element.innerHTML.replace(from, to)
            element.style.display = "inline"
        }
    }
}

const styleElement = document.createElement("style")
styleElement.innerHTML = style

document.head.appendChild(styleElement)

window.onload = function WindowLoad(event) {
    var elems = document.body.getElementsByTagName("p")
    for (var i = 0; i < elems.length; i++) {
        replace(elems.item(i))
    }
}
