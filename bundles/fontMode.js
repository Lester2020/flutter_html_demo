function initCSS(css) {
    head = document.head || document.getElementsByTagName('head')[0],
    style = document.createElement('style');

    head.appendChild(style);

    style.type = 'text/css';
    if (style.styleSheet){
        // This is required for IE8 and below.
        style.styleSheet.cssText = css;
    } else {
        style.appendChild(document.createTextNode(css));
    }
}

function fontSizeChanged(size1, size2) {
    var titleSize = size1 + "px";
    document.getElementsByClassName('title')[0].style.setProperty("font-size", titleSize);
    var contentSize = size2 + "px";
    document.getElementById('content').style.setProperty("font-size", contentSize);
}
